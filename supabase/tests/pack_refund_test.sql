-- Reprise des crédits d'un pack remboursé (phase 5, revue S5). Lancer : supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(6);

\set u '\'00000000-0000-0000-0000-0000000000a9\''
insert into auth.users (id, email) values (:u, 'refund@test.local');
update public.credit_balances set bonus_credits = 30 where user_id = :u;

select is(
  public.revoke_credits(:u, 20, 'refund:tx-1'), 20,
  'les 20 crédits du pack sont repris'
);
select is(
  public.revoke_credits(:u, 20, 'refund:tx-1'), 0,
  'un événement rejoué ne reprend rien de plus'
);
select is(
  public.revoke_credits(:u, 50, 'refund:tx-2'), 10,
  'jamais plus que le solde bonus restant'
);
select is(
  (select bonus_credits from public.credit_balances where user_id = :u), 0,
  'le solde bonus ne devient jamais négatif'
);

select is(
  public.revoke_credits(:u, 20, 'refund:tx-3'), 0,
  'solde bonus à 0 : rien à reprendre, pas d''erreur'
);

set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000a9","role":"authenticated"}', true);
select throws_ok(
  $$ select public.revoke_credits('00000000-0000-0000-0000-0000000000a9', 1, 'x') $$,
  '42501', null,
  'le client ne peut pas appeler revoke_credits'
);

select * from finish();
rollback;
