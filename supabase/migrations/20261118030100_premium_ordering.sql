-- Inc-5 : les webhooks d'achat peuvent arriver dans le désordre. Un événement portant une
-- échéance plus ancienne ne remplace pas un état plus récent, sauf remboursement (p_force).

drop function public.set_premium(uuid, boolean, text, timestamptz);

create function public.set_premium(
  p_user uuid,
  p_is_premium boolean,
  p_product text,
  p_expires_at timestamptz,
  p_force boolean default false
) returns void
language sql security definer set search_path = '' as $$
  insert into public.entitlements (user_id, is_premium, product_id, expires_at, updated_at)
  values (p_user, p_is_premium, p_product, p_expires_at, now())
  on conflict (user_id) do update
  set is_premium = excluded.is_premium,
      product_id = excluded.product_id,
      expires_at = excluded.expires_at,
      updated_at = now()
  where p_force
     or public.entitlements.expires_at is null
     or excluded.expires_at is null
     or excluded.expires_at >= public.entitlements.expires_at;
$$;

revoke execute on function public.set_premium(uuid, boolean, text, timestamptz, boolean)
  from public, anon, authenticated;
grant execute on function public.set_premium(uuid, boolean, text, timestamptz, boolean)
  to service_role;
