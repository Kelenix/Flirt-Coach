-- Inc-1 : crédits, droits Premium, générations (INTAKE §2.1, §3.2 ; ADR-005).
-- Le client lit ses lignes sous RLS ; toute écriture passe par l'Edge Function
-- (rôle service_role) via les fonctions ci-dessous.

create type public.generation_kind as enum (
  'reply', 'opener', 'flirt', 'follow_up', 'pre_date', 'apology', 'soft_breakup',
  'screenshot', 'respect_check', 'conversation_analysis'
);

create type public.message_style as enum (
  'classic', 'funny', 'romantic', 'mysterious', 'direct', 'elegant', 'playful_bold'
);

create type public.credit_kind as enum (
  'daily_use', 'bonus_use', 'refund', 'purchase', 'ad_reward'
);

-- Solde courant. `daily_credits` est remis à la valeur quotidienne au premier
-- mouvement d'une nouvelle journée (UTC) ; `bonus_credits` n'expire pas.
create table public.credit_balances (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  daily_credits int not null default 5 check (daily_credits between 0 and 5),
  daily_reset_on date not null default (now() at time zone 'utc')::date,
  bonus_credits int not null default 0 check (bonus_credits >= 0),
  updated_at timestamptz not null default now()
);

-- Journal immuable des mouvements (audit, support, litiges d'achat).
create table public.credit_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  amount int not null check (amount <> 0),
  kind public.credit_kind not null,
  reference text,
  created_at timestamptz not null default now()
);
create index credit_transactions_user_created_idx
  on public.credit_transactions (user_id, created_at desc);

-- Droits Premium (écrits par le webhook d'achats en Inc-5).
create table public.entitlements (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  is_premium boolean not null default false,
  product_id text,
  expires_at timestamptz,
  updated_at timestamptz not null default now()
);

-- Générations : historique Premium (Inc-9), base des signalements (Inc-10),
-- et compteur du plafond journalier Premium.
create table public.generations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  kind public.generation_kind not null,
  style public.message_style not null,
  input_text text check (char_length(input_text) <= 4000),
  output jsonb not null,
  created_at timestamptz not null default now()
);
create index generations_user_created_idx
  on public.generations (user_id, created_at desc);

alter table public.credit_balances enable row level security;
alter table public.credit_transactions enable row level security;
alter table public.entitlements enable row level security;
alter table public.generations enable row level security;

create policy credit_balances_select_own on public.credit_balances
  for select to authenticated using ((select auth.uid()) = user_id);
create policy credit_transactions_select_own on public.credit_transactions
  for select to authenticated using ((select auth.uid()) = user_id);
create policy entitlements_select_own on public.entitlements
  for select to authenticated using ((select auth.uid()) = user_id);
-- L'historique n'est lisible qu'en Premium (INTAKE §2.7).
create policy generations_select_own_premium on public.generations
  for select to authenticated
  using (
    (select auth.uid()) = user_id
    and exists (
      select 1 from public.entitlements e
      where e.user_id = (select auth.uid())
        and e.is_premium
        and (e.expires_at is null or e.expires_at > now())
    )
  );
create policy generations_delete_own on public.generations
  for delete to authenticated using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- Règles de crédit
-- ---------------------------------------------------------------------------

create function public.daily_credit_allowance() returns int
language sql immutable as $$ select 5 $$;

create function public.premium_daily_limit() returns int
language sql immutable as $$ select 100 $$;

create function public.is_premium(p_user uuid) returns boolean
language sql stable security definer set search_path = '' as $$
  select coalesce((
    select e.is_premium and (e.expires_at is null or e.expires_at > now())
    from public.entitlements e where e.user_id = p_user
  ), false);
$$;

-- Un solde est ouvert pour chaque profil.
create function public.handle_new_profile() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.credit_balances (user_id) values (new.id);
  return new;
end;
$$;

create trigger on_profile_created
  after insert on public.profiles
  for each row execute function public.handle_new_profile();

-- Verrouille le solde et applique la remise quotidienne si la date a changé.
create function public.lock_balance(p_user uuid)
returns public.credit_balances
language plpgsql security definer set search_path = '' as $$
declare
  v_balance public.credit_balances;
  v_today date := (now() at time zone 'utc')::date;
begin
  select * into v_balance from public.credit_balances
  where user_id = p_user for update;
  if not found then
    raise exception 'unknown_user' using errcode = 'P0002';
  end if;
  if v_balance.daily_reset_on < v_today then
    update public.credit_balances
    set daily_credits = public.daily_credit_allowance(),
        daily_reset_on = v_today, updated_at = now()
    where user_id = p_user
    returning * into v_balance;
  end if;
  return v_balance;
