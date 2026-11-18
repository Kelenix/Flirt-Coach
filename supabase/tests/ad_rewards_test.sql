-- Tests de la récompense publicitaire (Inc-6). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(10);

\set u '''00000000-0000-0000-0000-0000000000e1'''
\set p '''00000000-0000-0000-0000-0000000000e2'''
insert into auth.users (id, email) values (:u, 'ads@test.local'), (:p, 'prem@test.local');
insert into public.entitlements (user_id, is_premium) values (:p, true);

select results_eq(
  $$ select ad_rewards_left from public.wallet_of('00000000-0000-0000-0000-0000000000e1') $$,
  $$ values (5) $$,
  '5 vidéos récompensées possibles par jour'
);
select is(public.claim_ad_reward(:u, 'admob-1'), 'credited', 'une vidéo vue rapporte des crédits');
select is(
  (select bonus_credits from public.credit_balances where user_id = :u), 2,
  '+2 crédits bonus'
);
select is(public.claim_ad_reward(:u, 'admob-1'), 'duplicate', 'le même rappel AdMob ne paie qu''une fois');

select public.claim_ad_reward(:u, 'admob-' || n) from generate_series(2, 5) as n;
select results_eq(
  $$ select bonus_credits, ad_rewards_left from public.wallet_of('00000000-0000-0000-0000-0000000000e1') $$,
  $$ values (10, 0) $$,
  'après 5 vidéos : 10 crédits, plus de vidéo possible'
);
select is(public.claim_ad_reward(:u, 'admob-6'), 'daily_limit', 'la 6e vidéo du jour ne paie pas');
select is(
  (select bonus_credits from public.credit_balances where user_id = :u), 10,
  'le plafond n''accorde rien de plus'
);

select is(public.claim_ad_reward(:p, 'admob-p'), 'premium', 'un Premium n''a pas de vidéo récompensée');
select results_eq(
  $$ select ad_rewards_left from public.wallet_of('00000000-0000-0000-0000-0000000000e2') $$,
  $$ values (0) $$,
  'aucune vidéo proposée à un Premium'
);

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000e1","role":"authenticated"}', true);
select throws_ok(
  $$ select public.claim_ad_reward('00000000-0000-0000-0000-0000000000e1', 'fake') $$,
  '42501', null,
  'le client ne peut pas réclamer une récompense lui-même'
);

select * from finish();
rollback;
