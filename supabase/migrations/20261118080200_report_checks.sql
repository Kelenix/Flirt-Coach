-- Phase 5 (revue de sécurité S7) : un signalement porte sur un texte réellement produit
-- par la génération (pas de « preuve » fabriquée), et au plus 20 signalements par jour.

create or replace function public.report_generation(
  p_generation uuid, p_text text, p_reason public.report_reason
) returns void
language plpgsql security definer set search_path = '' as $$
declare
  v_output jsonb;
  v_text text := btrim(p_text);
begin
  select g.output into v_output from public.generations g
  where g.id = p_generation and g.user_id = (select auth.uid());
  -- coalesce : un champ absent (NULL) ne doit jamais faire passer le contrôle.
  if not found or not coalesce(
    (v_output -> 'proposals') ? v_text
    or v_text in (
      v_output ->> 'alternative',
      v_output ->> 'suggestedMessage',
      v_output ->> 'dateSuggestion'
    ),
    false
  ) then
    raise exception 'not_found' using errcode = 'P0001';
  end if;
  if (select count(*) from public.reports r
      where r.user_id = (select auth.uid()) and r.created_at > now() - interval '1 day')
     >= 20 then
    raise exception 'report_limit' using errcode = 'P0001';
  end if;
  insert into public.reports (user_id, generation_id, reported_text, reason)
  values ((select auth.uid()), p_generation, v_text, p_reason)
  on conflict (generation_id, reported_text) do nothing;
end;
$$;
