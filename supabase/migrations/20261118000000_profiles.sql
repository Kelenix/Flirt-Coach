-- Inc-0 : profil utilisateur et confirmation d'âge (INTAKE §7.1).

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  age_confirmed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Lecture de sa propre ligne uniquement. Aucune policy d'écriture : le client
-- ne modifie jamais un profil directement.
create policy profiles_select_own on public.profiles
  for select to authenticated
  using ((select auth.uid()) = id);

-- Un profil est créé pour chaque compte (anonyme ou non).
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Seule écriture permise au client : horodater sa propre confirmation d'âge.
-- La date est fixée par le serveur et n'est jamais écrasée.
create function public.confirm_age()
returns void
language sql
security definer
set search_path = ''
as $$
  update public.profiles
  set age_confirmed_at = coalesce(age_confirmed_at, now()),
      updated_at = now()
  where id = (select auth.uid());
$$;

revoke execute on function public.confirm_age() from public, anon;
grant execute on function public.confirm_age() to authenticated;
