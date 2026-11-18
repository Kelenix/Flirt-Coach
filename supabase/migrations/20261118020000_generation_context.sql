-- Inc-2 : contexte facultatif saisi par l'utilisateur pour les 7 situations (INTAKE §2.1).
alter table public.generations
  add column context_text text check (char_length(context_text) <= 1000);
