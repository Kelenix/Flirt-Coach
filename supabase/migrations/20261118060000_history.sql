-- Inc-9 : historique Premium (INTAKE §2.7, US-18).
-- « Supprimer » une entrée efface son contenu (texte saisi, contexte, réponses) mais garde
-- une ligne vide datée : le plafond Premium de 100 générations par jour compte ces lignes,
-- une vraie suppression permettrait de le contourner. Le contenu, lui, disparaît.

alter table public.generations add column deleted_at timestamptz;

-- L'historique ne montre que les entrées non supprimées, toujours en Premium seulement.
drop policy generations_select_own_premium on public.generations;
create policy generations_select_own_premium on public.generations
  for select to authenticated
  using (
    (select auth.uid()) = user_id
    and deleted_at is null
    and exists (
      select 1 from public.entitlements e
      where e.user_id = (select auth.uid())
        and e.is_premium
        and (e.expires_at is null or e.expires_at > now())
    )
  );

-- Plus de suppression directe : elle passe par delete_generation.
drop policy generations_delete_own on public.generations;

create function public.delete_generation(p_id uuid) returns void
language sql security definer set search_path = '' as $$
  update public.generations
  set input_text = null,
      context_text = null,
      output = '{}'::jsonb,
      deleted_at = now()
  where id = p_id
    and user_id = (select auth.uid())
    and deleted_at is null;
$$;

revoke execute on function public.delete_generation(uuid) from public, anon;
grant execute on function public.delete_generation(uuid) to authenticated;
