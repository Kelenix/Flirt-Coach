-- Code d'accès Premium pour la revue des stores (ADR-031). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(13);

\set reviewer '''00000000-0000-0000-0000-0000000000c1'''
\set second '''00000000-0000-0000-0000-0000000000c2'''
\set subscriber '''00000000-0000-0000-0000-0000000000c3'''
\set guesser '''00000000-0000-0000-0000-0000000000c4'''
insert into auth.users (id, email) values
  (:reviewer, 'revue@test.local'), (:second, 'second@test.local'),
  (:subscriber, 'abonne@test.local'), (:guesser, 'essais@test.local');

select is(
  (select status from public.redeem_access_code(:reviewer, 'h1', false, 1, 30)),
  'invalid', 'un mauvais code est refusé'
);
select is(public.is_premium(:reviewer), false, 'un mauvais code ne donne rien');

select is(
  (select status from public.redeem_access_code(:reviewer, 'h1', true, 1, 30)),
  'granted', 'le bon code donne Premium'
);
select is(public.is_premium(:reviewer), true, 'le compte devient Premium');
select ok(
  (select expires_at between now() + interval '29 days' and now() + interval '31 days'
     from public.entitlements where user_id = :reviewer),
  'Premium dure 30 jours'
);
select is(
  (select status from public.redeem_access_code(:reviewer, 'h1', true, 5, 30)),
  'unavailable', 'un compte n''active le code qu''une fois'
);
select is(
  (select status from public.redeem_access_code(:second, 'h1', true, 1, 30)),
  'unavailable', 'le plafond d''activations est respecté'
);
select is(
  (select status from public.redeem_access_code(:second, 'h2', true, 1, 30)),
  'granted', 'un nouveau code repart de zéro'
);

-- Un abonné garde son abonnement : le code ne le remplace pas.
select public.set_premium(:subscriber, true, 'flirtcoach_premium_annual', now() + interval '200 days');
select is(
  (select status from public.redeem_access_code(:subscriber, 'h2', true, 5, 30)),
  'unavailable', 'un compte déjà Premium n''utilise pas le code'
);
select is(
  (select product_id from public.entitlements where user_id = :subscriber),
  'flirtcoach_premium_annual', 'l''abonnement est intact'
);

-- Essais limités par heure, y compris pour un bon code.
select public.redeem_access_code(:guesser, 'h3', false, 5, 30) from generate_series(1, 5);
select is(
  (select status from public.redeem_access_code(:guesser, 'h3', true, 5, 30)),
  'rate_limited', 'au-delà de 5 essais par heure, tout est bloqué'
);
select is(public.is_premium(:guesser), false, 'le blocage ne donne rien');

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000c4","role":"authenticated"}', true);
select throws_ok(
  $$ select public.redeem_access_code('00000000-0000-0000-0000-0000000000c4', 'h3', true, 5, 30) $$,
  '42501', null,
  'le client ne peut pas activer un code lui-même'
);

select * from finish();
rollback;
