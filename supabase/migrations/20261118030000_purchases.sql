-- Inc-5 : crédits achetés et droits Premium, écrits par le webhook d'achats (INTAKE §3).

-- Un même achat (ou une même récompense publicitaire) ne crédite jamais deux fois.
create unique index credit_transactions_purchase_reference_idx
  on public.credit_transactions (reference)
  where kind in ('purchase', 'ad_reward');

-- Ajoute des crédits bonus (sans expiration). Renvoie false si la référence a déjà
-- été créditée : les webhooks peuvent être rejoués sans risque.
create function public.grant_credits(
  p_user uuid, p_amount int, p_kind public.credit_kind, p_reference text
) returns boolean
language plpgsql security definer set search_path = '' as $$
begin
  if p_amount <= 0 or p_kind not in ('purchase', 'ad_reward') or p_reference is null then
    raise exception 'invalid_grant' using errcode = '22023';
  end if;
  insert into public.credit_transactions (user_id, amount, kind, reference)
  values (p_user, p_amount, p_kind, p_reference)
  on conflict (reference) where kind in ('purchase', 'ad_reward') do nothing;
  if not found then
    return false;
  end if;
  perform public.lock_balance(p_user);
  update public.credit_balances
  set bonus_credits = bonus_credits + p_amount, updated_at = now()
  where user_id = p_user;
  return true;
end;
$$;

-- Fixe l'état Premium d'un utilisateur à partir de l'événement d'achat le plus récent.
create function public.set_premium(
  p_user uuid, p_is_premium boolean, p_product text, p_expires_at timestamptz
) returns void
language sql security definer set search_path = '' as $$
  insert into public.entitlements (user_id, is_premium, product_id, expires_at, updated_at)
  values (p_user, p_is_premium, p_product, p_expires_at, now())
  on conflict (user_id) do update
  set is_premium = excluded.is_premium,
      product_id = excluded.product_id,
      expires_at = excluded.expires_at,
      updated_at = now();
$$;

revoke execute on function public.grant_credits(uuid, int, public.credit_kind, text)
  from public, anon, authenticated;
revoke execute on function public.set_premium(uuid, boolean, text, timestamptz)
  from public, anon, authenticated;
grant execute on function public.grant_credits(uuid, int, public.credit_kind, text) to service_role;
grant execute on function public.set_premium(uuid, boolean, text, timestamptz) to service_role;
