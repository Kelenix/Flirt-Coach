# Journal de décisions (DECISION_LOG)

> ADR léger. Chaque décision structurante prise par Claude **en autonomie** y est consignée :
> contexte → décision → alternatives écartées → conséquences. Le plus récent en haut.

---

## ADR-030 — Textes légaux en ligne sur GitHub Pages

- **Date** : 2026-11-19
- **Statut** : Accepté
- **Décideur** : utilisateur (hébergement) ; Claude (rôle : documentation) pour la mise en œuvre
- **Contexte** : Google Play exige une URL publique pour la politique de confidentialité (pas de
  PDF), et l'App Store des conditions d'utilisation pour un abonnement. Le texte en ligne doit
  être identique à celui de l'app.
- **Décision** : pages générées par `scripts/legal_pages.py` à partir de `assets/legal/*.txt`
  (éditeur et contact lus dans `config/prod.json`, comme dans l'app), au même format que
  l'écran de l'app ; publiées sur la branche `gh-pages` du dépôt public :
  https://kelenix.github.io/Flirt-Coach/. Pages autonomes : pas de police ni de script
  externes, donc aucune requête vers des tiers.
- **Alternatives écartées** : Firebase Hosting (proposé, non retenu par l'utilisateur) ; page
  d'Edge Function Supabase (le domaine supabase.co ne sert pas de HTML) ; PDF (refusé par
  Google Play).
- **Conséquences** : toute modification des textes passe par `assets/legal/`, puis par la
  génération et la publication (`docs/operations.md`) ; l'adresse ne change pas. La branche
  `gh-pages` ne contient que les pages générées. La relecture par un juriste reste conseillée.
- **Impact** : légal — fort (obligation des stores) ; technique — faible.

---

## ADR-029 — Nom de l'app : « Flirt Coach Pro »

- **Date** : 2026-11-19
- **Statut** : Accepté (remplace la partie « nom » d'ADR-028)
- **Décideur** : utilisateur
- **Contexte** : l'app a été créée dans la Play Console sous le nom « Flirt Coach Pro ».
  L'utilisateur confirme que ce nom remplace « Flirt Coach » partout et demande de ne pas
  modifier le logo.
- **Décision** :
  - « Flirt Coach Pro » partout où le nom est écrit : sous l'icône (Android `android:label`, iOS
    `CFBundleDisplayName`), dans l'app (`appName` ; titre de l'écran Premium « Flirt Coach Pro
    Premium »), mentions légales, aide intégrée, consignes du coach côté serveur, fiche du store,
    README et documentation.
  - Logo inchangé : symbole, mot-symbole « FlirtCoach » et bannière du README restent tels
    quels ; le libellé d'accessibilité du logo annonce « Flirt Coach Pro ».
  - Inchangés aussi : identifiants d'application, nom du paquet Dart `flirt_coach`, noms
    internes des projets Supabase et RevenueCat, noms de fichiers.
- **Alternatives écartées** : nouveau nom sur le store seulement ; mot-symbole retouché pour y
  ajouter « Pro » (exclu : le logo ne doit pas changer).
- **Conséquences** : certains lanceurs peuvent raccourcir le nom sous l'icône (15 caractères).
  Les consignes du coach au nouveau nom ne seront en ligne qu'au prochain déploiement de
  `generate`, `respect-check` et `conversation-analysis`.
- **Impact** : métier (marque) — moyen ; technique — faible.

---

## ADR-028 — Publication Android d'abord ; nom et identifiants conservés

- **Date** : 2026-11-19
- **Statut** : Accepté
- **Décideur** : utilisateur
- **Contexte** : préparation de la publication (phase 6). L'utilisateur a déjà un compte Google
  Play Console, utilisé pour d'autres applications, mais pas de compte Apple Developer. Il compile
  les versions des stores sur une autre machine.
- **Décision** :
  - Nom « Flirt Coach » et identifiants conservés : Android `com.flirtcoach.flirt_coach`, iOS
    `com.flirtcoach.flirtCoach`.
  - Google Play d'abord. Le compte Apple Developer et toute la partie iOS (produits App Store,
    apps iOS dans RevenueCat et AdMob, compilation iOS) viennent après la mise en ligne Android.
  - Préparation guidée une étape à la fois, suivie dans `docs/manual-tasks.md`.
- **Alternatives écartées** : identifiant bâti sur un nom de domaine possédé, sans « _ » ;
  lancement simultané sur Android et iOS.
