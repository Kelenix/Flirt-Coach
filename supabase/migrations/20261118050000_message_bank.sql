-- Inc-8 : banque de messages (INTAKE §2.5, US-17, hypothèse H5).
-- Contenu statique, lisible par tout utilisateur connecté, sans crédit. Modifiable par
-- migration uniquement (aucune écriture depuis l'app). L'app en garde une copie locale
-- pour la consultation hors-ligne.

create type public.bank_category as enum (
  'opener', 'follow_up', 'date', 'apology', 'soft_breakup'
);

create table public.message_bank (
  id smallint generated always as identity primary key,
  category public.bank_category not null,
  body text not null check (char_length(body) between 1 and 400),
  sort_order smallint not null,
  unique (category, sort_order)
);

alter table public.message_bank enable row level security;

create policy message_bank_select_authenticated on public.message_bank
  for select to authenticated using (true);

revoke insert, update, delete, truncate on public.message_bank from anon, authenticated;

insert into public.message_bank (category, sort_order, body) values
  -- Ouverture : accroches personnelles plutôt qu'un simple « salut ».
  ('opener', 1, 'Je dois te poser une question importante : plutôt soirée cinéma ou balade au coucher du soleil ?'),
  ('opener', 2, 'Ton profil m''a fait sourire, et ce n''est pas si fréquent. Qu''est-ce qui t''a fait sourire, toi, aujourd''hui ?'),
  ('opener', 3, 'J''ai vu que tu aimais voyager. C''est quoi l''endroit où tu retournerais demain sans hésiter ?'),
  ('opener', 4, 'Salut ! On a l''air d''avoir des goûts en commun. Ta meilleure découverte musicale de ces dernières semaines ?'),
  ('opener', 5, 'Je ne suis pas très doué(e) pour les premiers messages, alors je vais faire simple : j''aimerais bien te connaître.'),
  ('opener', 6, 'Question sérieuse : pizza à l''ananas, crime ou génie ? Ta réponse va beaucoup compter 😄'),
  ('opener', 7, 'Ta photo en randonnée m''a donné envie de partir à l''aventure. C''était où ?'),
  ('opener', 8, 'Si tu pouvais avoir un super-pouvoir juste pour ce week-end, ce serait lequel ?'),
  -- Relance : reprendre contact sans reproche ni insistance.
  ('follow_up', 1, 'Hey ! Je repensais à notre discussion de l''autre jour. Comment s''est passée ta semaine ?'),
  ('follow_up', 2, 'Je viens de voir un truc qui m''a fait penser à toi 😄 Tu vas bien ?'),
  ('follow_up', 3, 'Petit message pour prendre de tes nouvelles, sans pression. J''espère que tout roule de ton côté.'),
  ('follow_up', 4, 'Alors, verdict sur la série dont tu me parlais ? Je veux savoir si je peux la commencer !'),
  ('follow_up', 5, 'On s''était arrêté(e)s en plein débat, et je n''ai toujours pas d''avis tranché. Toi ?'),
  ('follow_up', 6, 'J''ai l''impression que la semaine a été chargée pour toi. Bon courage, et au plaisir de te lire !'),
  ('follow_up', 7, 'Je relance notre conversation avec une question facile : ton meilleur moment de la semaine ?'),
  ('follow_up', 8, 'Coucou ! Je ne voulais pas laisser notre échange s''éteindre, j''aimais bien parler avec toi.'),
  -- Rendez-vous : proposer simplement, en laissant la porte ouverte.
  ('date', 1, 'J''aime beaucoup nos échanges. Ça te dirait qu''on continue autour d''un verre cette semaine ?'),
  ('date', 2, 'Je connais un petit café qui fait le meilleur chocolat chaud de la ville. Partant(e) pour vérifier avec moi ?'),
  ('date', 3, 'On parle de balades depuis des jours… et si on en faisait une ensemble ce week-end ?'),
  ('date', 4, 'J''aimerais bien te voir en vrai. Tu serais libre jeudi ou vendredi soir ?'),
  ('date', 5, 'Proposition simple : un verre, une heure, et on voit si on s''entend aussi bien qu''ici. Ça te tente ?'),
  ('date', 6, 'Il y a une expo qui a l''air chouette en ce moment. Ça te dirait d''y aller ensemble ?'),
  ('date', 7, 'Je suis curieux(se) de savoir si tu es aussi drôle en vrai qu''à l''écrit. On se fait un café ?'),
  ('date', 8, 'Pas de pression si ce n''est pas le bon moment, mais j''aimerais beaucoup qu''on se rencontre.'),
  -- Excuses : sincères, sans se justifier à l'excès.
  ('apology', 1, 'Je suis désolé(e) pour tout à l''heure. Ce n''était pas correct de ma part, et je comprends que ça t''ait blessé(e).'),
  ('apology', 2, 'Je te dois des excuses : j''ai mis du temps à répondre et ce n''était pas l''image que je voulais donner.'),
  ('apology', 3, 'J''ai réfléchi à ce que tu m''as dit, et tu as raison. Je suis désolé(e).'),
  ('apology', 4, 'Désolé(e) d''avoir annulé au dernier moment. J''aimerais vraiment me rattraper, si tu es d''accord.'),
  ('apology', 5, 'Mon message était maladroit, je m''en excuse. Ce n''est pas ce que je voulais dire.'),
  ('apology', 6, 'Je ne cherche pas d''excuse : je me suis trompé(e) et je le regrette sincèrement.'),
  ('apology', 7, 'Je comprends si tu as besoin de temps. Je voulais juste te dire que je suis sincèrement désolé(e).'),
  ('apology', 8, 'Je n''aurais pas dû réagir comme ça. Merci de m''avoir dit ce que tu ressentais.'),
  -- Rupture douce : clair, respectueux, sans faux espoirs.
  ('soft_breakup', 1, 'J''ai passé de bons moments avec toi, mais je ne ressens pas ce qu''il faudrait pour aller plus loin. Je préfère être honnête avec toi.'),
  ('soft_breakup', 2, 'Je tiens à être sincère : je ne pense pas que nous soyons faits l''un pour l''autre. Je te souhaite vraiment le meilleur.'),
  ('soft_breakup', 3, 'Merci pour nos échanges. De mon côté, je préfère ne pas continuer, et je voulais te le dire directement.'),
  ('soft_breakup', 4, 'Tu es une personne géniale, mais je ne suis pas dans le bon état d''esprit pour une relation en ce moment.'),
  ('soft_breakup', 5, 'Je préfère te le dire plutôt que de disparaître : je ne souhaite pas qu''on se revoie. Prends soin de toi.'),
  ('soft_breakup', 6, 'J''ai beaucoup réfléchi, et je pense qu''il vaut mieux qu''on en reste là. Merci pour tout.'),
  ('soft_breakup', 7, 'Ce n''est pas facile à écrire, mais je ne vois pas d''avenir entre nous. Je ne voulais pas te laisser dans le doute.'),
  ('soft_breakup', 8, 'Je garde un bon souvenir de nos moments, mais je préfère arrêter ici. Je te souhaite de trouver ce que tu cherches.');
