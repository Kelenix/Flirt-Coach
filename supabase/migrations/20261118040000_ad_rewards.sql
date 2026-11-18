-- Inc-6 : vidéo récompensée (+2 crédits, INTAKE §3.3), plafonnée à 5 par jour (ADR-008).
-- Les crédits ne sont accordés que sur rappel signé d'AdMob (Edge Function admob-ssv).

create function public.ad_reward_daily_limit() returns int
language sql immutable as $$ select 5 $$;

create function public.ad_reward_credits() returns int
language sql immutable as $$ select 2 $$;

create function public.ad_rewards_today(p_user uuid) returns int
language sql stable security definer set search_path = '' as $$
  select count(*)::int from public.credit_transactions
  where user_id = p_user
    and kind = 'ad_reward'
    and created_at >= (now() at time zone 'utc')::date::timestamp at time zone 'utc';
$$;

-- Portefeuille d'un utilisateur, remise quotidienne appliquée à la lecture.
-- Source unique pour l'app (get_wallet) et les Edge Functions.
create function public.wallet_of(p_user uuid)
returns table (
  daily_credits int, bonus_credits int, is_premium boolean, ad_rewards_left int
)
language sql stable security definer set search_path = '' as $$
  select
    case when b.daily_reset_on < (now() at time zone 'utc')::date
         then public.daily_credit_allowance() else b.daily_credits end,
    b.bonus_credits,
    public.is_premium(b.user_id),
    case when public.is_premium(b.user_id) then 0
         else greatest(public.ad_reward_daily_limit() - public.ad_rewards_today(b.user_id), 0)
    end
  from public.credit_balances b
  where b.user_id = p_user;
$$;

drop function public.get_wallet();
create function public.get_wallet()
returns table (
  daily_credits int, bonus_credits int, is_premium boolean, ad_rewards_left int
)
language sql stable security definer set search_path = '' as $$
  select * from public.wallet_of((select auth.uid()));
$$;

-- Accorde la récompense d'une vidéo vue jusqu'au bout. Idempotent (transaction AdMob).
-- Résultat : 'credited', 'duplicate', 'daily_limit' ou 'premium'.
create function public.claim_ad_reward(p_user uuid, p_transaction_id text)
returns text
language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_balance(p_user);
  if exists (
    select 1 from public.credit_transactions
    where reference = p_transaction_id and kind = 'ad_reward'
  ) then
    return 'duplicate';
  end if;
  if public.is_premium(p_user) then
    return 'premium';
  end if;
  if public.ad_rewards_today(p_user) >= public.ad_reward_daily_limit() then
    return 'daily_limit';
  end if;
  perform public.grant_credits(p_user, public.ad_reward_credits(), 'ad_reward', p_transaction_id);
  return 'credited';
end;
$$;

revoke execute on function public.ad_rewards_today(uuid) from public, anon, authenticated;
revoke execute on function public.wallet_of(uuid) from public, anon, authenticated;
revoke execute on function public.claim_ad_reward(uuid, text) from public, anon, authenticated;
grant execute on function public.wallet_of(uuid) to service_role;
grant execute on function public.claim_ad_reward(uuid, text) to service_role;
revoke execute on function public.get_wallet() from public, anon;
grant execute on function public.get_wallet() to authenticated;
