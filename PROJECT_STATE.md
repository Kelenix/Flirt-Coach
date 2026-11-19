# État du projet — PROJECT_STATE

> Mis à jour par Claude à la fin de chaque phase / incrément. Permet de **reprendre** le
> travail à tout moment, même dans une nouvelle session. Toujours lire ce fichier avant d'agir.

## Snapshot

- **Phase courante** : 7 — Documentation terminée ; prochaine : 6 — Publication (dépend des comptes stores)
- **Dernière mise à jour** : 2026-11-18
- **Santé** : 🟢 OK
- **Mode** : PLAN_PUIS_VALIDATION (plan validé le 2026-11-18, options par défaut retenues)
- **Prochaine action** : décision sur la protection anti-comptes en série (tâche 17), puis
  phase 6 — Publication (tâches manuelles 3 à 15, textes prêts dans `docs/store/fiche-store.md`).
  Rappels : vrais achats (comptes stores + RevenueCat) et vraie
  récompense publicitaire (AdMob) restent à vérifier une fois les comptes créés.

## Avancement par phase

| Phase | État | Notes |
|-------|------|-------|
| 0 — Cadrage & intake        | ✅ fait | Plan validé, options par défaut |
| 1 — Définition produit      | ✅ fait | `docs/product/user-stories.md` |
| 2 — Planification           | ✅ fait | `docs/risks.md`, backlog ci-dessous |
| 3 — Architecture & design   | ✅ fait | `docs/architecture.md`, `system-design.md`, `data-model.md`, `docs/design/` |
| 4 — Implémentation          | ✅ fait | Inc-0 à Inc-10 ; US-04 (e-mail) reporté |
| 5 — Qualité & performance   | ✅ fait | `docs/qa/revue-phase5.md`, `docs/security.md`, `docs/performance.md`, `docs/qa/test-plan.md` ; mesure sur téléphone réel à faire (tâche 18) |
| 6 — Publication (stores)    | ⬜ à faire | |
| 7 — Documentation           | ✅ fait | `README.md` = documentation principale (bannière au logo, schéma d'architecture, toutes les sections) ; annexes dans `docs/` ; `CHANGELOG.md` ; aide dans l'app (ADR-026) |
| 8 — Maintenance             | ⬜ à faire | |

> États : ⬜ à faire · 🔄 en cours · ✅ fait · ⏸️ en attente (raison)

## Reformulation du besoin (validée ✅ 2026-11-18)

**Objectif.** Application mobile (Android + iOS) d'assistance à la communication romantique
par IA, pour adultes 18+, positionnée « séduction respectueuse » (jamais manipulation, jamais
contenu sexuel explicite). Monétisation : abonnements d'abord, crédits ensuite, publicité en
complément.

**Périmètre V1 (INTAKE §9).** Génération/réponse IA (7 situations) · styles de base + 6 styles
avancés · capture d'écran → 3 réponses · analyse de conversation · banque de messages · mode
Respect · historique Premium · abonnements hebdo/mensuel/annuel · crédits + packs 20/50/100 ·
bannière + vidéo récompensée (+2 crédits) · case 18+, confidentialité, signalement.

**Hors périmètre V1.** Coach de profil (cité aux §3.1 et §5 mais absent des §2 et §9 —
ADR-007) · imitation d'une personne réelle · contenu explicite · web/desktop · mode hors-ligne
de génération (l'IA exige le réseau).

**Hypothèses comblant les trous de l'INTAKE** (contestables, voir DECISION_LOG) :

| # | Hypothèse | Réf. |
|---|-----------|------|
| H1 | 1 crédit = 1 génération (qui renvoie 3 propositions). Gratuit : 5 crédits/jour, remis à 5 chaque jour, non cumulables. Crédits achetés/récompensés : sans expiration, consommés après les crédits du jour. | ADR-005 |
| H2 | Un seul niveau Premium, trois durées (hebdo/mensuel/annuel) avec les mêmes droits — conforme au tableau §5. | Q3 |
| H3 | Pas d'inscription obligatoire : compte anonyme créé au 1er lancement (parcours §4 « Colle son dernier message » immédiat) ; rattachement e-mail optionnel pour conserver crédits/historique. | ADR-002 |
| H4 | Captures d'écran traitées en mémoire puis jetées : jamais stockées. L'historique ne garde que le texte généré. | ADR-006 |
| H5 | Banque de messages : contenu statique, consultable par tous sans crédit ; « personnaliser avec l'IA » consomme 1 crédit. | — |
| H6 | Mode Respect : (a) garde-fou automatique sur toute génération, (b) outil « vérifie mon message » à 1 crédit pour les gratuits. | — |
| H7 | Vidéo récompensée plafonnée à 5/jour (anti-abus), validée côté serveur. | ADR-008 |
| H8 | « Offre annuelle après 3 jours » = paywall dédié affiché à J+3, la remise étant une offre promotionnelle configurée dans les stores. | — |
| H9 | Suppression de compte in-app ajoutée (obligation Apple/Google dès qu'un compte existe), bien que non citée dans l'INTAKE. | — |
| H10 | Analyse de conversation : entrée par texte collé ou capture ; Premium uniquement. | — |

## Architecture cible (résumé — détaillée en phase 3)

- **App** : Flutter, architecture feature-first en couches (présentation → application/Riverpod
  → domaine → données), go_router, freezed, l10n ARB.
- **Design** : kit de marque néon (`Kit di brand Flirt Coach in stile neon.png`, ADR-010) —
  couleurs, Poppins/Inter, écrans de référence.
- **Environnement de dev** : Supabase local sous Docker (`supabase start`, ADR-009) ; cloud
  uniquement à la publication.
- **Backend** : Supabase — Auth (anonyme + e-mail), Postgres + RLS sur toutes les tables,
  Edge Functions pour tout ce qui touche à l'IA, aux crédits et aux achats.
- **Règle de sécurité centrale** : le client ne modifie jamais ni crédits ni droits Premium ;
  il appelle une Edge Function qui vérifie le quota, débite, modère, appelle l'IA. La clé IA
  ne quitte jamais le serveur.
- **Tables pressenties** : `profiles`, `credit_ledger`, `entitlements`, `generations`
  (historique), `message_bank`, `reports`, `ad_rewards`.

## Backlog incréments (incrément vertical = livrable)

| ID | Incrément | Exigence liée | Priorité | État |
|----|-----------|---------------|----------|------|
| Inc-0 | Socle : projet Flutter, thème, navigation, Supabase + auth anonyme, CI, écran 18+ / avertissement IA | §7.1, §7.4 | P0 | ✅ |
| Inc-1 | Parcours principal : coller un message → 3 réponses (styles de base), copie, crédits quotidiens côté serveur, modération | §2.1, §3.2, §4, §7.2 | P0 | ✅ |
| Inc-2 | 7 situations de génération + styles avancés verrouillés Premium | §2.1, §2.3 | P0 | ✅ |
| Inc-3 | Mode Respect (détection + alternative) | §2.6 | P0 | ✅ |
| Inc-4 | Capture d'écran → 3 réponses (2 crédits, image non conservée) | §2.2, §7.3 | P1 | ✅ |
| Inc-5 | Monétisation : abonnements, packs de crédits, paywall, offre annuelle J+3, restauration | §3.1, §3.2, §4, §8 | P1 | ✅ code · ⬜ achat réel |
| Inc-6 | Publicités : bannière + récompensée (+2 crédits), consentement RGPD/ATT, aucune pub Premium | §3.3 | P1 | ✅ code · ⬜ récompense réelle |
| Inc-7 | Analyse de conversation (Premium) | §2.4 | P1 | ✅ |
| Inc-8 | Banque de messages (5 catégories) | §2.5 | P2 | ✅ |
| Inc-9 | Historique Premium | §2.7 | P2 | ✅ |
| Inc-10 | Confiance : signalement, politique de confidentialité, CGU, réglages, suppression de compte | §7.3, §7.5 | P1 | ✅ |

### Inc-0 — état de la Definition of Done

| Critère | État |
|---------|------|
| Écran 18+ : bouton bloqué sans la case, erreur réseau avec nouvelle tentative, accès direct aux lancements suivants | ✅ testé (8 tests) |
| `flutter analyze` sans problème, code formaté | ✅ |
| Thème du kit de marque, polices embarquées, textes en ARB | ✅ (rendu non vu sur appareil) |
| Session en Keychain/Keystore, aucune clé dans le code | ✅ |
| Migration `profiles` + RLS + `confirm_age()` | ✅ appliquée sur Supabase local (Docker) |
| Tests RLS (`supabase test db`) | ✅ 11/11 : isolation entre comptes, aucune écriture directe, `confirm_age()` limité à l'appelant, refusé à `anon` |
| Parcours serveur réel (HTTP local) | ✅ connexion anonyme → `confirm_age` → profil lu et horodaté ; appel sans session refusé (401) |
| Compilation Android (`flutter build apk --debug`) | ✅ APK produit par l'utilisateur (Gradle ne démarre pas depuis la session Claude : `Unable to establish loopback connection`, limite de l'environnement) |
| L'app démarre sur émulateur avec la base locale | ✅ émulateur Android 15 : écran 18+ conforme au kit (trait sombre du logo corrigé en Inc-2) |
| CI GitHub Actions | ⚠️ fichier écrit, jamais exécuté (pas de dépôt Git) |
| Liens Confidentialité / Conditions sur l'accueil | ✅ Inc-10 |

L'écran d'accueil après confirmation est provisoire (marque + avertissement) : l'écran
« Générer un message » le remplace en Inc-1.

### Inc-1 — état de la Definition of Done

| Critère | État |
|---------|------|
| Migration crédits / droits / générations + RLS | ✅ appliquée ; `supabase db reset` rejoue tout depuis zéro |
| Tests SQL (`supabase test db`) | ✅ 35/35 : débit jour puis bonus, remboursement exact, solde insuffisant, remise quotidienne non cumulable, Premium sans débit + plafond 100, abonnement expiré, client incapable de modifier solde/droits, historique réservé Premium |
| Edge Function `generate` : types, lint, format, tests | ✅ 7 tests (validation, verrou des styles, isolement du message, sortie du modèle) |
| Fonction sur serveur local, chemins sans IA | ✅ 401 sans session · 403 âge non confirmé · 400 requête invalide · 403 style Premium · 402 sans crédit · 503 IA indisponible **avec crédit rendu** |
| Génération réelle par Claude | ✅ 3 appels réels : message ordinaire (3 réponses pertinentes), refus exprimé par l'autre personne (réponses qui respectent le refus), tentative de détournement (traitée comme un message reçu). 3 à 7 s par appel ; 3 crédits débités |
| Écrans Générer / Résultats (copie, régénérer, style verrouillé, refus, erreurs, crédits) | ✅ 10 tests de widgets ; 18 tests Flutter au total |
| `flutter analyze` | ✅ aucun problème |
| Débordement petit écran + grande police | ✅ trouvé par le test puis corrigé (en-tête) |
| Rendu sur appareil | ✅ testé par l'utilisateur sur émulateur |
| Style verrouillé → paywall | provisoire : message « Débloque… avec Premium » ; le paywall arrive en Inc-5 |
| Plus de crédits → pub / Premium | provisoire : message « reviens demain » ; boutons en Inc-5 / Inc-6 |

### Inc-2 — état de la Definition of Done

| Critère | État |
|---------|------|
| 7 situations côté serveur (validation : message reçu obligatoire seulement pour « Répondre », contexte facultatif ≤ 1000 car.) | ✅ 10 tests Deno |
| Consigne propre à chaque situation, données utilisateur isolées dans des balises | ✅ testé |
| Migration `context_text` | ✅ appliquée ; 35 tests SQL verts |
| Écran : menu des 7 situations, champ message seulement pour « Répondre », contexte avec indice adapté | ✅ 3 nouveaux tests ; 21 tests Flutter au total |
| Bouton « Générer » fixé en bas (il passait sous l'écran avec le nouveau champ — trouvé par les tests) | ✅ |
| Styles avancés verrouillés Premium | ✅ (fait en Inc-1, serveur + écran) |
| Logo : trait sombre entre bulle et pointe | ✅ corrigé (union des formes) |
| Contrôle visuel sur émulateur | ✅ un défaut vu seulement à l'écran : menu « Situation » sans fond clair (texte invisible) → thème du menu aligné sur les champs |
| Générations réelles | ✅ accroche à partir d'un profil, excuses, rupture douce : pertinentes, 5 à 10 s |
| Analyse | ✅ aucun problème |

Remarque : sans connaître le genre de l'utilisateur, le modèle écrit « désolé(e) », « franc(he) ».
Une préférence de genre dans les réglages l'éviterait (non demandé par l'INTAKE, à proposer).

### Inc-3 — état de la Definition of Done

| Critère | État |
|---------|------|
| Socle serveur commun aux appels IA (`_shared/ai_endpoint.ts` : session, âge, Premium, crédits, remboursement, appel Claude, enregistrement) ; `generate` réécrit dessus | ✅ 10 tests Deno inchangés, appel réel de non-régression OK |
| Edge Function `respect-check` : 3 risques (insistant, sexualisé, manipulateur), verdict + explications + alternative ; 1 crédit (gratuit), inclus Premium | ✅ 6 tests Deno |
| Appels réels | ✅ message sain → « ok » ; relance après 4 messages sans réponse → insistant + culpabilisant, alternative qui clôt sans pression ; « t'as de la chance que je m'intéresse à toi » + ultimatum → manipulateur + pression. 3 à 4 s, 1 crédit chacun |
| App : module `credits` séparé (portefeuille partagé par toutes les fonctionnalités), composants partagés (carte copiable, intitulés, bouton fixé en bas) | ✅ |
| Écran Mode Respect (accès par l'icône bouclier de l'accueil) : verdict, problèmes expliqués, alternative copiable, crédits, erreurs | ✅ 7 tests ; 28 tests Flutter au total |
| Garde-fou automatique sur chaque génération (H6 a) | ✅ déjà dans les consignes de `generate` depuis Inc-1 |
| Contrôle sur émulateur | ✅ parcours complet dans l'app : message insistant → « À revoir », « Trop insistant » expliqué, version respectueuse copiable, crédit décompté (19 → 18). Le résultat apparaît sous les champs : il faut faire défiler pour lire l'alternative |
| CI : les deux fonctions testées | ✅ (fichier mis à jour, jamais exécuté : pas de dépôt Git) |

### Inc-4 — état de la Definition of Done

| Critère | État |
|---------|------|
| Edge Function `screenshot-reply` (2 crédits gratuit, inclus Premium, styles avancés verrouillés, type d'image lu dans les octets, 3,5 Mo max) | ✅ 6 tests Deno ; 22 tests Deno au total |
| Appels réels | ✅ fausse capture WhatsApp → 3 réponses qui rebondissent sur la conversation (5 s, 2 crédits) ; image sans conversation → 422, rien débité ; style Premium → 403 |
| Image jamais conservée | ✅ vérifié en base : `input_text` nul, sortie de 440 octets, 0 fichier dans le stockage |
| App : icône « image » dans le champ message, sélecteur système, aperçu + coût + « jamais conservée », retrait, capture ignorée hors « Répondre » | ✅ 8 tests ; 36 tests Flutter au total |
| Vignette : débordement trouvé par les tests (image large / illisible) → taille fixe + remplacement | ✅ |
| iOS : texte d'usage de la photothèque (`NSPhotoLibraryUsageDescription`) | ✅ (non vérifié sur iPhone) |
| Contrôle sur émulateur | ✅ sélecteur photo système (aucune permission demandée), aperçu, génération depuis la capture : 3 réponses pertinentes, 17 → 15 crédits. Défaut vu à l'écran : « Régénérer (1 crédit) » au lieu de 2 → libellé désormais calculé (et sans coût pour Premium) |
| CI : les trois fonctions testées | ✅ fichier à jour, jamais exécuté |

### Inc-5 — état de la Definition of Done

| Critère | État |
|---------|------|
| Base : `grant_credits` idempotent, `set_premium` résistant au désordre des événements | ✅ 13 tests SQL ; 48 au total |
| Webhook RevenueCat (format vérifié dans la doc RevenueCat) : secret, packs, abonnements, expiration, résiliation, remboursement, alias anonymes, formules Google Play | ✅ 10 tests Deno ; 32 au total |
| Webhook en réel sur le serveur local (événements simulés) | ✅ faux secret 401 ; pack crédité 1 seule fois ; abonnement → Premium ; vieille expiration ignorée ; résiliation → reste Premium ; remboursement → retiré |
| App : SDK RevenueCat 11.0.2, paywall (3 offres, badges, prix du store, mentions de renouvellement, restauration, packs), accès par la pastille de crédits / style verrouillé / crédits épuisés, attente honnête si le webhook tarde, offre annuelle J+3 une seule fois | ✅ 15 tests ; 51 tests Flutter au total |
| Émulateur | ✅ paywall affiché ; sans clé RevenueCat : « Les achats ne sont pas disponibles pour le moment » |
| Achat réel (sandbox Google Play / App Store) | ⬜ impossible sans comptes stores + RevenueCat (tâches manuelles 4 à 7b) |
| Remboursement d'un pack de crédits | journalisé, crédits non repris (ADR-017) |
| Liens CGU / confidentialité sur le paywall (exigés par les stores) | ✅ Inc-10 |
| Avantages annoncés « Analyse de conversation et historique » | ✅ Analyse (Inc-7) et historique (Inc-9) livrés |

### Phase 5 — état de la Definition of Done

| Critère | État |
|---------|------|
| Revue de sécurité indépendante (serveur + app) | ✅ 12 constats : 9 corrigés, 3 reportés avec raison (`docs/qa/revue-phase5.md`) |
| Revue de code indépendante (app) | ✅ 17 constats : 15 corrigés, 2 reportés avec raison |
| Quotas d'appels IA sûrs (simultanéité, remboursements) | ✅ table `ai_usage` : 10/minute, 100/jour, comptés sous verrou avant l'appel |
| Accessibilité | ✅ 7 écrans conformes (cibles tactiles Android/iOS, libellés, contraste WCAG) |
| Bout en bout sur appareil | ✅ parcours accueil → Générer → Résultats → Banque → Réglages (émulateur) |
| Performance | ✅ démarrage 1,8 s ; construction des images 2,1 ms en moyenne ; ⚠️ rendu à confirmer sur téléphone ; APK arm64 24,4 Mo ; logos allégés ; plus de flash blanc au lancement |
| Tests | 115 Flutter, 99 SQL, 50 Deno, 1 bout en bout ; `flutter analyze`, `dart format`, `deno fmt/lint` propres |
| CI | ✅ couvre maintenant les 7 Edge Functions et `integration_test` (format) |
| Cloud | ✅ 3 migrations + 7 fonctions déployées ; vérifié : génération réelle, signalement inventé refusé (400), vrai signalement accepté (204), rappel AdMob incomplet refusé (400), webhook sans secret refusé (401) |

### Inc-10 — état de la Definition of Done

| Critère | État |
|---------|------|
| Signalement (US-07) : bouton « Signaler » sur chaque réponse, 5 motifs, `report_generation` (ses propres générations seulement, même gratuit, sans doublon), aucune lecture client | ✅ 7 tests SQL ; 2 tests Flutter ; vérifié sur émulateur (signalement en base) |
| Suppression de compte (US-05) : Edge Function `delete-account` (cascade complète, client RevenueCat effacé si clé secrète), session locale fermée, préférences effacées, retour à l'accueil 18+ | ✅ 2 tests SQL (cascade) ; 3 tests Flutter ; vérifié en réel (local) |
| Rappels RevenueCat / AdMob d'un compte supprimé ignorés (200) au lieu d'être rejoués sans fin | ✅ 1 test Deno ; 47 au total |
| Textes légaux (US-06) : confidentialité et conditions, accessibles depuis l'accueil 18+ (avant confirmation), le paywall et les réglages ; éditeur et contact par configuration | ✅ ; ⚠️ relecture juridique + valeurs à fournir (tâches 10, 12) |
| Réglages : Premium et crédits, gérer l'abonnement (Premium), confidentialité, conditions, préférences publicitaires (formulaire UMP), contact (si configuré), suppression du compte | ✅ 8 tests Flutter ; vérifié sur émulateur |
| Rattacher un e-mail (US-04) | ⏸️ reporté (ADR-024) |
| Tests | 93 Flutter, 84 SQL, 47 Deno ; `flutter analyze` propre |
| Cloud | ✅ 7 Edge Functions déployées dont `delete-account` ; vérifié : génération réelle, signalement (204), signalements illisibles depuis l'app, suppression sans jeton refusée (401), compte supprimé (200). Correctif : génération inconnue → 400 au lieu de 500 (migration `20261118070100`) |

### Inc-9 — état de la Definition of Done

| Critère | État |
|---------|------|
| Historique Premium sous RLS (déjà en place) ; entrées supprimées masquées | ✅ |
| Suppression : `delete_generation` efface texte, contexte et réponses, garde une ligne vide datée (sinon le plafond Premium de 100/jour serait contournable) ; plus de suppression directe ; visiteurs refusés | ✅ 9 tests SQL ; 75 au total |
| App : entrée « Historique » du menu, verrouillée + « Passer Premium » pour les gratuits, cartes (type, date, message saisi, réponses copiables), 20 par page + « Afficher plus », suppression confirmée, état vide, erreur + Réessayer | ✅ 11 tests Flutter ; 83 au total ; `flutter analyze` propre |
| Émulateur | ✅ entrée réelle affichée ; suppression → contenu effacé en base |
| Cloud | ✅ migration appliquée ; gratuit : historique vide (200), suppression possible (204), sans session refusée (401). Parcours Premium non testé sur le cloud (pas de moyen de passer un compte cloud en Premium sans achat réel) |

### Inc-8 — état de la Definition of Done

| Critère | État |
|---------|------|
| Table `message_bank` (5 catégories × 8 messages, français, espaces insécables), RLS lecture seule pour les connectés, rien pour les visiteurs, aucune écriture depuis l'app | ✅ 8 tests SQL (dont garde contre les caractères de contrôle) ; 66 au total |
| App : entrée « Banque » du menu, onglets par catégorie, cartes copiables, gratuite et sans crédit (H5) | ✅ 4 tests de parcours |
| Hors-ligne : copie locale (SharedPreferences, contenu public) servie si le réseau manque ou ne répond pas en 6 s | ✅ 2 tests ; vérifié sur émulateur réseau coupé |
| « Personnaliser avec l'IA » (H5) | ⏸️ reporté (ADR-022) |
| Cloud | ✅ migration appliquée ; 40 messages lus avec session, 0 sans session, écriture refusée (403) ; APK cloud reconstruit |

### Inc-7 — état de la Definition of Done

| Critère | État |
|---------|------|
| Edge Function `conversation-analysis` : texte collé (≤ 4000 car.) **ou** capture, contexte facultatif ; réservée à Premium (403 sinon), compte dans le plafond de 100/jour, aucun crédit débité | ✅ 9 tests Deno (requête, balises anti-injection, sortie, refus, capture illisible) ; 45 tests Deno au total |
| Résultat : dynamique (progresse / stagne / recule), constat, prochaine étape (en français), message à envoyer et rendez-vous (dans la langue de la conversation) ; jamais de rendez-vous si la conversation recule | ✅ vérifié en réel : anglais → message anglais avec rendez-vous ; italien qui recule → message italien, pas de rendez-vous |
| Pas de migration : `conversation_analysis` existait déjà ; capture jamais stockée (ADR-006) | ✅ |
| App : entrée « Analyse » du menu, écran verrouillé + « Passer Premium » pour les gratuits, saisie texte ou capture (aperçu partagé `ScreenshotPreview`), résultat avec cartes copiables | ✅ 6 tests Flutter ; 66 au total ; `flutter analyze` propre |
| Émulateur | ✅ écran verrouillé (gratuit) ; analyse réelle en Premium |

### Inc-6 — état de la Definition of Done

| Critère | État |
|---------|------|
| Base : `claim_ad_reward` (+2 crédits, 5/jour, idempotent, refus Premium) ; `wallet_of` source unique du portefeuille (avec vidéos restantes) | ✅ 10 tests SQL ; 58 au total |
| Edge Function `admob-ssv` : vérification ECDSA P-256 de Google (format confirmé dans la doc Google), clés Google en cache | ✅ 4 tests Deno avec vraies clés générées ; 36 au total |
| En réel (local) | ✅ clés Google téléchargées ; faux rappel → 403, rien crédité ; rappel incomplet → 400 ; `generate` renvoie le nouveau portefeuille |
| App : consentement Google (UMP) avant toute annonce, bannière 320×50 en bas (gratuits seulement), vidéo récompensée quand les crédits manquent, attente honnête du serveur, bouton masqué après 5 vidéos | ✅ 9 tests ; 60 tests Flutter au total |
| Émulateur (identifiants de test Google) | ✅ formulaire de consentement RGPD affiché ; refus → bannière de test non personnalisée affichée ; vidéo récompensée lue jusqu'au bout. Retouches faites après coup : bannière « grande adaptative » trop haute → format standard ; libellé « Passer Premium » ; bouton grisé masqué sans crédit ; bouton vidéo lisible pendant le chargement |
| Crédits gagnés par une vraie vidéo | ⬜ le rappel d'AdMob exige une URL publique (Supabase cloud) : en local, la récompense reste « en attente » |
| Formulaire de consentement en français et à la marque | ⬜ se configure dans AdMob (tâche 8) ; celui affiché est le formulaire de test de Google |
| Lien « Préférences publicitaires » (modifier son consentement) | ✅ Inc-10 (réglages, affiché si le consentement s'applique) |
| Catégories « rencontres » et « adulte » bloquées | ⬜ réglage de la console AdMob (tâche 8) |
| iOS (ATT, SKAdNetwork) | ✅ déclaré dans `Info.plist`, non vérifié sur iPhone |

Puis : phase 5 (perf, QA, revue), phase 6 (fiches stores, .aab / iOS, Fastlane), phase 7 (docs),
phase 8 (passation).

## Risques & parades

| Risque | Parade |
|--------|--------|
| Rejet store (appli « dating/IA », 18+) | Classification 17+/18+, signalement in-app, modération serveur, aucune promesse de résultat, pas de contenu explicite |
| Coût IA non maîtrisé (Premium « illimité », abus) | Quotas appliqués côté serveur, plafond d'usage raisonnable (Q3), modèle rapide/économique |
| Fraude aux crédits | Ledger serveur, RLS, validation serveur des achats et des pubs récompensées |
| Données de tiers dans les captures (RGPD) | Non-conservation, mention claire, politique de confidentialité, sous-traitant IA déclaré |
| Poste Windows : build iOS impossible en local | iOS compilé via runner macOS GitHub Actions ; vérification locale sur Android uniquement (Q4) |
| Injection de prompt via message collé / capture | Contenu utilisateur traité comme donnée, sortie structurée validée, modération en sortie |

## Décisions ouvertes / questions à l'utilisateur

Options par défaut validées en bloc par l'utilisateur le 2026-11-18 (« Oui, lance ») :

- [x] **Q1** Fournisseur IA : API Claude via Edge Function.
- [x] **Q2** Achats intégrés : RevenueCat.
- [x] **Q3** Premium : niveau unique, « illimité » plafonné à 100 générations/jour.
- [x] **Q4** Android + iOS, français seul.
- [x] **Q5** Nom : « Flirt Coach ».
- [x] **Q6** Prix : 6,99 €/sem · 12,99 €/mois · 49,99 €/an ; packs 2,99 / 5,99 / 9,99 €.
- [x] **Q7** Coach de profil : hors V1.
- [x] **Q8** Style « Drôle » : Premium ; seul « Classique » est gratuit.

Reste ouvert :

- [ ] **Q9 (financier)** Modèle IA : Claude Opus 5.5 (~0,01 $ par génération, ADR-014) ou
  Claude Haiku 5.5 (~40 fois moins cher, écriture moins fine) — défaut : Opus 5.5.
- [ ] **Identifiant d'application** : provisoire `com.flirtcoach.flirt_coach`. À fixer avant la
  première publication (définitif ensuite).

## Blocages

- (aucun)

## Tâches manuelles utilisateur en attente

- voir `docs/manual-tasks.md`

## Journal de session (résumé court, le plus récent en haut)

- 2026-11-18 — Abonnement restauré sur un nouveau téléphone (S12, ADR-027) : le webhook traite l'événement RevenueCat `TRANSFER` (fonction SQL `transfer_premium`) ; l'app attend la confirmation du serveur après « Restaurer mes achats ». Essai de bout en bout sur le serveur local : Premium déplacé, rejeu sans effet. 117 tests Flutter, 110 SQL, 51 Deno, analyse propre. Documentation et aide intégrée mises à jour. Déployé sur le cloud (migration appliquée, 7 fonctions redéployées) ; contrôlé : fonction SQL présente et refusée à la clé publique, webhook en ligne (401 sans secret).

- 2026-11-18 — Phase 7 (Documentation), reprise après retour de l'utilisateur (« pas professionnelle, même pas de logo », « la documentation dans le README, pas un site ») : `README.md` refait comme documentation principale (bannière générée depuis le logo et les polices du kit, badges, sommaire, captures, modèle économique, schéma d'architecture SVG, démarrage, configuration, tests, compilation, structure, sécurité, limites connues) ; annexes de `docs/` corrigées après relecture indépendante (23 écarts : restauration d'abonnement après changement de téléphone, identifiant iOS, offre de lancement, codes de l'API, conservation des données, permissions Android…) ; 113 liens, ancres et images vérifiés. Le site MkDocs commencé par erreur a été retiré. Aide intégrée corrigée (capture d'écran pas réservée à Premium ; changement de téléphone → support). 116 tests Flutter verts. README validé par l'utilisateur.

- 2026-11-18 — Phase 5 (Qualité & performance) : deux revues indépendantes, 24 corrections (quotas IA sûrs, achats sandbox refusés, packs remboursés repris, rappels AdMob limités à nos blocs, signalements vérifiés, erreurs après succès, portefeuille relu, double tap…), tests d'accessibilité et de bout en bout, mesures de performance (ADR-025). Erreur de ma part corrigée avant déploiement : contrôle des signalements contourné par un `NULL` (trouvé par le test). 115 Flutter, 99 SQL, 50 Deno.

- 2026-11-18 — Build sans `--dart-define-from-file` : l'app restait figée sur le logo ; elle affiche maintenant « Configuration manquante » avec la commande à utiliser (`ConfigurationErrorApp`, 1 test ; vérifié sur émulateur). 95 tests Flutter.

- 2026-11-18 — Inc-10 terminé : signalement, suppression de compte, textes légaux, réglages (ADR-024). Bug corrigé dans `scripts/deploy-cloud.ps1` (format JSON de la liste des projets). Tous les incréments fonctionnels (0 à 10) sont livrés ; reste la phase de publication.

- 2026-11-18 — Inc-9 terminé : historique Premium (ADR-023). Faille évitée : une vraie suppression aurait permis de dépasser le plafond Premium ; la suppression efface le contenu mais garde une ligne vide. 83 tests Flutter, 75 SQL. Fenêtres de confirmation aux couleurs du kit.

- 2026-11-18 — Inc-8 terminé : banque de messages (40 messages, 5 catégories), hors-ligne, gratuite (ADR-022). 72 tests Flutter, 66 SQL. Bugs trouvés sur émulateur et corrigés : tri inversé (le client Supabase trie en décroissant par défaut), requête sans fin hors réseau (délai 6 s). Erreur de ma part corrigée : une substitution avait remplacé « ? ! : » par un caractère de contrôle dans la migration et la base locale, avant tout envoi au cloud.

- 2026-11-18 — Supabase cloud (UE) relié : 6 migrations appliquées, 6 Edge Functions actives (verify_jwt conforme : webhook RevenueCat et AdMob publics, autres protégées — 401 sans session vérifié). Script `scripts/deploy-cloud.ps1`. Secret `ANTHROPIC_API_KEY` copié depuis le `.env` local. Connexion anonyme activée. Test bout en bout sur le cloud ✅ : session anonyme, âge exigé (403 avant), 5 crédits, génération et Mode Respect réels, analyse et style avancé refusés au gratuit (403), RLS (1 seul profil visible). APK `build/FlirtCoach-cloud.apk` (profile, branché sur le cloud). Build **release** ✅ (`app-release.apk`, 41 Mo, ~3 min). Cause du blocage initial : un démon Gradle resté actif verrouillait `classes.dex` (« fichier utilisé par un autre processus ») ; remède : `android\gradlew --stop` ou arrêter le processus Java, puis relancer. Le build doit recevoir `--dart-define-from-file=config/prod.json`, sinon l'app affiche « Configuration manquante ». Signature release à créer (tâche 11).

- 2026-11-18 — Inc-7 terminé : analyse de conversation Premium (texte ou capture), ADR-021. 66 tests Flutter, 45 Deno ; analyses réelles en anglais et italien validées. Comptes de test locaux passés Premium 1 jour pour essayer. Bande sombre de la barre de navigation supprimée (bord à bord), vague d'accueil redessinée.

- 2026-11-18 — Refonte UI selon le kit + nouveau logo et icône d'app (ADR-020) ; correctif keepAlive des contrôleurs. 60 tests Flutter verts, analyse propre ; accueil, Générer, menu, Résultats, Respect et Premium vérifiés sur émulateur. APK téléphone reconstruit.

- 2026-11-18 — Retours utilisateur : (1) réponses dans la langue de la conversation, vérifié en
  réel (message anglais, italien ; contexte espagnol ; captures anglaise et italienne ; mode
  Respect en anglais) ; (2) transitions fondu + glissement, APK téléphone en mode profile
  (compilé, fluide). Corrigé au passage : permission Internet absente du manifeste principal.
- 2026-11-18 — App installée et fonctionnelle sur le téléphone Android de l'utilisateur (APK de développement ARM, serveur local joint par le Wi-Fi ; procédure dans le README).
- 2026-11-18 — Inc-6 : publicités (consentement, bannière, vidéo récompensée), rappel AdMob signé vérifié côté serveur, portefeuille unifié. 58 tests SQL, 36 Deno, 60 Flutter ; consentement, bannière et vidéo vus sur émulateur.
- 2026-11-18 — Inc-5 : achats (webhook RevenueCat, crédits idempotents, Premium ordonné), paywall, offre J+3. 48 tests SQL, 32 Deno, 51 Flutter ; webhook vérifié en local. Achat réel non testable sans comptes.
- 2026-11-18 — Inc-4 : capture d'écran → 3 réponses (serveur, app, tests), image jamais stockée (ADR-016). 22 tests Deno, 35 SQL, 36 Flutter ; 3 appels réels validés.
- 2026-11-18 — Inc-3 : Mode Respect (serveur, app, tests), socle serveur IA commun, module credits. 16 tests Deno, 35 SQL, 28 Flutter ; 4 appels réels validés.
- 2026-11-18 — Inc-2 : 7 situations + contexte (serveur, base, écran), bouton fixé en bas, logo corrigé. 10 tests Deno, 35 SQL, 21 Flutter ; 3 générations réelles validées.
- 2026-11-18 — Clé IA en place (déplacée de `.env.example` vers `.env`, non versionné). 3 générations réelles validées. Inc-1 terminé.
- 2026-11-18 — Inc-1 : migration crédits/générations (35 tests SQL), Edge Function `generate`
  (Claude Opus 5.5, 7 tests Deno, chemins sans IA vérifiés en local), écrans Générer et
  Résultats (18 tests Flutter). Non vérifié : génération réelle (clé absente), rendu appareil.
- 2026-11-18 — Docker installé, Supabase local démarré, migration appliquée, 11 tests RLS
  verts, parcours serveur vérifié par HTTP, APK debug compilé. Reste : rendu sur appareil.
- 2026-11-18 — Plan validé. Phases 1 à 3 livrées (stories, risques, architecture, modèle de
  données, design system, parcours). Inc-0 : projet Flutter créé, socle codé, analyse propre,
  8 tests verts. Non vérifié : migration, RLS, lancement réel, CI.
- 2026-11-18 — Retours utilisateur intégrés : kit de marque néon (ADR-010), base de dev sous
  Docker (ADR-009, Docker absent du poste), réponses courtes dans le chat, détail dans les fichiers.
- 2026-11-18 — Phase 0 : lecture INTAKE, reformulation, hypothèses, plan de réalisation,
  initialisation PROJECT_STATE / DECISION_LOG / manual-tasks. Outils vérifiés : Flutter 3.41.7,
  Dart 3.11.5, Git 2.54, Supabase CLI 2.121. Pas encore de dépôt Git ni de code.
