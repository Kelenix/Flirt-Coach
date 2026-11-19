-- Étape 12 (ADR-031) : code d'accès Premium pour les testeurs des stores, qui n'ont le droit
-- ni d'acheter ni d'utiliser un essai gratuit. Le code n'est jamais stocké en clair : la
-- fonction « redeem-code » compare son empreinte SHA-256 au secret
-- REVIEW_ACCESS_CODE_SHA256, puis appelle redeem_access_code. Un compte ne l'active qu'une
-- fois, le nombre d'activations par code est plafonné et les essais sont limités.

create table public.access_code_redemptions (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  code_hash text not null,
  redeemed_at timestamptz not null default now()
);
create index access_code_redemptions_code_idx on public.access_code_redemptions (code_hash);

create table public.access_code_attempts (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now()
);
create index access_code_attempts_user_created_idx
  on public.access_code_attempts (user_id, created_at desc);

-- Usage interne : aucune règle d'accès client.
alter table public.access_code_redemptions enable row level security;
alter table public.access_code_attempts enable row level security;

create function public.access_code_attempts_per_hour() returns int
language sql immutable as $$ select 5 $$;

-- Résultat : 'granted' (avec l'échéance), 'invalid', 'unavailable' (déjà utilisé par ce
-- compte, compte déjà Premium ou plafond atteint) ou 'rate_limited'.
create function public.redeem_access_code(
  p_user uuid,
  p_code_hash text,
  p_valid boolean,
  p_max_redemptions int,
  p_days int
) returns table (status text, expires_at timestamptz)
language plpgsql security definer set search_path = '' as $$
declare
  v_until timestamptz;
begin
  -- Un appel à la fois : le plafond et la limite d'essais ne peuvent pas être dépassés
  -- par des requêtes simultanées (volume très faible).
  perform pg_advisory_xact_lock(hashtext('public.redeem_access_code'));

  if (select count(*) from public.access_code_attempts a
      where a.user_id = p_user and a.created_at > now() - interval '1 hour')
     >= public.access_code_attempts_per_hour() then
    return query select 'rate_limited', null::timestamptz;
    return;
  end if;
  insert into public.access_code_attempts (user_id) values (p_user);

  if not p_valid then
    return query select 'invalid', null::timestamptz;
    return;
  end if;

  if public.is_premium(p_user)
     or exists (select 1 from public.access_code_redemptions r where r.user_id = p_user)
     or (select count(*) from public.access_code_redemptions r
         where r.code_hash = p_code_hash) >= p_max_redemptions then
    return query select 'unavailable', null::timestamptz;
    return;
  end if;

  v_until := now() + make_interval(days => p_days);
  insert into public.access_code_redemptions (user_id, code_hash) values (p_user, p_code_hash);
  perform public.set_premium(p_user, true, 'access_code', v_until);
  return query select 'granted', v_until;
end;
$$;

revoke execute on function public.redeem_access_code(uuid, text, boolean, int, int)
  from public, anon, authenticated;
grant execute on function public.redeem_access_code(uuid, text, boolean, int, int)
  to service_role;
