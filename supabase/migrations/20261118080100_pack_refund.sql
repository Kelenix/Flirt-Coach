-- Phase 5 (revue de sécurité S5) : un pack de crédits remboursé par le store est repris.
-- On retire au plus le montant du pack, et jamais plus que le solde bonus restant (les
-- crédits déjà utilisés ne sont pas « dus »). Idempotent : RevenueCat peut rejouer.

alter type public.credit_kind add value if not exists 'purchase_refund';

create function public.revoke_credits(p_user uuid, p_amount int, p_reference text)
returns int
language plpgsql security definer set search_path = '' as $$
declare
  v_balance public.credit_balances;
  v_taken int;
begin
  if p_amount <= 0 or p_reference is null then
    raise exception 'invalid_revoke' using errcode = '22023';
  end if;
  v_balance := public.lock_balance(p_user);
  if exists (
    select 1 from public.credit_transactions
    where reference = p_reference and kind = 'purchase_refund'
  ) then
    return 0;
  end if;
  v_taken := least(p_amount, v_balance.bonus_credits);
  -- Rien à reprendre (crédits déjà utilisés) : aucune écriture.
  if v_taken = 0 then
    return 0;
  end if;
  update public.credit_balances
  set bonus_credits = bonus_credits - v_taken, updated_at = now()
  where user_id = p_user;
  insert into public.credit_transactions (user_id, amount, kind, reference)
  values (p_user, -v_taken, 'purchase_refund', p_reference);
  return v_taken;
end;
$$;

revoke execute on function public.revoke_credits(uuid, int, text) from public, anon, authenticated;
grant execute on function public.revoke_credits(uuid, int, text) to service_role;
