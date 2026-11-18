-- Tests de public.message_bank (Inc-8). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(8);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b1', 'bank@test.local');

select ok(
  (select relrowsecurity from pg_class where oid = 'public.message_bank'::regclass),
  'RLS activée sur message_bank'
);

select is(
  (select count(distinct category)::int from public.message_bank),
  5,
  'les 5 catégories de l''INTAKE §2.5 sont remplies'
);

select is(
  (select min(n)::int from (
    select count(*) as n from public.message_bank group by category) per_category),
  8,
  'au moins 8 messages par catégorie'
);

select is(
  (select count(*)::int from public.message_bank where body ~ '[[:cntrl:]]'),
  0,
  'aucun caractère de contrôle dans les textes'
);

-- Visiteur non connecté : rien.
set local role anon;
select is((select count(*)::int from public.message_bank), 0, 'un visiteur anonyme non connecté ne lit rien');

-- Utilisateur connecté : lecture seule.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000b1","role":"authenticated"}', true);

select is((select count(*)::int from public.message_bank), 40, 'un utilisateur connecté lit toute la banque');

select throws_ok(
  $$ insert into public.message_bank (category, body, sort_order) values ('opener', 'x', 99) $$,
  '42501',
  null,
  'aucune insertion depuis l''app'
);

select throws_ok(
  $$ delete from public.message_bank $$,
  '42501',
  null,
  'aucune suppression depuis l''app'
);

select * from finish();
rollback;
