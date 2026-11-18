-- Tests de l'historique Premium (Inc-9). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(9);

\set p '\'00000000-0000-0000-0000-0000000000d1\''
\set f '\'00000000-0000-0000-0000-0000000000d2\''

insert into auth.users (id, email) values
  (:p, 'premium@test.local'),
  (:f, 'gratuit@test.local');
select public.set_premium(:p, true, 'test', now() + interval '1 day');

insert into public.generations (id, user_id, kind, style, input_text, context_text, output) values
  ('10000000-0000-0000-0000-000000000001', :p, 'reply', 'classic', 'Salut', 'Rencontré hier',
   '{"proposals":["a","b","c"]}'),
  ('10000000-0000-0000-0000-000000000002', :p, 'opener', 'classic', null, null,
   '{"proposals":["d","e","f"]}'),
  ('20000000-0000-0000-0000-000000000001', :f, 'reply', 'classic', 'Coucou', null,
   '{"proposals":["g","h","i"]}');

-- Premium connecté.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000d1","role":"authenticated"}', true);

select is((select count(*)::int from public.generations), 2, 'un Premium lit son historique, pas celui des autres');

select lives_ok(
  $$ select public.delete_generation('10000000-0000-0000-0000-000000000001') $$,
  'un Premium supprime une entrée'
);
select is((select count(*)::int from public.generations), 1, 'l''entrée supprimée disparaît de l''historique');

select lives_ok(
  $$ select public.delete_generation('20000000-0000-0000-0000-000000000001') $$,
  'supprimer l''entrée d''un autre ne lève pas d''erreur…'
);

delete from public.generations;
select is((select count(*)::int from public.generations), 1, 'aucune suppression directe (plus de règle de suppression)');

reset role;

select is(
  (select row(input_text, context_text, output::text)::text from public.generations
   where id = '10000000-0000-0000-0000-000000000001'),
  row(null::text, null::text, '{}')::text,
  'le contenu supprimé est effacé'
);
select is(
  (select output->'proposals'->>0 from public.generations
   where id = '20000000-0000-0000-0000-000000000001'),
  'g',
  '… et l''entrée d''un autre reste intacte'
);
select is(
  (select count(*)::int from public.generations where user_id = :p),
  2,
  'la ligne vide reste comptée pour le plafond Premium du jour'
);

-- Visiteur non connecté : pas d'accès à la fonction.
set local role anon;
select throws_ok(
  $$ select public.delete_generation('10000000-0000-0000-0000-000000000002') $$,
  '42501', null,
  'un visiteur non connecté ne peut pas supprimer'
);

select * from finish();
rollback;
