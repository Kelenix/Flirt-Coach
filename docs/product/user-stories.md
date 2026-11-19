# User stories — Flirt Coach Pro (V1)

> Phase 1 — Product Owner. Chaque story trace vers l'INTAKE. MoSCoW : **M**ust / **S**hould /
> **C**ould. Taille relative S/M/L. Toute génération exige le réseau : hors-ligne, l'app
> affiche un message clair et ne débite aucun crédit.

## Personas

| Persona | Contexte d'usage |
|---------|------------------|
| **Sam, 24 ans, « en pleine conversation »** | Sur une appli de rencontre, vient de recevoir un message, veut répondre dans la minute. Mobile, une main, souvent en 4G. Utilisation par à-coups → cible de l'abonnement hebdomadaire. |
| **Alex, 31 ans, « veut bien faire »** | Peu sûr de lui, relit ses messages avant envoi, craint d'être lourd. Utilise le mode Respect et l'analyse de conversation. |
| **Charlie, 27 ans, « occasionnel »** | Refuse les abonnements ; utilise les crédits du jour, regarde une pub ou achète un pack ponctuel. |

## Stories

### E1 — Accès et confiance

**US-01 (M, S) — Confirmation d'âge** · INTAKE §7.1
En tant que nouvel utilisateur, je veux confirmer que j'ai 18 ans ou plus afin d'accéder à l'app.
- *Given* un premier lancement, *when* la case « J'ai 18 ans ou plus » n'est pas cochée, *then* le bouton « Commencer » est désactivé.
- *Given* la case cochée, *when* je valide, *then* la confirmation est mémorisée et n'est plus redemandée.
- *Given* une confirmation absente, *when* j'ouvre un lien interne quelconque, *then* je suis ramené à l'écran d'accueil 18+.

**US-02 (M, S) — Transparence IA** · §7.4
En tant qu'utilisateur, je veux savoir que les réponses sont des suggestions sans garantie afin de garder mon jugement.
- L'écran d'accueil et l'écran de résultats affichent la mention « Suggestions générées par IA — aucun résultat garanti ».

**US-03 (M, M) — Démarrage sans inscription** · §4
En tant qu'utilisateur, je veux utiliser l'app immédiatement afin d'obtenir une réponse sans créer de compte.
- *Given* le premier lancement validé, *then* une session anonyme est créée en arrière-plan et j'arrive sur « Colle son dernier message ».
- *Given* pas de réseau au premier lancement, *then* un écran d'erreur propose « Réessayer ».

**US-04 (S, M) — Rattacher un e-mail** · hypothèse H3
En tant qu'utilisateur, je veux rattacher un e-mail afin de retrouver mes crédits et mon historique sur un autre appareil.

**US-05 (M, S) — Supprimer mon compte** · exigence stores (H9)
- *Given* les réglages, *when* je confirme la suppression, *then* mes données serveur sont effacées et l'app revient au premier lancement.

**US-06 (M, S) — Politique de confidentialité et CGU** · §7.3, §7.5
- Accessibles depuis l'accueil 18+ et les réglages ; expliquent l'usage des données et la non-conservation des captures.

**US-07 (M, S) — Signaler un contenu** · §7.5
En tant qu'utilisateur, je veux signaler une réponse problématique afin qu'elle soit examinée.
- *Given* une réponse générée, *when* je touche « Signaler » et choisis un motif, *then* le signalement est enregistré et un message de confirmation s'affiche.

### E2 — Génération de messages

**US-10 (M, L) — Répondre à un message reçu** · §2.1, §4
En tant que Sam, je veux coller le dernier message reçu afin d'obtenir 3 réponses adaptées.
- *Given* un texte collé (1 à 2 000 caractères) et ≥ 1 crédit, *when* je touche « Générer 3 réponses », *then* 3 propositions s'affichent en moins de 10 s et 1 crédit est débité.
- *Given* 0 crédit, *then* la génération est refusée et les options « Regarder une pub » / « Passer Premium » s'affichent.
- *Given* une erreur IA ou réseau, *then* aucun crédit n'est débité et un message d'erreur propose de réessayer.
- Chaque proposition a un bouton « Copier ».

**US-11 (M, M) — Autres situations** · §2.1
En tant qu'utilisateur, je veux choisir une situation (démarrer, flirter, relancer, avant un rendez-vous, excuses, rupture douce) afin d'obtenir un message adapté.
- Chaque situation propose un champ de contexte facultatif ; résultat = 3 propositions, 1 crédit.