- **Conséquences** : l'identifiant Android devient définitif à la création de l'app dans la Play
  Console. Les identifiants diffèrent entre Android et iOS, sans effet : RevenueCat et AdMob
  traitent chaque plateforme séparément. Les 99 $/an d'Apple sont reportés.
- **Impact** : métier (calendrier de lancement) — moyen ; technique — aucun.

---

## ADR-027 — Abonnement restauré sur une nouvelle installation (événement TRANSFER)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôles : backend, achats)
- **Contexte** : point S12 de la revue de phase 5. Une réinstallation ou un nouveau téléphone
  crée un nouveau compte anonyme ; « Restaurer mes achats » y rattache l'abonnement chez
  RevenueCat, qui envoie un événement `TRANSFER` (anciens identifiants → nouveaux). Le webhook
  l'ignorait : l'abonné perdait Premium.
- **Décision** :
  - Le webhook traite `TRANSFER` : il garde les identifiants Supabase (UUID) des listes
    `transferred_from` et `transferred_to` (l'événement ne porte ni utilisateur ni produit).
  - Nouvelle fonction SQL `transfer_premium(anciens, nouveaux)`, réservée au serveur : en une
    transaction, elle reporte le droit Premium actif le plus récent des anciens comptes sur les
    nouveaux (via `set_premium`, sans écraser un droit plus récent) et le retire aux anciens.
    Réponses du webhook : `premium_transferred` ou `nothing_to_transfer` ; rejouer l'événement
    est sans effet.
  - App : `restore()` indique si le store voit un abonnement Premium actif
    (`activeSubscriptions`). Si oui, l'app attend la confirmation du serveur comme après un
    achat ; sinon elle répond tout de suite « Aucun abonnement actif ». Nouveau message si le
    serveur tarde : « Abonnement retrouvé : Premium s'active dans quelques instants. »
- **Alternatives écartées** : interroger l'API REST RevenueCat à chaque `TRANSFER` (dépend de la
  clé secrète et d'un appel réseau de plus) ; procédure manuelle permanente (non viable).
- **Conséquences** : les crédits achetés et l'historique ne suivent toujours pas (inchangé). Si
  l'ancien compte n'avait aucun droit connu (webhook manqué, compte supprimé), la réponse est
  `nothing_to_transfer` et la procédure manuelle de `docs/operations.md` s'applique. Prérequis
  RevenueCat : « Restore behavior » = « Transfer to new App User ID » (tâche manuelle 7). Migration
  `20261118090000_premium_transfer` et webhook déployés sur le cloud le 2026-11-18.
- **Impact** : métier (conservation des abonnés) — fort ; sécurité — neutre (fonction réservée au
  serveur, 11 tests pgTAP, 1 test Deno, essai de bout en bout en local).

---

## ADR-026 — Organisation de la documentation

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : documentation)
- **Contexte** : Phase 7 ; l'utilisateur exige une documentation professionnelle, **dans le
  README**, avec l'identité de la marque. Il a explicitement écarté un site de documentation.
- **Décision** :
  - Le **`README.md` est la documentation principale** : bannière au logo, badges, sommaire,
    présentation, fonctionnalités, captures, modèle économique, schéma d'architecture, stack,
    démarrage, configuration, tests, compilation, structure, sécurité, limites connues.
  - Visuels du README dans `docs/assets/readme/` : bannière PNG générée depuis les logos et les
    polices du kit, schéma d'architecture en SVG (lisible partout, sans dépendre de Mermaid).
  - Les **annexes détaillées** restent dans `docs/` (une rubrique par document : architecture,
    flux, données, API, configuration, exploitation, tâches manuelles, guide utilisateur, FAQ et
    support, fiche store, charte éditoriale) et sont reliées depuis le README.
  - **Aide intégrée à l'app** (Réglages → « Aide et questions fréquentes », texte
    `assets/help/faq_fr.txt`), lisible hors connexion.
  - `CHANGELOG.md` au format Keep a Changelog + SemVer.
  - Contenu écrit **à partir du code** et relu par un agent indépendant (23 écarts corrigés) ;
    liens, ancres et images vérifiés par script.
- **Alternatives écartées** : site de documentation (MkDocs) — refusé par l'utilisateur ;
  diagrammes Mermaid dans le README — non affichés par tous les lecteurs Markdown.
- **Conséquences** : toute évolution met à jour le README ou l'annexe concernée dans le même
  changement. Corrigés au passage dans l'app : l'aide et l'écran Premium laissaient croire que la
  capture d'écran était réservée à Premium ; l'aide promettait une restauration de l'abonnement
  après changement de téléphone, impossible tant que l'événement RevenueCat `TRANSFER` n'est pas
  traité (procédure manuelle documentée, correctif à faire avant publication).
