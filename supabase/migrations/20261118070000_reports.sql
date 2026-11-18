-- Inc-10 : signalement d'un contenu généré (INTAKE §7.5, US-07).
-- L'utilisateur signale une réponse d'une de SES générations. Le texte signalé est copié :
-- il reste examinable même si l'entrée est ensuite effacée de l'historique. Tout disparaît
-- avec le compte (cascade). Lecture réservée à l'équipe (tableau de bord Supabase).

create type public.report_reason as enum (
  'offensive', 'sexual', 'harassment', 'manipulative', 'other'
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  generation_id uuid not null references public.generations (id) on delete cascade,
  reported_text text not null check (char_length(reported_text) between 1 and 2000),
  reason public.report_reason not null,
  created_at timestamptz not null default now(),
  -- Un même texte n'est signalé qu'une fois par son auteur.
  unique (generation_id, reported_text)
);
create index reports_created_idx on public.reports (created_at desc);

-- Aucune règle d'accès client : tout passe par report_generation.
alter table public.reports enable row level security;

-- Enregistre un signalement si la génération appartient à l'appelant (même gratuit,
-- donc sans passer par la règle de lecture Premium de generations). Rejouable.
create function public.report_generation(
  p_generation uuid, p_text text, p_reason public.report_reason
) returns void
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (
    select 1 from public.generations g
    where g.id = p_generation and g.user_id = (select auth.uid())
  ) then
    raise exception 'not_found' using errcode = 'P0002';
  end if;
  insert into public.reports (user_id, generation_id, reported_text, reason)
  values ((select auth.uid()), p_generation, btrim(p_text), p_reason)
  on conflict (generation_id, reported_text) do nothing;
end;
$$;

revoke execute on function public.report_generation(uuid, text, public.report_reason)
  from public, anon;
grant execute on function public.report_generation(uuid, text, public.report_reason)
  to authenticated;