**US-12 (M, M) — Styles** · §2.3
En tant qu'utilisateur, je veux choisir un ton afin d'adapter le message.
- Style de base « Classique » gratuit. Styles avancés (Drôle, Romantique, Mystérieux, Direct, Élégant, Provocateur léger) affichés avec un cadenas pour les gratuits ; les toucher ouvre le paywall.
- Le verrou est appliqué **côté serveur** : une requête gratuite avec un style avancé est refusée.

**US-13 (M, M) — Modération** · §1.4, §7.2
- Aucune réponse haineuse, harcelante, sexuellement explicite ou manipulatrice. *Given* une demande qui vise un tel contenu, *then* l'app répond par un refus expliqué, sans débit de crédit.

**US-14 (S, L) — Réponse à une capture d'écran** · §2.2
En tant qu'utilisateur, je veux envoyer une capture de conversation afin d'obtenir 3 réponses contextualisées.
- Sélection via le sélecteur de photos système (aucune permission de galerie permanente).
- Gratuit : 2 crédits ; Premium : inclus. Image ≤ 5 Mo, jamais stockée (ADR-006).
- *Given* une image illisible ou sans conversation, *then* message explicite et aucun débit.

**US-15 (S, M) — Mode Respect** · §2.6
En tant qu'Alex, je veux faire vérifier mon message afin de savoir s'il est trop insistant, sexualisé ou manipulateur.
- Résultat : verdict (OK / à revoir), raison(s) parmi les 3 catégories, alternative respectueuse proposée.

**US-16 (S, M) — Analyse de conversation** · §2.4 — Premium
- Résultat : la conversation progresse-t-elle (oui / stagne / recule), prochaine étape conseillée, proposition de rendez-vous si le contexte s'y prête.
- Gratuit : écran verrouillé menant au paywall.

**US-17 (C, M) — Banque de messages** · §2.5
- 5 catégories (ouverture, relance, rendez-vous, excuses, rupture douce), consultables hors-ligne après un premier chargement, copie en un geste.

**US-18 (C, M) — Historique** · §2.7 — Premium
- Liste des générations passées (texte seulement), suppression individuelle. Gratuit : verrouillé.

### E3 — Monétisation

**US-20 (M, M) — Crédits quotidiens** · §3.2
- Gratuit : solde remis à 5 chaque jour (UTC), non cumulable. Solde visible en permanence.

**US-21 (S, L) — S'abonner** · §3.1, §8
- 3 durées (hebdo, mensuel, annuel), mêmes droits. Prix lus depuis le store. « Restaurer mes achats » présent. Mentions de renouvellement conformes aux stores.
- Premium : tous les styles, capture, analyse, historique, aucune pub, plafond d'usage 100 générations/jour.

**US-22 (S, M) — Acheter un pack de crédits** · §3.2
- Packs 20 / 50 / 100, crédités après validation serveur, sans expiration.

**US-23 (S, M) — Vidéo récompensée** · §3.3
- Gratuit uniquement : +2 crédits après visionnage complet, validés côté serveur, 5 par jour maximum.

**US-24 (C, S) — Bannière** · §3.3
- Gratuit uniquement, en bas d'écran, jamais au lancement ni en plein écran.

**US-25 (S, S) — Offre annuelle à J+3** · §4
- *Given* un utilisateur gratuit dont le premier lancement date de ≥ 3 jours, *when* il ouvre l'app, *then* l'offre annuelle remisée est présentée une fois (fermable).

**US-26 (S, S) — Consentement publicitaire** · RGPD / ATT
- Le consentement est demandé avant la première publicité ; un refus n'empêche pas d'utiliser l'app.

## Périmètre

- **MVP démontrable** : US-01, 02, 03, 10, 11, 12, 13, 20.
- **V1 complète** : toutes les stories ci-dessus.
- **Hors périmètre V1** : coach de profil (ADR-007), notifications push, web/desktop.

## Couverture INTAKE ↔ stories

| INTAKE | Stories |
|--------|---------|
| §1.4 limites, §7.2 modération | US-13, US-15 |
| §2.1 génération | US-10, US-11 |
| §2.2 capture | US-14 |
| §2.3 styles | US-12 |
| §2.4 analyse | US-16 |
| §2.5 banque | US-17 |
| §2.6 respect | US-15 |
| §2.7 historique | US-18 |
| §3.1 abonnements | US-21, US-25 |
| §3.2 crédits | US-20, US-22 |
| §3.3 publicités | US-23, US-24, US-26 |
| §4 parcours | US-03, US-10, US-12, US-25 |
| §7.1 âge | US-01 |
| §7.3 confidentialité | US-06, US-14 |
| §7.4 transparence | US-02 |
| §7.5 signalement | US-06, US-07 |
| §8 stores | US-05, US-21, US-22 |
