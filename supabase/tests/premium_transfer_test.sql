-- Transfert de Premium vers une nouvelle installation (ADR-027). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(11);

\set old '''00000000-0000-0000-0000-0000000000e1'''
\set new '''00000000-0000-0000-0000-0000000000e2'''
\set other '''00000000-0000-0000-0000-0000000000e3'''
insert into auth.users (id, email) values
  (:old, 'ancien@test.local'), (:new, 'nouveau@test.local'), (:other, 'autre@test.local');

select is(
  public.transfer_premium(array[:old]::uuid[], array[:new]::uuid[]), false,
  'sans abonnement actif, rien n''est transféré'
);

select public.set_premium(:old, true, 'flirtcoach_premium_annual', now() + interval '200 days');
select is(
  public.transfer_premium(array[:old]::uuid[], array[:new]::uuid[]), true,
  'un abonnement actif est transféré'
);
select is(public.is_premium(:new), true, 'le nouveau compte devient Premium');
select is(public.is_premium(:old), false, 'l''ancien compte perd Premium');
select is(
  (select product_id from public.entitlements where user_id = :new),
  'flirtcoach_premium_annual',
  'le produit suit l''abonnement'
);
select ok(
  (select expires_at > now() + interval '199 days' from public.entitlements where user_id = :new),
  'l''échéance suit l''abonnement'
);

select is(
  public.transfer_premium(array[:new]::uuid[], array[:old]::uuid[]), true,
  'un retour vers l''ancien téléphone fonctionne aussi'
);
select is(public.is_premium(:old), true, 'Premium revient sur l''ancien compte');

-- Un abonnement échu ne se transfère pas.
select public.set_premium(:other, true, 'flirtcoach_premium_weekly', now() - interval '1 day');
select is(
  public.transfer_premium(array[:other]::uuid[], array[:new]::uuid[]), false,
  'un abonnement échu n''est pas transféré'
);

select throws_ok(
  $$ select public.transfer_premium(array['00000000-0000-0000-0000-0000000000e1']::uuid[],
       array['00000000-0000-0000-0000-0000000000ff']::uuid[]) $$,
  '23503', null,
  'un nouveau compte inconnu est signalé (clé étrangère)'
);

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000e2","role":"authenticated"}', true);
select throws_ok(
  $$ select public.transfer_premium(array['00000000-0000-0000-0000-0000000000e1']::uuid[],
       array['00000000-0000-0000-0000-0000000000e2']::uuid[]) $$,
  '42501', null,
  'le client ne peut pas déclencher un transfert'
);

select * from finish();
rollback;
