-- Tests RLS de public.profiles (Inc-0). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(11);

-- Deux comptes ; le trigger doit créer un profil pour chacun.
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@test.local'),
  ('00000000-0000-0000-0000-00000000000b', 'b@test.local');

select is(
  (select count(*)::int from public.profiles where id in (
    '00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000b')),
  2,
  'un profil est créé pour chaque compte'
);

select ok(
  (select relrowsecurity from pg_class where oid = 'public.profiles'::regclass),
  'RLS activée sur profiles'
);

-- Utilisateur A authentifié.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-00000000000a","role":"authenticated"}', true);

select is(
  (select count(*)::int from public.profiles),
  1,
  'A ne voit que son propre profil'
);

select is(
  (select count(*)::int from public.profiles where id = '00000000-0000-0000-0000-00000000000b'),
  0,
  'A ne voit pas le profil de B'
);

-- Aucune écriture directe possible (pas de policy d'écriture).
update public.profiles set age_confirmed_at = now() where id = '00000000-0000-0000-0000-00000000000a';
select is(
  (select age_confirmed_at from public.profiles where id = '00000000-0000-0000-0000-00000000000a'),
  null,
  'A ne peut pas modifier son profil directement'
);

select throws_ok(
  $$ insert into public.profiles (id) values ('00000000-0000-0000-0000-0000000000ff') $$,
  '42501',
  null,
  'A ne peut pas insérer de profil'
);

-- confirm_age() n'agit que sur le profil de l'appelant.
select lives_ok($$ select public.confirm_age() $$, 'A peut confirmer son âge');
select isnt(
  (select age_confirmed_at from public.profiles where id = '00000000-0000-0000-0000-00000000000a'),
  null,
  'la confirmation de A est horodatée'
);

-- Un visiteur non connecté ne lit rien et ne peut pas confirmer d'âge.
set local role anon;
select is((select count(*)::int from public.profiles), 0, 'anon ne lit aucun profil');
select throws_ok(
  $$ select public.confirm_age() $$,
  '42501',
  null,
  'anon ne peut pas appeler confirm_age()'
);

reset role;
select is(
  (select age_confirmed_at from public.profiles where id = '00000000-0000-0000-0000-00000000000b'),
  null,
  'le profil de B est inchangé'
);

select * from finish();
rollback;
