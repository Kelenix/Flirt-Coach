# FAQ et support

Pour la personne qui répond aux utilisateurs. Contient les questions fréquentes, le diagnostic
des problèmes courants et des réponses types prêtes à adapter.

- **Source de la FAQ affichée dans l'app** : `assets/help/faq_fr.txt` (Réglages → « Aide et
  questions fréquentes »). La modifier là, puis publier une nouvelle version de l'app.
- **Fonctionnement détaillé** : [guide utilisateur](../guide/guide-utilisateur.md).
- **Ton** : tutoiement, bienveillant, concret ([charte éditoriale](../style-guide.md)).

## 1. Questions fréquentes

| Question | Réponse courte |
|----------|----------------|
| C'est gratuit ? | Oui : 5 crédits par jour, la banque de messages, et 2 crédits par vidéo regardée (5 vidéos par jour). Premium et les packs sont payants. |
| Quand reviennent mes crédits ? | Chaque jour à minuit heure universelle (1 h ou 2 h du matin en France). Ils ne se cumulent pas. |
| Les crédits achetés expirent-ils ? | Non. Ils sont utilisés après les crédits du jour. |
| Pourquoi un refus ? | Le coach refuse les demandes explicites, haineuses, insistantes ou manipulatrices. Aucun crédit n'est débité. |
| Les réponses sont en anglais | Le coach répond dans la langue de la conversation. Coller un message et écrire le contexte en français. |
| Ma capture n'est pas lue | Capture nette, sans zoom, avec les bulles des deux personnes. Aucun crédit débité si elle est illisible. |
| Gardez-vous mes captures ? | Non, jamais. Elles servent uniquement à proposer les réponses. |
| Comment résilier ? | Dans le store (Google Play ou App Store), au plus tard 24 h avant le renouvellement. |
| Je change de téléphone | Sur le nouveau téléphone : écran Premium → « Restaurer mes achats », avec le même compte store ; Premium suit en quelques secondes. Les crédits achetés et l'historique ne se transfèrent pas. |
| Supprimer mes données | Réglages → « Supprimer mon compte » : historique, crédits et signalements effacés immédiatement ; le client RevenueCat aussi, une fois la [tâche manuelle 14](../manual-tasks.md#14-clé-secrète-revenuecat) faite. |
| Utilisable sans Internet ? | Seulement la banque de messages (après une première ouverture). |
| Pourquoi des publicités ? | Elles financent la version gratuite ; Premium n'en contient aucune. |

## 2. Diagnostic

Les comptes sont **anonymes** : l'utilisateur n'a ni e-mail ni identifiant visible, on ne peut
donc pas retrouver son compte à partir d'un message. Le diagnostic repose sur les symptômes et
sur les tableaux de bord ([exploitation](../operations.md#surveiller)).

| Symptôme décrit | Vérifier | Résolution |
|-----------------|----------|------------|
| « Premium n'apparaît pas après l'achat » | RevenueCat → client / transactions récentes ; journaux de `revenuecat-webhook` | quelques secondes d'attente, retour à l'écran principal, puis « Restaurer mes achats » ; si les webhooks échouent, [incidents](../operations.md#incidents-fréquents) |
| « Vidéo vue, pas de crédits » | codes HTTP des appels à `admob-ssv` (journaux des fonctions) | limite de 5 vidéos par jour atteinte, vidéo interrompue, ou configuration SSV (tâches manuelles 8 et 15) |
| « J'ai perdu Premium en changeant de téléphone » | « Restaurer mes achats » fait avec le même compte store ? RevenueCat → client → événement `TRANSFER` et réponse du webhook | sinon, le lui faire faire ; réponse `nothing_to_transfer` : [rétablir Premium à la main](../operations.md#rétablir-premium-après-un-changement-de-téléphone) |
| « Le coach est indisponible » pour tout le monde | console Anthropic, `supabase secrets list` | clé ou quota IA : voir [incidents](../operations.md#incidents-fréquents) ; les crédits ont été remboursés |
| « Tu vas un peu vite » | — | plus de 10 demandes en une minute : attendre une minute |
| « Limite de générations pour aujourd'hui » | — | 100 demandes par jour, Premium compris : attendre le lendemain (minuit UTC) |
| « Mes crédits ont disparu » | — | crédits du jour remis à 5 (non cumulables) ; après une réinstallation, nouveau compte anonyme : les packs achetés ne se récupèrent pas |
| « L'app reste sur le logo » / « Configuration manquante » | version installée | version compilée sans configuration : réservé aux builds de test, jamais une version store |
| Réponse choquante signalée | table `reports` | voir [modération](../operations.md#modérer-les-signalements) |

## 3. Réponses types

Adapter le prénom et le détail ; ne jamais demander de capture de conversation (elle contient
les données d'une autre personne). Si l'utilisateur en envoie une, la supprimer après traitement.

### Premium non activé après un achat

> Bonjour,
>
> Merci pour ton achat ! La confirmation du store prend parfois quelques secondes. Reviens à
> l'écran principal, puis ferme et rouvre l'app. Si Premium n'apparaît toujours pas, ouvre
> l'écran Premium et touche « Restaurer mes achats » avec le même compte Google Play ou Apple.
>
> Si le problème continue, réponds-moi en précisant la date de l'achat et la formule choisie :
> je vérifie de mon côté.

### Demande de remboursement

> Bonjour,
>
> Les paiements passent par le store, qui gère seul les remboursements :
> - **Google Play** : play.google.com → Paramètres → Budget et historique, ou le lien « Demander
>   un remboursement » reçu par e-mail ;
> - **App Store** : reportaproblem.apple.com.
>
> Si le remboursement est accordé, l'accès Premium, ou les crédits restants du pack, sont
> retirés automatiquement.

### Résiliation

> Bonjour,
>
> Tu peux résilier à tout moment dans le store : dans l'app, Réglages → « Gérer mon abonnement »,
> ou directement dans Google Play / l'App Store. Fais-le au plus tard 24 h avant la date de
> renouvellement ; Premium reste actif jusqu'à la fin de la période payée.

### Crédits non reçus après une vidéo

> Bonjour,
>
> Les 2 crédits sont ajoutés quand la vidéo a été regardée jusqu'au bout, en quelques secondes.
> Il y a une limite de 5 vidéos par jour. Si la vidéo était complète et que les crédits ne sont
> toujours pas arrivés après quelques minutes, dis-moi l'heure approximative : je vérifie.

### Suppression des données (RGPD)

> Bonjour,
>
> Tu peux supprimer ton compte et toutes tes données toi-même, immédiatement : Réglages →
> « Supprimer mon compte ». Ton historique, tes crédits et tes signalements sont effacés
> définitivement. Pense à résilier un éventuel abonnement dans le store : la suppression du
> compte ne l'arrête pas.

### Réponse jugée inappropriée

> Bonjour,
>
> Merci de nous l'avoir signalé, et désolé pour cette réponse. Le coach doit toujours proposer
> des messages respectueux. Le plus efficace est de toucher le drapeau sur la réponse : le
> signalement nous parvient avec le texte concerné et nous sert à corriger le coach.

### Changement de téléphone

> Bonjour,
>
> Merci pour ton message. Sur ton nouveau téléphone, ouvre l'écran Premium et touche
> « Restaurer mes achats », avec le même compte Google Play ou Apple : ton abonnement passe sur
> la nouvelle installation en quelques secondes. Si Premium n'apparaît toujours pas, réponds-moi
> avec le numéro de commande indiqué dans l'e-mail de confirmation du store : je le rétablis.
>
> Les crédits achetés et l'historique sont liés à l'installation précédente : ils ne peuvent
> malheureusement pas être transférés.

### Réponses dans une autre langue

> Bonjour,
>
> Le coach répond dans la langue de la conversation : si le message reçu est en anglais, les
> réponses le seront aussi. Pour obtenir du français, colle un message en français et écris le
> contexte en français.

## 4. Engagements de service

| Sujet | Règle |
|-------|-------|
| Délai de réponse | à fixer avant la publication (proposition : 2 jours ouvrés) |
| Adresse de contact | `SUPPORT_EMAIL` dans `config/prod.json` ([tâche manuelle 12](../manual-tasks.md#12-éditeur-et-e-mail-de-support)) |
| Données reçues par e-mail | ne garder que le nécessaire, supprimer les pièces jointes une fois traitées |
| Demande d'un mineur | rappeler que l'app est réservée aux 18 ans et plus, conseiller la suppression du compte |
| Menace, harcèlement signalé | ne pas traiter seul : orienter vers les autorités compétentes |
