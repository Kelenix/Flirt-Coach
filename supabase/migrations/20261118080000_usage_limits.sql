-- Phase 5 (revue de sécurité S1, S2) : chaque tentative d'appel IA est comptée AVANT
-- l'appel, sous le verrou du portefeuille de l'utilisateur.
-- Avant : le plafond Premium comptait les générations enregistrées après l'appel, donc des
-- requêtes simultanées le dépassaient, et les tentatives remboursées (refus, capture
-- illisible) n'étaient jamais limitées.
-- Désormais, pour tout utilisateur : 10 tentatives par minute, 100 par jour (UTC).

create table public.ai_usage (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles (id) on delete cascade,
  reference text not null,
  created_at timestamptz not null default now()
);
create index ai_usage_user_created_idx on public.ai_usage (user_id, created_at desc);

-- Usage interne : aucune règle d'accès client.
alter table public.ai_usage enable row level security;

create function public.ai_rate_limit_per_minute() returns int
language sql immutable as $$ select 10 $$;

create or replace function public.spend_credits(p_user uuid, p_cost int, p_reference text)
returns table (from_daily int, from_bonus int)
language plpgsql security definer set search_path = '' as $$
declare
  v_balance public.credit_balances;
  v_daily int;
  v_bonus int;
  v_today timestamptz := (now() at time zone 'utc')::date::timestamp at time zone 'utc';
begin
  if p_cost <= 0 then
    raise exception 'invalid_cost' using errcode = '22023';
  end if;
  -- Verrou par utilisateur : des tentatives simultanées sont comptées une à une.
  v_balance := public.lock_balance(p_user);

  if (select count(*) from public.ai_usage u
      where u.user_id = p_user and u.created_at > now() - interval '1 minute')
     >= public.ai_rate_limit_per_minute() then
    raise exception 'rate_limited' using errcode = 'P0001';
  end if;
  if (select count(*) from public.ai_usage u
      where u.user_id = p_user and u.created_at >= v_today)
     >= public.premium_daily_limit() then
    raise exception 'daily_limit' using errcode = 'P0001';
  end if;

  if public.is_premium(p_user) then
    insert into public.ai_usage (user_id, reference) values (p_user, p_reference);
    return query select 0, 0;
    return;
  end if;

  if v_balance.daily_credits + v_balance.bonus_credits < p_cost then
    raise exception 'insufficient_credits' using errcode = 'P0001';
  end if;
  insert into public.ai_usage (user_id, reference) values (p_user, p_reference);

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
