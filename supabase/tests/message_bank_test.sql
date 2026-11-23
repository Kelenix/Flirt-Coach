-- Tests de public.message_bank (Inc-8, langues : ADR-034). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(11);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b1', 'bank@test.local');

select ok(
  (select relrowsecurity from pg_class where oid = 'public.message_bank'::regclass),
  'RLS activée sur message_bank'
);

select results_eq(
  $$ select distinct language from public.message_bank order by 1 $$,
  $$ values ('en'), ('fr') $$,
  'la banque existe en anglais et en français'
);

select is(
  (select min(n)::int from (
    select count(distinct category) as n from public.message_bank group by language) per_language),
  5,
  'chaque langue remplit les 5 catégories de l''INTAKE §2.5'
);

select is(
  (select min(n)::int from (
    select count(*) as n from public.message_bank group by language, category) per_category),
  8,
  'au moins 8 messages par catégorie et par langue'
);

select is(
  (select count(*)::int from public.message_bank where body ~ '[[:cntrl:]]'),
  0,
  'aucun caractère de contrôle dans les textes'
);

select throws_ok(
  $$ insert into public.message_bank (language, category, body, sort_order)
     values ('EN', 'opener', 'x', 99) $$,
  '23514',
  null,
  'une langue est un code ISO 639 en minuscules'
);

select throws_ok(
  $$ insert into public.message_bank (category, body, sort_order) values ('opener', 'x', 99) $$,
  '23502',
  null,
  'la langue est obligatoire'
);

-- Visiteur non connecté : rien.
set local role anon;
select is((select count(*)::int from public.message_bank), 0, 'un visiteur anonyme non connecté ne lit rien');

-- Utilisateur connecté : lecture seule.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000b1","role":"authenticated"}', true);

select is((select count(*)::int from public.message_bank), 80, 'un utilisateur connecté lit toute la banque');

select throws_ok(
  $$ insert into public.message_bank (language, category, body, sort_order)
     values ('en', 'opener', 'x', 99) $$,
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
