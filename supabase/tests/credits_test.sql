-- Tests des crédits, droits et générations (Inc-1). Lancer : supabase test db

-- Les tentatives « du jour » sont datées de 2 minutes plus tôt (hors limite par minute).
-- Juste après minuit UTC, elles tomberaient la veille : on attend la 3e minute du jour avant
-- d'ouvrir la transaction, qui fige now().
do $$
begin
  perform pg_sleep(greatest(0, 121 - extract(epoch from (now() - date_trunc('day', now(), 'UTC')))));
end
$$;

begin;
create extension if not exists pgtap with schema extensions;
select plan(24);

\set a '''00000000-0000-0000-0000-0000000000a1'''
\set b '''00000000-0000-0000-0000-0000000000b1'''
\set p '''00000000-0000-0000-0000-0000000000c1'''

insert into auth.users (id, email) values
  (:a, 'a@test.local'), (:b, 'b@test.local'), (:p, 'p@test.local');
insert into public.entitlements (user_id, is_premium) values (:p, true);

-- Ouverture du solde ---------------------------------------------------------
select is(
  (select daily_credits from public.credit_balances where user_id = :a), 5,
  'un nouveau compte reçoit 5 crédits du jour'
);

-- Débit : crédits du jour d'abord, puis bonus --------------------------------
update public.credit_balances set daily_credits = 1, bonus_credits = 3 where user_id = :a;
select results_eq(
  $$ select from_daily, from_bonus from public.spend_credits('00000000-0000-0000-0000-0000000000a1', 2, 't1') $$,
  $$ values (1, 1) $$,
  'le débit prend le crédit du jour puis un bonus'
);
select results_eq(
  $$ select daily_credits, bonus_credits from public.credit_balances where user_id = '00000000-0000-0000-0000-0000000000a1' $$,
  $$ values (0, 2) $$,
  'le solde est débité'
);
select is(
  (select sum(amount)::int from public.credit_transactions where user_id = :a), -2,
  'le journal enregistre les deux mouvements'
);

-- Remboursement exact --------------------------------------------------------
select lives_ok(
  $$ select public.refund_credits('00000000-0000-0000-0000-0000000000a1', 1, 1, 't1') $$,
  'remboursement possible'
);
select results_eq(
  $$ select daily_credits, bonus_credits from public.credit_balances where user_id = '00000000-0000-0000-0000-0000000000a1' $$,
  $$ values (1, 3) $$,
  'le remboursement rétablit le solde exact'
);

-- Solde insuffisant ----------------------------------------------------------
update public.credit_balances set daily_credits = 1, bonus_credits = 0 where user_id = :a;
select throws_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000a1', 2, 't2') $$,
  'P0001', 'insufficient_credits',
  'une capture (2 crédits) est refusée avec 1 seul crédit'
);
select is(
  (select daily_credits from public.credit_balances where user_id = :a), 1,
  'un refus ne débite rien'
);

-- Remise quotidienne ---------------------------------------------------------
update public.credit_balances
set daily_credits = 0, bonus_credits = 0, daily_reset_on = current_date - 1
where user_id = :a;
select results_eq(
  $$ select from_daily, from_bonus from public.spend_credits('00000000-0000-0000-0000-0000000000a1', 1, 't3') $$,
  $$ values (1, 0) $$,
  'un nouveau jour remet 5 crédits avant le débit'
);
select is(
  (select daily_credits from public.credit_balances where user_id = :a), 4,
  'il reste 4 crédits après la première génération du jour'
);

-- Crédits du jour non cumulables ---------------------------------------------
select lives_ok(
  $$ select public.refund_credits('00000000-0000-0000-0000-0000000000a1', 3, 0, 't4') $$,
  'remboursement excessif accepté'
);
select is(
  (select daily_credits from public.credit_balances where user_id = :a), 5,
  'les crédits du jour ne dépassent jamais 5'
);

-- Premium : pas de débit, plafond journalier ----------------------------------
select results_eq(
  $$ select from_daily, from_bonus from public.spend_credits('00000000-0000-0000-0000-0000000000c1', 1, 't5') $$,
  $$ values (0, 0) $$,
  'un Premium n''est pas débité'
);
-- Tentatives du jour, hors fenêtre de la limite par minute.
insert into public.ai_usage (user_id, reference, created_at)
select :p, 'old-' || n, now() - interval '2 minutes' from generate_series(1, 99) n;
select throws_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000c1', 1, 't6') $$,
  'P0001', 'daily_limit',
  'un Premium est bloqué à 100 générations par jour'
);
-- Nouveau jour d'usage pour le test suivant.
delete from public.ai_usage where user_id = :p;
update public.entitlements set expires_at = now() - interval '1 day' where user_id = :p;
select results_eq(
  $$ select from_daily, from_bonus from public.spend_credits('00000000-0000-0000-0000-0000000000c1', 1, 't7') $$,
  $$ values (1, 0) $$,
  'un abonnement expiré redevient gratuit'
);

-- Accès client ---------------------------------------------------------------
insert into public.generations (user_id, kind, style, output)
values (:a, 'reply', 'classic', '{}'::jsonb), (:b, 'reply', 'classic', '{}'::jsonb);

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000a1","role":"authenticated"}', true);

select results_eq(
  $$ select daily_credits, bonus_credits, is_premium from public.get_wallet() $$,
  $$ values (5, 0, false) $$,
  'get_wallet renvoie le portefeuille de l''appelant'
);
select is(
  (select count(*)::int from public.credit_balances), 1,
  'A ne voit que son propre solde'
);
select is(
  (select count(*)::int from public.generations), 0,
  'un gratuit ne lit pas l''historique'
);
select throws_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000a1', 1, 'x') $$,
  '42501', null,
  'le client ne peut pas appeler spend_credits'
);
select throws_ok(
  $$ select public.refund_credits('00000000-0000-0000-0000-0000000000a1', 5, 100, 'x') $$,
  '42501', null,
  'le client ne peut pas s''offrir de crédits'
);
update public.credit_balances set bonus_credits = 999 where user_id = :a;
select is(
  (select bonus_credits from public.credit_balances), 0,
  'le client ne peut pas modifier son solde'
);
select throws_ok(
  $$ insert into public.entitlements (user_id, is_premium) values ('00000000-0000-0000-0000-0000000000a1', true) $$,
  '42501', null,
  'le client ne peut pas s''attribuer Premium'
);

-- Un Premium lit son historique, et seulement le sien.
reset role;
update public.entitlements set expires_at = null where user_id = :p;
insert into public.generations (user_id, kind, style, output)
select :p, 'reply', 'classic', '{}'::jsonb from generate_series(1, 3);
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000c1","role":"authenticated"}', true);
select is(
  (select count(*)::int from public.generations), 3,
  'un Premium lit son propre historique uniquement'
);

set local role anon;
select throws_ok(
  $$ select * from public.get_wallet() $$,
  '42501', null,
  'anon ne peut pas lire de portefeuille'
);

select * from finish();
rollback;
