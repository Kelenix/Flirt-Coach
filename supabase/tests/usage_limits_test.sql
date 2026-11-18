-- Limites d'usage des appels IA (phase 5, revue S1/S2). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(7);

\set f '\'00000000-0000-0000-0000-0000000000f1\''
\set g '\'00000000-0000-0000-0000-0000000000f2\''

insert into auth.users (id, email) values (:f, 'f@usage.local'), (:g, 'g@usage.local');
update public.credit_balances set bonus_credits = 500 where user_id in (:f, :g);

-- 10 tentatives dans la minute, puis refus.
select lives_ok(
  $$ select count(*) from (
       select public.spend_credits('00000000-0000-0000-0000-0000000000f1', 1, 'r' || n)
       from generate_series(1, 10) n) t $$,
  '10 tentatives dans la minute sont acceptées'
);
select throws_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000f1', 1, 'r11') $$,
  'P0001', 'rate_limited',
  'la 11e tentative de la minute est refusée'
);

-- Une tentative remboursée (refus, capture illisible) reste comptée.
select public.refund_credits(:f, 1, 0, 'r1');
select is(
  (select count(*)::int from public.ai_usage where user_id = :f), 10,
  'un remboursement n''efface pas la tentative'
);

-- Plafond journalier : 100 tentatives, gratuit compris (crédits achetés ou non).
insert into public.ai_usage (user_id, reference, created_at)
select :g, 'old-' || n, now() - interval '2 minutes' from generate_series(1, 99) n;
select lives_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000f2', 1, 'last') $$,
  'la 100e tentative du jour passe'
);
select throws_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000f2', 1, 'over') $$,
  'P0001', 'daily_limit',
  'la 101e tentative du jour est refusée, même avec des crédits'
);

-- Les tentatives d'hier ne comptent pas.
update public.ai_usage set created_at = now() - interval '1 day 1 hour' where user_id = :g;
select lives_ok(
  $$ select * from public.spend_credits('00000000-0000-0000-0000-0000000000f2', 1, 'today') $$,
  'les tentatives d''hier ne comptent pas'
);

-- Le client ne lit pas l'usage.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000f2","role":"authenticated"}', true);
select is((select count(*)::int from public.ai_usage), 0, 'le client ne lit pas ai_usage');

select * from finish();
rollback;
