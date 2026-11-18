-- Inc-10 (correctif) : signaler une génération inconnue doit répondre 400, pas 500.
-- PostgREST traduit le code P0002 en erreur serveur ; P0001 est l'erreur métier standard.

create or replace function public.report_generation(
  p_generation uuid, p_text text, p_reason public.report_reason
) returns void
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (
    select 1 from public.generations g
    where g.id = p_generation and g.user_id = (select auth.uid())
  ) then
    raise exception 'not_found' using errcode = 'P0001';
  end if;
  insert into public.reports (user_id, generation_id, reported_text, reason)
  values ((select auth.uid()), p_generation, btrim(p_text), p_reason)
  on conflict (generation_id, reported_text) do nothing;
end;
$$;