end;
$$;

-- Réserve le coût d'une génération avant l'appel IA. Gratuit : débite les
-- crédits du jour puis les bonus. Premium : aucun débit, mais plafond journalier.
-- Renvoie ce qui a été pris, pour un remboursement exact en cas d'échec.
create function public.spend_credits(p_user uuid, p_cost int, p_reference text)
returns table (from_daily int, from_bonus int)
language plpgsql security definer set search_path = '' as $$
declare
  v_balance public.credit_balances;
  v_daily int;
  v_bonus int;
begin
  if p_cost <= 0 then
    raise exception 'invalid_cost' using errcode = '22023';
  end if;
  v_balance := public.lock_balance(p_user);

  if public.is_premium(p_user) then
    if (select count(*) from public.generations g
        where g.user_id = p_user
          and g.created_at >= (now() at time zone 'utc')::date::timestamp at time zone 'utc')
       >= public.premium_daily_limit() then
      raise exception 'daily_limit' using errcode = 'P0001';
    end if;
    return query select 0, 0;
    return;
  end if;

  if v_balance.daily_credits + v_balance.bonus_credits < p_cost then
    raise exception 'insufficient_credits' using errcode = 'P0001';
  end if;

  v_daily := least(v_balance.daily_credits, p_cost);
  v_bonus := p_cost - v_daily;

  update public.credit_balances
  set daily_credits = daily_credits - v_daily,
      bonus_credits = bonus_credits - v_bonus,
      updated_at = now()
  where user_id = p_user;

  if v_daily > 0 then
    insert into public.credit_transactions (user_id, amount, kind, reference)
    values (p_user, -v_daily, 'daily_use', p_reference);
  end if;
  if v_bonus > 0 then
    insert into public.credit_transactions (user_id, amount, kind, reference)
    values (p_user, -v_bonus, 'bonus_use', p_reference);
  end if;

  return query select v_daily, v_bonus;
end;
$$;

-- Rend ce que spend_credits a pris. Les crédits du jour ne sont rendus que si
-- la journée n'a pas changé entre-temps (sinon ils ont déjà été remis à neuf).
create function public.refund_credits(
  p_user uuid, p_daily int, p_bonus int, p_reference text
) returns void
language plpgsql security definer set search_path = '' as $$
declare
  v_balance public.credit_balances;
  v_spent_on date;
  v_restored_daily int := 0;
begin
  if p_daily = 0 and p_bonus = 0 then
    return;
  end if;
  -- Date de la journée en cours au moment du débit, lue avant une éventuelle remise.
  select daily_reset_on into v_spent_on from public.credit_balances
  where user_id = p_user for update;
  v_balance := public.lock_balance(p_user);
  if v_spent_on = v_balance.daily_reset_on then
    v_restored_daily := least(p_daily,
      public.daily_credit_allowance() - v_balance.daily_credits);
  end if;

  update public.credit_balances
  set daily_credits = daily_credits + v_restored_daily,
      bonus_credits = bonus_credits + p_bonus,
      updated_at = now()
  where user_id = p_user;

  if v_restored_daily + p_bonus > 0 then
    insert into public.credit_transactions (user_id, amount, kind, reference)
    values (p_user, v_restored_daily + p_bonus, 'refund', p_reference);
  end if;
end;
$$;

-- Portefeuille de l'appelant, avec la remise quotidienne appliquée à la lecture.
create function public.get_wallet()
returns table (daily_credits int, bonus_credits int, is_premium boolean)
language sql stable security definer set search_path = '' as $$
  select
    case when b.daily_reset_on < (now() at time zone 'utc')::date
         then public.daily_credit_allowance() else b.daily_credits end,
    b.bonus_credits,
    public.is_premium(b.user_id)
  from public.credit_balances b
  where b.user_id = (select auth.uid());
$$;

-- Droits d'exécution : fonctions d'écriture réservées au service_role.
revoke execute on function public.handle_new_profile() from public, anon, authenticated;
revoke execute on function public.lock_balance(uuid) from public, anon, authenticated;
revoke execute on function public.spend_credits(uuid, int, text) from public, anon, authenticated;
revoke execute on function public.refund_credits(uuid, int, int, text) from public, anon, authenticated;
revoke execute on function public.is_premium(uuid) from public, anon, authenticated;
grant execute on function public.spend_credits(uuid, int, text) to service_role;
grant execute on function public.refund_credits(uuid, int, int, text) to service_role;
revoke execute on function public.get_wallet() from public, anon;
grant execute on function public.get_wallet() to authenticated;

-- Comptes créés avant cette migration.
insert into public.credit_balances (user_id)
select id from public.profiles on conflict do nothing;