- **Impact** : métier (support, stores) — faible.

---

## ADR-025 — Corrections de la phase 5 (qualité, sécurité, performance)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décisions** :
  - **Quotas IA** : table `ai_usage` ; chaque tentative est comptée sous le verrou du
    portefeuille, avant l'appel : 10 par minute et 100 par jour pour tout utilisateur (refus et
    remboursements compris). Le plafond Premium ne dépend plus des lignes de `generations`.
  - **RevenueCat** : achats sandbox ignorés sauf `REVENUECAT_ALLOW_SANDBOX=true` ; pack remboursé
    → crédits restants repris (au plus le montant du pack). **Remplace ADR-017** sur ce point
    (« crédits non repris ») : la revue a montré qu'un achat-utilisation-remboursement était gratuit.
  - **AdMob** : seuls nos blocs d'annonces (`ADMOB_AD_UNIT_IDS`) créditent ; rechargement des
    clés Google limité à une fois par minute.
  - **Signalements** : le texte doit venir de la génération ; 20 par jour.
  - **App** : actions des contrôleurs factorisées (`GuardedAction`, garde anti double tap) ;
    portefeuille relu au retour dans l'app et après création d'une session ; délais maximaux
    (20 s, 70 s pour l'IA) ; lecture tolérante des réponses serveur ; consentement pub
    seulement pour les gratuits ; libellés de boutons en gras (contraste WCAG sans changer les
    couleurs du kit) ; écran de lancement Android au fond du kit.
- **Reportés** : protection anti-comptes en série (décision du propriétaire, tâche 17) ;
  événements RevenueCat `TRANSFER` / tardifs (phase 6, avec la clé secrète RevenueCat).
- **Conséquences** : 4 migrations (`20261118080000` à `080200`), webhooks et fonctions IA à
  redéployer ; 2 nouveaux secrets serveur (tâches 15, 16).

---

## ADR-024 — Confiance, réglages et suppression de compte (Inc-10)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décisions** :
  - **Signalement** : RPC `report_generation` (security definer) — l'utilisateur ne signale que ses
    propres générations, même gratuit (la lecture de `generations` est réservée à Premium). Texte
    signalé copié (examinable même si l'entrée est effacée), supprimé avec le compte. Bouton sur
    les cartes de Résultats.
  - **Suppression de compte** : Edge Function `delete-account` → `auth.admin.deleteUser` (cascade
    sur toutes les tables) ; client RevenueCat effacé si `REVENUECAT_SECRET_API_KEY` est défini.
    L'abonnement store se résilie dans le store (dit à l'utilisateur avant confirmation). Les
    rappels RevenueCat/AdMob visant un compte supprimé répondent 200 (`unknown_user`).
  - **Textes légaux** embarqués (`assets/legal/*.txt`), lisibles hors connexion et avant la
    confirmation d'âge ; éditeur et contact injectés depuis `config/*.json`.
  - **Préférences publicitaires** : formulaire UMP rouvert depuis les réglages, lien affiché
    seulement si le consentement s'applique.
  - Dépendance ajoutée : `url_launcher` (page d'abonnement du store, e-mail au support).
- **Reporté** : rattacher un e-mail (US-04) — nécessite un service d'envoi d'e-mails (SMTP)
  configuré sur Supabase ; le SMTP par défaut n'envoie qu'aux membres de l'équipe.
- **Alternatives écartées** : textes légaux uniquement en ligne (illisibles hors connexion,
  dépendance à un hébergement non encore créé) ; suppression « douce » du compte (contraire au
  droit à l'effacement).

---

## ADR-023 — Historique Premium et suppression (Inc-9)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : l'historique lit `generations` sous RLS (Premium uniquement, déjà en place).
  « Supprimer » appelle `delete_generation`, qui efface le message saisi, le contexte et les
  réponses et marque la ligne (`deleted_at`) ; la règle de suppression directe est retirée.
  Pagination par date (20 entrées), sans compteur total.
- **Pourquoi** : le plafond Premium (100 générations/jour) compte les lignes du jour ; une vraie
  suppression permettait de le contourner. Le contenu, seule donnée personnelle, disparaît bien.
- **Alternatives écartées** : compteur d'usage séparé (plus de code, remboursements à gérer) ;
  garder la suppression directe (faille de facturation).
- **Conséquences** : la suppression du compte (Inc-10) supprime tout par cascade.

---

## ADR-022 — Banque de messages (Inc-8)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : contenu en base (`message_bank`, migration) plutôt qu'embarqué dans l'app :
  modifiable sans nouvelle version. Lecture seule pour tout utilisateur connecté, sans crédit
  (H5). L'app garde la dernière copie dans SharedPreferences (contenu public, non sensible) et
  la sert si le réseau manque ou ne répond pas en 6 s. 8 messages par catégorie, en français,
  respectueux (aucune pression ni manipulation).
- **Reporté** : « personnaliser avec l'IA » (H5) — l'écran Générer couvre déjà ce besoin
  (situations ouverture, relance, rendez-vous, excuses, rupture douce).
- **Alternatives écartées** : fichier JSON embarqué (mise à jour = nouvelle version des stores) ;
  base locale SQLite (dépendance de plus pour 40 lignes).

---

## ADR-021 — Analyse de conversation (Inc-7)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : nouvelle Edge Function `conversation-analysis` sur le socle `serveAiEndpoint`
  (Premium uniquement, aucun crédit, compte dans le plafond de 100/jour). Entrée : texte collé
  **ou** capture (validation d'image partagée avec `screenshot-reply` via `parseImage`).
  Sortie : dynamique (progresse / stagne / recule), constat et prochaine étape en français,
  message et éventuel rendez-vous dans la langue de la conversation. Le serveur retire toute
  proposition de rendez-vous si la conversation recule (consentement, INTAKE §7).
- **Limite** : conversation ≤ 4000 caractères, alignée sur `generations.input_text` (pas de migration).
- **Alternatives écartées** : ouvrir l'analyse aux gratuits contre crédits (contraire à l'INTAKE
  §2.4) ; migration pour allonger `input_text` (inutile pour un échange collé).
- **Conséquences** : 1 Edge Function de plus à déployer (tâche manuelle de déploiement inchangée).

---

## ADR-020 — Refonte UI conforme au kit de marque, nouveau logo

- **Date** : 2026-11-18
- **Statut** : Accepté (demande de l'utilisateur : « les icônes et fenêtres ne respectent pas le kit »)
- **Décision** : icônes au trait **Lucide** (`lucide_icons_flutter`, centralisées dans `AppIcons`) ;
  logo tiré du nouveau fichier `Logo Flirt Coach con Cuore Brillante.png` → `logo_symbol.png`
  (bulle + étincelles), `logo_wordmark_dark.png`, `logo_horizontal_dark.png` ; icône d'app
  (adaptive Android + iOS) générée par `flutter_launcher_icons`. Écrans refaits selon le kit :
  accueil (logo, wordmark, vague, coches roses), Générer (menu grille, badge crédits doré,
  champs clairs, styles en grille 2 colonnes), menu en feuille du bas, Résultats (cartes
  « Réponse n » avec émoji et copier), Mode Respect, Premium.
- **Correctif lié** : `keepAliveWhile` garde un contrôleur `autoDispose` vivant pendant une
  opération en cours (erreur « Future already completed » vue sur la vidéo récompensée).
- **Alternatives écartées** : Material Icons (style plein, différent du kit) ; SVG redessinés
  à la main (long, risque d'écart avec le logo fourni).
- **Conséquences** : 1 dépendance d'icônes ; le logo d'origine reste dans `assets/images`
  (non embarqué). Vérifié sur émulateur, écran par écran.

---

## ADR-019 — Langue des réponses et transitions

- **Date** : 2026-11-18
- **Statut** : Accepté (demandes de l'utilisateur)
- **Décision** :
  - Les messages proposés sont écrits dans la langue de la conversation (message reçu ou
    texte visible sur la capture), à défaut celle du contexte saisi, en dernier recours en
    français ; consigne explicite que la langue des consignes (français) ne compte pas.
    Les textes destinés à l'utilisateur de l'app (raison d'un refus, explications du mode
    Respect) restent en français, langue de l'interface.
  - Transitions : `FadeForwardsPageTransitionsBuilder` (fondu + glissement Material 3) sur
    Android, sur le fond de la marque ; glissement natif sur iOS.
  - Tests sur téléphone : APK en mode profile (compilé, fluide), le mode debug étant saccadé.
- **Constat lié** : la permission Internet manquait dans le manifeste Android principal
  (présente seulement en debug/profile) : une version publiée n'aurait eu aucun accès réseau.
  Corrigé.
- **Impact** : produit / qualité.

## ADR-018 — Publicités : consentement d'abord, crédits par rappel signé uniquement

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : mobile / backend / security)
- **Contexte** : INTAKE §3.3 (bannière discrète, vidéo +2 crédits, jamais pour Premium, pas de
  plein écran au lancement) ; ADR-008 ; RGPD (UE) et ATT (iOS).
- **Décision** :
  - SDK `google_mobile_ads` 9.2.0. Consentement Google (UMP) demandé avant la toute première
    annonce ; sans consentement exploitable, aucune annonce n'est chargée. iOS : texte de
    suivi (`NSUserTrackingUsageDescription`), demande ATT via le message UMP configuré dans
    AdMob.
  - Bannière adaptative ancrée en bas des écrans Générer et Mode Respect, gratuits seulement.
    Aucune annonce plein écran, aucune au lancement.
  - Vidéo récompensée proposée seulement quand les crédits manquent et qu'il reste des vidéos
    (5/jour). L'identifiant Supabase est transmis à AdMob ; les 2 crédits ne sont accordés
    que par l'Edge Function `admob-ssv`, après vérification de la signature ECDSA de Google
    (clés publiques de Google, en cache 6 h) ; idempotent par `transaction_id`.
  - Portefeuille : une seule fonction SQL `wallet_of` (crédits, Premium, vidéos restantes)
    pour l'app et toutes les Edge Functions.
  - Développement : identifiants d'app et blocs d'annonces **de test publics de Google**.
- **Conséquences** : le rappel AdMob exige une URL publique (Supabase cloud) : en local, la
  vidéo se joue mais les crédits restent « en attente ». Identifiants AdMob réels à fournir
  (tâche manuelle 8) ; lien « préférences publicitaires » à ajouter dans les réglages (Inc-10).
- **Impact** : légal (RGPD, ATT) / financier / sécurité.

## ADR-017 — Achats : le store prévient le serveur, l'app n'accorde jamais de droit

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : backend / security / mobile)
- **Contexte** : INTAKE §3 (abonnements hebdo/mensuel/annuel, packs 20/50/100) ; ADR-004
  (RevenueCat) ; risque R3 (fraude).
- **Décision** :
  - Produits : `flirtcoach_premium_weekly|monthly|annual` (même droit « Premium »),
    `flirtcoach_credits_20|50|100` (consommables). Le nombre de crédits est fixé par le
    serveur. Prix et période d'essai/remise configurés dans les stores, affichés tels quels.
  - App : SDK `purchases_flutter` 11.0.2, identifiant RevenueCat = identifiant Supabase.
    Après un achat, l'app relit le portefeuille (6 essais, 1 s) et annonce honnêtement
    « tes avantages arrivent » si le serveur n'a pas encore reçu l'événement.
  - Serveur : Edge Function `revenuecat-webhook` (sans JWT, secret partagé en
    `Authorization: Bearer …`, comparaison à temps constant). Crédits idempotents
    (`grant_credits`, référence = transaction store, index unique). Premium : un événement
    plus ancien n'écrase pas un plus récent ; résiliation = actif jusqu'à l'échéance ;
    remboursement = retrait immédiat. Remboursement d'un pack : journalisé, non repris
    (les crédits peuvent avoir été dépensés).
  - Offre J+3 : date de première utilisation stockée sur le téléphone, paywall « annuel mis
    en avant » montré une seule fois aux non-abonnés (H8).
- **Conséquences** : comptes Google Play, Apple et RevenueCat requis pour tester un vrai achat
  (tâches manuelles 4 à 7). Sans clé RevenueCat, le paywall affiche « achats indisponibles ».
- **Impact** : financier / sécurité.

## ADR-016 — Capture d'écran : lue par Claude, jamais stockée

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : backend / security)
- **Contexte** : INTAKE §2.2 (capture → 3 réponses, 2 crédits ou Premium) et §7.3 (pas de
  conservation au-delà du nécessaire) ; la capture contient les messages d'un tiers.
- **Décision** : sélecteur de photos du système (`image_picker`, aucune permission permanente
  sur la galerie) ; image réduite sur le téléphone (1280 px de large, JPEG 85 %) ; envoyée en
  base64 à l'Edge Function `screenshot-reply`, qui vérifie le vrai type dans les octets
  (PNG/JPEG/WebP/GIF), limite à 3,5 Mo, la transmet à Claude puis l'oublie. Seules les
  3 réponses sont enregistrées (`input_text` nul). Capture illisible → 422, crédits rendus.
- **Conséquences** : la capture transite par l'API Anthropic (sous-traitant à déclarer dans la
  politique de confidentialité, Inc-10). Pas de « rouvrir la capture » depuis l'historique.
- **Impact** : légal / sécurité.

## ADR-015 — Outils de l'incrément 1

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `freezed` pour les modèles du domaine (fichiers générés versionnés, régénérés
  en CI). Edge Function en Deno avec dépendances épinglées dans
  `supabase/functions/generate/deno.json` : SDK Anthropic **1.9.0** (la 1.10.0, publiée la
  veille, est bloquée par la règle Deno d'âge minimal des dépendances — règle conservée),
  `supabase-js` 2.119.0. Tests et vérifications Deno lancés via l'image Docker
  `denoland/deno:2.9.8` : pas d'installation de Deno sur le poste.
- **Impact** : technique (réversible).

## ADR-014 — Modèle IA de génération : Claude Opus 5.5, effort bas

- **Date** : 2026-11-18
- **Statut** : Accepté (coût à confirmer par l'utilisateur, voir PROJECT_STATE Q9)
- **Contexte** : génération de 3 messages courts, attendue en quelques secondes, à fort volume.
- **Décision** : `claude-opus-5-5`, `output_config.effort: "low"` (tâche courte, sensible à la
  latence), sortie JSON contrainte par schéma (`output_config.format`), repli serveur activé en
  cas de refus des garde-fous (`fallbacks: "default"`, bêta `server-side-fallback-2026-07-01`).
  Délai 25 s, 1 nouvelle tentative SDK. Le texte utilisateur est délimité et traité comme une
  donnée ; aucun contenu utilisateur dans les journaux.
- **Coût estimé** (tarif 4 $ / 20 $ par million de jetons entrée/sortie) : ~600 jetons en
  entrée et ~500 en sortie (réflexion comprise) ≈ **0,01 $ par génération**, à mesurer sur
  trafic réel. Gratuit à 5/jour ≈ 0,05 $/jour/utilisateur actif ; Premium plafonné à 100/jour.
- **Alternatives** : Claude Haiku 5.5 (0,10 $ / 0,50 $, environ 40 fois moins cher, qualité
  d'écriture inférieure) — choix financier laissé à l'utilisateur ; le modèle est une constante
  dans `supabase/functions/generate/index.ts`.
- **Impact** : financier (réversible en une ligne).

## ADR-013 — Dépendances du socle

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `flutter_riverpod` 2.6 (version résolue par le SDK installé ; pas de
  génération de code tant que les providers restent simples), `go_router`, `supabase_flutter`,
  `flutter_secure_storage` (session dans Keychain/Keystore, remplace le stockage par défaut en
  préférences), `shared_preferences` (drapeau local de confirmation d'âge, non sensible),
  `flutter_localizations` + `intl`. `freezed` sera ajouté avec le premier modèle (Inc-1).
- **Alternatives écartées** : `google_fonts` (télécharge les polices à l'exécution) → polices
  Poppins et Inter embarquées (licence OFL, fichiers de licence joints dans `assets/fonts/`).
- **Impact** : technique (réversible).

## ADR-012 — Thème sombre unique

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : le gabarit du rôle UI/UX prévoit clair + sombre ; le kit de marque ne définit
  qu'une identité néon sur fond sombre.
- **Décision** : un seul thème (sombre) en V1.
- **Conséquences** : un thème clair demanderait une déclinaison du kit.
- **Impact** : design (réversible).

## ADR-011 — Environnements par fichier de configuration, sans flavors natifs

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `--dart-define-from-file=config/dev.json` (Supabase local) ou
  `config/prod.json` (cloud). Pas de flavors Android/iOS tant qu'un seul identifiant
  d'application suffit.
- **Alternatives écartées** : flavors dev/staging/prod (configuration native lourde, sans
  besoin actuel).
- **Impact** : technique (réversible).

## ADR-010 — Identité visuelle : kit de marque néon

- **Date** : 2026-11-18
- **Statut** : Accepté (demande utilisateur)
- **Contexte** : `Kit di brand Flirt Coach in stile neon.png` (racine du projet) fait foi pour
  toute l'interface.
- **Décision** : nom **Flirt Coach**, sous-titre « Coach de drague et messages ». Couleurs :
  primaire `#FF4D79` (actions/CTA), secondaire `#9B5CFF` (accents, icônes), fond principal
  `#1A1033`, fond clair `#FFD6E6` (cartes, sections), surface `#F8F8FC`. Typos : **Poppins**
  Bold/SemiBold (titres, boutons), **Inter** Regular/Medium (textes). Thème sombre néon avec
  dégradé rose→violet, boutons pilule, logo bulle + cœur. Les 3 écrans du kit (accueil,
  « Générer un message », « Résultats ») servent de maquettes de référence.
- **Conséquences** : tokens centralisés dans le thème Flutter ; polices embarquées dans l'app
  (pas de téléchargement à l'exécution). Le kit est une image : logo et icône devront être
  fournis en fichiers sources (SVG/PNG haute définition) ou redessinés.
- **Écarts kit ↔ INTAKE à trancher** : le kit montre « Coach de profil » (voir ADR-007) et le
  style « Drôle » déverrouillé alors que l'INTAKE §2.3 le classe en avancé/Premium.
- **Impact** : design (réversible).

## ADR-009 — Base de données de développement : Supabase local sous Docker

- **Date** : 2026-11-18
- **Statut** : Accepté (demande utilisateur)
- **Contexte** : tout le développement doit s'appuyer sur une base tournant dans Docker.
- **Décision** : pile Supabase locale (`supabase start` : Postgres, Auth, Storage, Edge
  Functions dans des conteneurs Docker). Schéma, RLS et données de test versionnés dans
  `supabase/migrations` et `supabase/seed.sql`. Aucun projet Supabase cloud avant la phase de
  publication ; les mêmes migrations y seront alors appliquées.
- **Alternatives écartées** : projet cloud dès le début (contraire à la demande) ; Postgres nu
  dans Docker (perd Auth, RLS liée à l'auth et Edge Functions, donc s'écarte de la production).
- **Conséquences** : Docker Desktop doit être installé et démarré (absent du poste au
  2026-11-18). L'émulateur Android joint la base via `10.0.2.2`.
- **Impact** : technique (réversible).

## ADR-008 — Publicité : AdMob, récompense validée côté serveur

- **Date** : 2026-11-18
- **Statut** : Accepté — mis en œuvre en Inc-6 (voir ADR-018)
- **Décideur** : Claude (rôle : project-director)
- **Contexte** : INTAKE §3.3 — bannière discrète + vidéo récompensée (+2 crédits), jamais pour
  les Premium, catégories « adulte » et « rencontre » exclues.
- **Décision** : `google_mobile_ads` (AdMob). Crédits de récompense accordés uniquement par le
  rappel serveur (SSV) vers une Edge Function, plafonnés à 5 vidéos/jour. Consentement RGPD
  (UMP) et ATT iOS avant toute pub. Catégories sensibles bloquées dans la console AdMob.
- **Alternatives écartées** : créditer côté client (fraude triviale) ; autres régies (moins de
  remplissage, intégration Flutter moins mûre).
- **Conséquences** : compte AdMob à créer (tâche manuelle) ; le plafond 5/jour est une hypothèse.
- **Impact** : technique + métier faible (réversible).

## ADR-007 — « Coach de profil » hors périmètre V1

- **Date** : 2026-11-18
- **Statut** : Accepté (à confirmer par l'utilisateur)
- **Contexte** : cité aux §3.1 et §5 de l'INTAKE, mais ni décrit au §2 ni listé au §9, qui
  précise que la V1 comprend « exclusivement » les fonctionnalités énumérées.
- **Décision** : ne pas le livrer en V1 et ne pas l'afficher dans le paywall.
- **Alternatives écartées** : l'inventer sans spécification (exigence non décrite).
- **Conséquences** : à spécifier pour une V1.1 si souhaité.
- **Remise en question** : le kit de marque l'affiche (icône « Coach de profil », « Améliore
  ton profil » sur l'accueil). Question Q7 posée à l'utilisateur.
- **Impact** : fonctionnel (réversible).

## ADR-006 — Captures d'écran jamais stockées

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : INTAKE §7.3 ; les captures contiennent les données d'un tiers non consentant.
- **Décision** : l'image est envoyée à l'Edge Function, transmise à l'IA, puis jetée. Aucun
  dépôt dans Supabase Storage, aucun log du contenu. L'historique ne conserve que les réponses
  générées.
- **Alternatives écartées** : stockage temporaire avec purge (surface de risque inutile).
- **Conséquences** : impossible de « ré-ouvrir » une capture depuis l'historique.
- **Impact** : légal / sécurité.

## ADR-005 — Crédits : ledger serveur, 1 crédit = 1 génération

- **Date** : 2026-11-18
- **Statut** : Accepté (hypothèse H1 à confirmer)
- **Contexte** : INTAKE contradictoire (« 3 à 5 générations/jour » vs « 5 crédits/jour » ;
  « 1 crédit = 1 message » alors qu'une génération renvoie 3 propositions).
- **Décision** : 1 crédit = 1 génération (3 propositions) ; capture = 2 crédits. Gratuit :
  solde quotidien remis à 5, non cumulable. Crédits achetés ou récompensés : sans expiration,
  consommés après les crédits du jour. Tout mouvement passe par une Edge Function / fonction
  SQL `security definer` ; le client n'a qu'un accès lecture (RLS).
- **Alternatives écartées** : compteur côté client (falsifiable) ; 1 crédit par proposition
  (3 crédits pour une réponse : gratuit inutilisable).
- **Conséquences** : pas de génération hors-ligne ; solde toujours fiable.
- **Impact** : métier + sécurité.

## ADR-004 — Achats intégrés : RevenueCat

- **Date** : 2026-11-18
- **Statut** : Accepté (option par défaut validée par l'utilisateur le 2026-11-18)
- **Contexte** : 3 abonnements + 3 consommables sur deux stores, avec validation serveur,
  renouvellements, remboursements, offre promotionnelle annuelle.
- **Décision proposée** : `purchases_flutter` (RevenueCat) + webhook vers une Edge Function qui
  met à jour `entitlements` et `credit_ledger`.
- **Alternatives écartées** : `in_app_purchase` + validation maison des reçus Apple/Google
  (plusieurs semaines de travail, source classique de bugs de facturation).
- **Conséquences** : dépendance à un tiers ; gratuit sous un seuil de revenus puis commission
  (barème à vérifier sur leur site au moment de la création du compte).
- **Impact** : financier (réversible avec effort).

## ADR-003 — IA appelée uniquement depuis une Edge Function

- **Date** : 2026-11-18
- **Statut** : Accepté (fournisseur par défaut validé par l'utilisateur le 2026-11-18)
- **Contexte** : aucun secret dans le binaire ; modération et quotas doivent être inviolables.
- **Décision** : l'app n'appelle jamais l'IA directement. Une Edge Function authentifie,
  vérifie le quota, débite, construit le prompt (règles éthiques §1.4 et §7.2), appelle le
  modèle, valide la sortie structurée, enregistre l'historique. Fournisseur proposé : API
  Claude (texte + vision), modèle rapide choisi en phase 3.
- **Alternatives écartées** : appel direct depuis l'app (clé exposée, quotas contournables).
- **Conséquences** : coût à l'usage ; fournisseur interchangeable derrière la fonction.
- **Impact** : sécurité + financier.

## ADR-002 — Authentification anonyme, rattachement e-mail optionnel

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : le parcours §4 démarre directement sur « Colle son dernier message » ; mais
  crédits, Premium et historique exigent une identité serveur.
- **Décision** : session anonyme Supabase au premier lancement ; rattachement d'un e-mail
  proposé (non imposé) pour retrouver son compte sur un autre appareil. Jetons en stockage
  sécurisé. Suppression de compte in-app.
- **Alternatives écartées** : inscription obligatoire (friction avant la première valeur) ;
  connexions sociales (imposent « Sign in with Apple », non demandé).
- **Conséquences** : un utilisateur gratuit qui désinstalle sans e-mail perd ses crédits
  achetés ; les abonnements restent restaurables via le store.
- **Impact** : métier faible, technique.

## ADR-001 — Gestion d'état : Riverpod

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : mobile-architect / state-management-engineer)
- **Contexte** : Besoin d'une gestion d'état Flutter testable, sûre et scalable.
- **Décision** : Utiliser **Riverpod** (stack imposée par CLAUDE.md).
- **Alternatives écartées** : Bloc (plus verbeux), Provider seul, setState, GetX.
- **Conséquences** : État découplé de `BuildContext`, providers testables.
- **Impact** : technique (réversible avec effort).

---

## ADR-000 — Modèle d'enregistrement

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : Établit le format des décisions. À copier pour chaque nouvelle entrée.
- **Décision** : Utiliser ce gabarit pour toute décision ayant un impact sur l'architecture,
  les dépendances, la sécurité, le coût ou le comportement produit.
- **Conséquences** : Traçabilité complète ; l'utilisateur peut revenir sur tout choix.

---

<!-- Copier ce bloc pour chaque nouvelle décision :

## ADR-NNN — <titre court>

- **Date** :
- **Statut** : Proposé / Accepté / Remplacé par ADR-XXX
- **Décideur** : Claude (rôle : <ex. mobile-architect>)
- **Contexte** :
- **Décision** :
- **Alternatives écartées** :
- **Conséquences** :
- **Impact** : technique / financier / métier / sécurité (et niveau)

-->
