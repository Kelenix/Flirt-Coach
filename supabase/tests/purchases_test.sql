-- Tests des achats (Inc-5). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(13);

\set u '''00000000-0000-0000-0000-0000000000d1'''
insert into auth.users (id, email) values (:u, 'buyer@test.local');

select is(
  public.grant_credits(:u, 50, 'purchase', 'store-tx-1'), true,
  'un pack de 50 crédits est crédité'
);
select is(
  (select bonus_credits from public.credit_balances where user_id = :u), 50,
  'les crédits achetés vont dans le solde bonus'
);
select is(
  public.grant_credits(:u, 50, 'purchase', 'store-tx-1'), false,
  'le même achat rejoué n''est pas crédité deux fois'
);
select is(
  (select bonus_credits from public.credit_balances where user_id = :u), 50,
  'le solde est inchangé après un rejeu'
);
select throws_ok(
  $$ select public.grant_credits('00000000-0000-0000-0000-0000000000d1', 0, 'purchase', 'x') $$,
  '22023', 'invalid_grant',
  'un montant nul est refusé'
);
select throws_ok(
  $$ select public.grant_credits('00000000-0000-0000-0000-0000000000d1', 5, 'refund', 'x') $$,
  '22023', 'invalid_grant',
  'seuls les achats et récompenses passent par grant_credits'
);

select lives_ok(
  $$ select public.set_premium('00000000-0000-0000-0000-0000000000d1', true,
       'flirtcoach_premium_weekly', now() + interval '7 days') $$,
  'un abonnement active Premium'
);
select is(public.is_premium(:u), true, 'l''utilisateur est Premium');

-- Une expiration plus ancienne arrivée en retard n'annule pas un renouvellement.
select public.set_premium(:u, false, 'flirtcoach_premium_weekly', now() - interval '7 days');
select is(public.is_premium(:u), true, 'un événement plus ancien n''écrase pas un état plus récent');

select public.set_premium(:u, false, 'flirtcoach_premium_weekly', now() + interval '7 days');
select is(public.is_premium(:u), false, 'l''expiration de la période en cours retire Premium');

select public.set_premium(:u, true, 'flirtcoach_premium_weekly', now() + interval '14 days');
select public.set_premium(:u, false, 'flirtcoach_premium_weekly', now(), true);
select is(public.is_premium(:u), false, 'un remboursement retire Premium immédiatement');

select public.set_premium(:u, true, 'flirtcoach_premium_annual', null);
select is(public.is_premium(:u), true, 'un abonnement sans échéance connue reste actif');

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000d1","role":"authenticated"}', true);
select throws_ok(
  $$ select public.grant_credits('00000000-0000-0000-0000-0000000000d1', 100, 'purchase', 'fake') $$,
  '42501', null,
  'le client ne peut pas se créditer lui-même'
);

select * from finish();
rollback;
