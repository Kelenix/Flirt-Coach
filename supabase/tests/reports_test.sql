-- Tests du signalement (Inc-10) et de la suppression de compte. Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(11);

\set a '\'00000000-0000-0000-0000-0000000000e1\''
\set b '\'00000000-0000-0000-0000-0000000000e2\''

insert into auth.users (id, email) values (:a, 'a@report.local'), (:b, 'b@report.local');
insert into public.generations (id, user_id, kind, style, output) values
  ('30000000-0000-0000-0000-000000000001', :a, 'reply', 'classic', '{"proposals":["x","y","z"]}'),
  ('30000000-0000-0000-0000-000000000002', :b, 'reply', 'classic', '{"proposals":["u","v","w"]}');

-- Utilisateur A, gratuit.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000e1","role":"authenticated"}', true);

select lives_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000001', ' x ', 'offensive') $$,
  'un utilisateur gratuit signale une réponse de sa génération'
);
select lives_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000001', 'x', 'other') $$,
  'signaler deux fois la même réponse ne lève pas d''erreur'
);
select throws_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000002', 'u', 'sexual') $$,
  'P0001', 'not_found',
  'impossible de signaler la génération d''un autre'
);
select throws_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000001', '', 'other') $$,
  'P0001', 'not_found',
  'un texte vide est refusé'
);
select throws_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000001', 'texte inventé', 'other') $$,
  'P0001', 'not_found',
  'un texte que la génération n''a pas produit est refusé'
);
reset role;
insert into public.generations (id, user_id, kind, style, output)
select ('31000000-0000-0000-0000-' || lpad(n::text, 12, '0'))::uuid, :a, 'reply', 'classic',
       '{"proposals":["p"]}'::jsonb
from generate_series(1, 19) n;
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000e1","role":"authenticated"}', true);
select public.report_generation(('31000000-0000-0000-0000-' || lpad(n::text, 12, '0'))::uuid, 'p', 'other')
from generate_series(1, 19) n;
select throws_ok(
  $$ select public.report_generation('30000000-0000-0000-0000-000000000001', 'y', 'other') $$,
  'P0001', 'report_limit',
  'au plus 20 signalements par jour'
);
select is((select count(*)::int from public.reports), 0, 'le client ne lit pas les signalements');
select throws_ok(
  $$ insert into public.reports (user_id, generation_id, reported_text, reason)
     values ('00000000-0000-0000-0000-0000000000e1', '30000000-0000-0000-0000-000000000001', 'y', 'other') $$,
  '42501', null,
  'aucune insertion directe'
);

reset role;
select results_eq(
  $$ select reported_text, reason::text from public.reports
     where generation_id = '30000000-0000-0000-0000-000000000001' $$,
  $$ values ('x', 'offensive') $$,
  'un seul signalement, texte nettoyé, premier motif conservé'
);

-- Suppression du compte A (comme le fait l'Edge Function delete-account).
delete from auth.users where id = :a;
select is(
  (select count(*)::int from public.reports), 0,
  'les signalements disparaissent avec le compte'
);
select is(
  (select count(*)::int from public.generations where user_id = :a)
  + (select count(*)::int from public.profiles where id = :a)
  + (select count(*)::int from public.credit_balances where user_id = :a),
  0,
  'profil, solde et générations disparaissent avec le compte'
);

select * from finish();
rollback;
