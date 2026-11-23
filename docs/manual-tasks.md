# Tâches manuelles

Ce que personne ne peut faire à ta place : créer des comptes, payer, signer, accepter des
contrats, fournir des informations légales. Chaque tâche indique **pourquoi**, **quand**, les
**étapes** (cochées une fois faites), le **coût** et comment **vérifier**.

> Les tarifs indiqués sont indicatifs (état connu fin 2026) : vérifie-les sur le site officiel
> avant de t'engager.

## Où on en est

- **Ordre décidé le 2026-11-19** : Android d'abord ; iOS (tâche 5) après la mise en ligne sur
  Google Play.
- **Guidage pas à pas** : une étape à la fois ; chaque étape terminée est cochée ici.
- **Étape 1 faite** (2026-11-19) : app « Flirt Coach Pro » créée dans la Play Console ; profil de
  paiement actif.
- **Étape 2 faite** : inscription au taux de commission de 15 %, confirmée par la Play Console
  (groupe de comptes « Kelenix Tech »).
- **Étape 3 faite** (2026-11-19) : projet RevenueCat « Flirt Coach » avec son app Google Play ;
  clé publique dans `config/prod.json`.
- **Étape 4 faite** : compte de service créé, invité dans la Play Console, clé enregistrée dans
  RevenueCat (validation complète après l'envoi de la première version).
- **Étape 5 faite** : notifications Google en temps réel reliées entre la Play Console et
  RevenueCat ; notification de test reçue.
- **Étape 6 faite** : webhook RevenueCat → serveur en place ; événement de test accepté (200).
- **Étape 7 faite** (AdMob, lionelkelenix@gmail.com) : app « Flirt Coach Pro », blocs bannière
  et récompensée (vérification côté serveur validée), blocages, identifiants reportés, liste des
  blocs autorisés sur le serveur. Compte AdMob en cours de validation (jusqu'à 24 h). Restent :
  message de consentement RGPD et association au Play Store après la mise en ligne (tâche 8).
- **Étape 8 faite** : politique de confidentialité et conditions en ligne sur GitHub Pages ;
  relecture par un juriste toujours conseillée (tâche 10).
- **Étape 9 faite** : message de consentement RGPD publié dans AdMob (tâche 8).
- **Étape 10 faite** : visuels Google Play prêts dans `docs/store/visuels/` (icône 512 × 512,
  bannière 1024 × 500, 7 captures 1080 × 1920 avec accroche, accueil en premier).
- **Étape 11 faite** (Play Console, avec ton accord) :
  - Fiche « Flirt Coach Pro » (textes, visuels, étiquette IA).
  - Catégorie et coordonnées.
  - Toutes les déclarations du contenu : confidentialité, annonces, détails d'accès,
    classification, public cible 18+, sécurité des données, identifiant publicitaire,
    gouvernement, finances, santé.
  - La configuration de l'app est terminée et le test fermé est débloqué. Rien n'est envoyé
    en revue : tout partira avec la première version.
- **Étape 12 faite** : code d'accès Premium (Réglages → « J'ai un code »), déployé sur le
  cloud, secret posé ; le code est en commentaire dans `supabase/functions/.env.cloud`.
- **Test fermé obligatoire** pour ce compte (tâche 19) : c'est l'étape la plus longue
  (14 jours) ; les étapes sont ordonnées pour le lancer au plus tôt.
- La compilation des versions envoyées aux stores se fait sur une autre machine : équipée, et
  première version (AAB) compilée le 2026-11-20.
- **Première version déposée** (2026-11-20) : AAB 1.0.0 (1) en brouillon dans « Test chiusi -
  Alpha », pas encore envoyé en revue. Signature Google Play active.
- **Produits créés** (2026-11-20, tâche 6) : 3 abonnements et 3 packs actifs, aux prix décidés
  payés en France (ADR-033).
- **RevenueCat configuré** (2026-11-20, tâche 7) : 6 produits importés, droit `premium`, offre
  `main` par défaut. « Check again » à refaire après la publication du test fermé.
- **Liste de testeurs** « Flirt Coach Pro » créée et associée au test fermé (2026-11-20), avec
  une première adresse ; les autres seront ajoutées plus tard.
- **Envoyé en revue** (2026-11-20) : le test fermé sera publié dès l'approbation de Google.
  Ensuite : « Check again » dans RevenueCat, testeurs, test des achats, 14 jours.

## Récapitulatif

| # | Tâche | Bloquant pour | État |
|---|-------|---------------|------|
| 0 | Docker Desktop, émulateur Android, logo source | développement | ✅ Fait |
| 1 | Projet Supabase cloud | tests sur téléphone, publication | ✅ Fait (reste : plan avec sauvegardes) |
| 2 | Clé API Anthropic | toute génération | ✅ Fait, en local et sur le cloud |
| 3 | Nom et identifiants de l'app | publication | ✅ Décidé : « Flirt Coach Pro », identifiants inchangés |
| 4 | Compte Google Play Console | achats réels Android, publication | App « Flirt Coach Pro » créée et configurée, paiement et taux de 15 % actifs ; reste la déclaration de commerçant (avant février 2027) |
| 5 | Compte Apple Developer | iOS | Après la mise en ligne Android |
| 6 | Produits d'achat dans les stores | achats réels | ✅ Google Play : 6 produits actifs (2026-11-20) ; App Store avec la tâche 5 |
| 7 | RevenueCat (et 7b : prix de lancement de l'annuel) | achats réels | Projet, app, clé, notifications, webhook, produits, droit `premium` et offre `main` en place (2026-11-20) ; restent « Check again » après la publication et la décision 7b |
| 8 | AdMob | publicités réelles | App, blocs, blocages et consentement RGPD en place ; compte en validation ; Play Store à associer après la mise en ligne |
| 9 | GitHub et CI macOS | compilation iOS | En partie (CI faite ; iOS avec la tâche 5) |
| 10 | Textes légaux relus et hébergés | publication | En ligne (GitHub Pages) ; relecture par un juriste à faire |
| 11 | Clés de signature Android et iOS | publication | Clé d'envoi Android créée sur l'autre machine et signature Google Play active (2026-11-20) ; reste la sauvegarde de la clé ; iOS avec la tâche 5 |
| 12 | Éditeur et e-mail de support | publication | ✅ Fait |
| 13 | Modération des signalements | après publication | Après la publication |
| 14 | Clé secrète RevenueCat | suppression de compte complète | Plus tard, avec la tâche 7 |
| 15 | Blocs AdMob autorisés | sécurité des récompenses | ✅ Fait (Android) |
| 16 | Achats sandbox (phase de test) | tests d'achat | Plus tard, avec la tâche 7 |
| 17 | Protection contre la création de comptes en série | publication | **Décision attendue** |
| 18 | Mesure de fluidité sur ton téléphone | qualité | Plus tard |
| 19 | Test fermé Google Play (12 testeurs, 14 jours) | publication (production) | Envoyé en revue le 2026-11-20 (version 1.0.0 (1), liste « Flirt Coach Pro » avec 1 adresse) ; après l'approbation : 12 testeurs inscrits et 14 jours |
| 20 | Mise en ligne de l'anglais, de l'allemand et de l'espagnol (version 1.1.0) | testeurs et pays anglophones, germanophones, hispanophones | Anglais et allemand : serveur, pages légales et fiches faits (fiche allemande non envoyée). Espagnol : serveur à jour (banque fr/en/de/es), pages légales en ligne, fiches es-419 et es-ES enregistrées non envoyées (2026-11-23) ; reste la décision sur les prix locaux. Puis la 1.1.0, au plus vite |

---

## 0. Environnement de développement

**État : ✅ fait.**

- [x] Docker Desktop installé.
- [x] Émulateur `FlirtCoach_Pixel` créé.
- [x] Logo fourni (`assets/images/Logo Flirt Coach con Cuore Brillante.png`).

## 1. Projet Supabase cloud

- **Pourquoi** : héberge la base, l'authentification et les fonctions serveur en ligne.
- **Quand** : fait ; le plan est à choisir avant la publication.
- **Étapes** :
  - [x] Projet « Flirt Coach » créé ; base, fonctions et secrets déployés.
  - [x] Région UE : `eu-west-1` (Irlande), vérifiée le 2026-11-19 (données personnelles, RGPD).
  - [ ] Tableau de bord Supabase → Organization → Billing : choisir un plan qui inclut des
    sauvegardes quotidiennes.
- **Coût** : plan gratuit pour le développement ; plan payant à prévoir en production (de l'ordre
  de 25 $/mois).
- **Vérification** : Settings → Database → Backups affiche des sauvegardes.

## 2. Clé API Anthropic

**État : ✅ fait.**

- [x] Clé en place en local (`supabase/functions/.env`) et sur le cloud (`ANTHROPIC_API_KEY`).
- **Coût** : à l'usage (par appel). Suivre la consommation dans la console Anthropic et y fixer
  une limite de dépense mensuelle.

## 3. Nom et identifiants définitifs

**État : ✅ décidé le 2026-11-19 — nom « Flirt Coach Pro », identifiants inchangés.**

- [x] Nom affiché : **Flirt Coach Pro**, partout (nom sous l'icône, textes de l'app, mentions
  légales, aide, fiche du store) ; logo inchangé. « Flirt Coach » jusqu'au 2026-11-19.
- [x] Android : `com.flirtcoach.flirt_coach` (`android/app/build.gradle.kts`).
- [x] iOS : `com.flirtcoach.flirtCoach` (`ios/Runner.xcodeproj/project.pbxproj`) ; Apple
  n'accepte pas le caractère « _ ».

L'identifiant Android se saisit à la création de l'app dans la Play Console (étape 1) : il est
ensuite **définitif** (ni modifiable, ni supprimable, ni réutilisable). Sur l'App Store, le nom
doit être unique : à vérifier avec la tâche 5.

## 4. Compte Google Play Console

- **Pourquoi** : publier sur Android et vendre abonnements et packs.
- **Quand** : maintenant (étapes 1 et 2).
- **Étapes** :
  - [x] Compte développeur : existant, déjà utilisé pour d'autres applications.
  - [x] Application « Flirt Coach Pro » créée avec l'identifiant `com.flirtcoach.flirt_coach`
    (2026-11-19).
  - [x] Profil de paiement (marchand) actif, avec un compte bancaire, pour recevoir les ventes.
  - [x] Groupe de comptes « Kelenix Tech » créé (étape 2).
  - [x] Inscription au taux de commission de 15 % (premier million de dollars de revenus
    annuels), confirmée par la Play Console le 2026-11-19. Sans elle, les packs de crédits
    seraient taxés à 25 % au lieu de 15 % dans l'EEE.
  - [x] Nom de l'app dans la console : « Flirt Coach Pro » (fiche du store, 2026-11-19).
  - [ ] Déclarer le statut de commerçant (exigence de l'UE) avant février 2027 : bannière
    « Dichiara il tuo stato di commerciante » de la Play Console.
  - [x] Test fermé obligatoire pour ce compte (déjà fait pour d'autres apps) : voir tâche 19.
- **Coût** : aucun (compte existant).
- **Vérification** : « Flirt Coach Pro » apparaît dans la liste des applications de la console.

## 5. Compte Apple Developer

**État : plus tard — après la mise en ligne Android.**

- **Pourquoi** : publier sur iOS et vendre sur l'App Store.
- **Étapes** :
  - [ ] https://developer.apple.com/programs → adhérer (particulier ou organisation).
  - [ ] App Store Connect → créer l'app avec l'identifiant `com.flirtcoach.flirtCoach`.
  - [ ] Accords, taxes et coordonnées bancaires (« Paid Apps »).
  - [ ] Puis les parties iOS des tâches 6, 7, 8, 9 et 11.
- **Coût** : 99 $/an.
- **Vérification** : l'app apparaît dans App Store Connect.

## 6. Produits d'achat dans les stores

- **Pourquoi** : les prix et les produits sont définis dans chaque store.
- **Quand** : Google Play après la tâche 4 et avant la tâche 7 ; App Store avec la tâche 5.
  Prérequis Google Play : une première version de l'app (elle contient la bibliothèque de
  facturation) doit avoir été envoyée dans la console ; avant cela, la création de produits
  reste bloquée. Débloquée le 2026-11-20 (AAB 1.0.0 (1) déposé).
- **Étapes Google Play** :
  - [x] 3 abonnements distincts (2026-11-20), chacun avec un forfait de base à renouvellement
    automatique : `flirtcoach_premium_weekly` (forfait `weekly`), `flirtcoach_premium_monthly`
    (`monthly`), `flirtcoach_premium_annual` (`annual`). Un seul abonnement à 3 forfaits ne
    serait pas reconnu par l'app. Noms : « Premium hebdomadaire », « Premium mensuel »,
    « Premium annuel » ; 4 avantages repris de l'écran Premium.
  - [x] 3 packs de crédits (produits à paiement unique, option d'achat `buy`) :
    `flirtcoach_credits_20`, `flirtcoach_credits_50`, `flirtcoach_credits_100`. À déclarer
    comme consommables dans RevenueCat (tâche 7).
  - [x] Prix décidés, payés en France : 6,99 € / 12,99 € / 49,99 € et 2,99 € / 5,99 € /
    9,99 €. La console ajoute la TVA au prix saisi : on saisit la base hors taxe, les autres
    pays suivent la conversion automatique (ADR-033).
- **App Store** (avec la tâche 5) : mêmes identifiants et mêmes prix ; les 3 abonnements dans un
  même groupe.
- **Coût** : commission du store sur chaque vente. Google Play (barème 2026) : 15 % sur les
  abonnements ; sur les packs, 15 % avec l'inscription au taux de 15 % (tâche 4), 25 à 30 % sans.
- **Vérification** : les 6 produits sont « actifs » ou « prêts à soumettre ». Google Play :
  actifs, vérifié le 2026-11-20.

## 7. RevenueCat

- **Pourquoi** : relie les achats des stores au serveur, qui accorde les droits.
- **Quand** : après la tâche 6 (Google Play maintenant ; l'App Store avec la tâche 5).
- **Étapes** :
  - [x] Compte sur https://app.revenuecat.com et projet « Flirt Coach » (étape 3).
  - [x] App Google Play dans le projet (package `com.flirtcoach.flirt_coach`) ; sa clé
    **publique** (`goog_…`) est dans `config/prod.json`, champ `REVENUECAT_ANDROID_KEY`
    (étape 3). `REVENUECAT_IOS_KEY` avec la tâche 5.
  - [x] Compte de service `revenuecat@flirt-coach-pro.iam.gserviceaccount.com`, dans le projet
    Google Cloud « Flirt Coach Pro » (compte Gmail perso) : API Google Play Developer, Play
    Developer Reporting et Pub/Sub activées ; rôles Pub/Sub Editor et Monitoring Viewer ;
    clé JSON téléchargée (étape 4).
  - [x] Ce compte invité dans la Play Console, avec des autorisations limitées à l'app
    Flirt Coach : infos de l'app, données financières, commandes et abonnements, présence sur
    le store (étape 4).
  - [x] Clé JSON déposée dans RevenueCat (page de l'app, « Service Account Credentials JSON »),
    jamais dans le projet. Vérification RevenueCat : catalogue des produits et des abonnements
    lisible ; accès aux achats d'abonnement pas encore validé, car Google ne reconnaît le
    package qu'après l'envoi de la première version (attendu). « Check again » du
    2026-11-20 : même résultat (« package name was not found ») tant qu'aucune version n'est
    publiée ; à refaire après la publication du test fermé.
  - [ ] Supprimer le fichier de la clé de Téléchargements (ou le ranger dans un gestionnaire
    de mots de passe).
  - [x] Notifications Google en temps réel : sujet
    `projects/flirt-coach-pro/topics/Play-Store-Notifications` (Google Play y a le rôle
    « Diffuseur Pub/Sub »), relié à RevenueCat ; Play Console : abonnements, achats annulés et
    tous les produits ponctuels ; notification de test reçue par RevenueCat (étape 5).
  - [x] 6 produits Google Play importés (2026-11-20) : abonnements sous la forme
    `flirtcoach_premium_weekly:weekly`, packs déclarés consommables.
  - [x] Droit (*entitlement*) `premium` relié aux 3 abonnements.
  - [x] Offre (*offering*) `main` « Premium et crédits », marquée par défaut (**Current**) :
    l'app affiche cette offre, quel que soit son nom. Paquets `$rc_weekly`, `$rc_monthly`,
    `$rc_annual`, `credits_20`, `credits_50`, `credits_100`.
  - Le droit `flirt_coach_pro` et l'offre `default`, créés automatiquement par RevenueCat pour
    son magasin de test, sont laissés tels quels : l'app ne s'en sert pas.
  - [x] Project settings → *Restore behavior* : **Transfer to new App User ID** (valeur par
    défaut, vérifiée le 2026-11-19). C'est ce qui rattache un abonnement à une nouvelle
    installation.
  - [x] Webhook « Supabase - Flirt Coach Pro » : URL
    `https://<ref>.supabase.co/functions/v1/revenuecat-webhook`, en-tête `Authorization` =
    `Bearer <secret>`, production et sandbox, tous les événements (étape 6).
  - [x] Serveur : secret `REVENUECAT_WEBHOOK_SECRET` (64 caractères aléatoires) posé sur
    Supabase ; copie locale dans `supabase/functions/.env.cloud`, non versionnée (étape 6).
  - [ ] **7b — prix de lancement de l'abonnement annuel** : dans le store, créer une **offre de
    lancement** (*introductory offer*) sur l'abonnement annuel. L'app l'affiche à tout nouvel
    abonné éligible, sur tous les écrans Premium ; l'écran présenté une fois à J+3 met
    simplement l'abonnement annuel en avant. Une « offre promotionnelle » App Store ne serait
    pas appliquée.
- **Coût** : gratuit jusqu'à un certain revenu mensuel, puis un pourcentage (voir tarifs
  RevenueCat).
- **Vérification** : RevenueCat → Webhooks → « Send test event » obtient une réponse 200
  (`ignored`, motif `test`) — obtenue le 2026-11-19.

## 8. AdMob

- **Pourquoi** : publicités de la version gratuite et vidéos qui donnent des crédits.
- **Quand** : avant la publication avec publicités (Android maintenant ; iOS avec la tâche 5).
- **Compte** : lionelkelenix@gmail.com (ta consigne). État au 2026-11-19 : « Votre compte n'a
  pas été approuvé ». AdMob y voit le doublon d'un compte AdMob que tu as déjà (un seul compte
  AdMob par personne). Choix de l'utilisateur : fermer l'autre compte (irréversible, coupe les
  publicités des apps qui l'utilisent quelques heures après).
  - [x] Ancien compte en double clôturé (toi), puis « Renvoyer » sur lionelkelenix@gmail.com
    (2026-11-19).
  - [ ] Approbation du compte par Google : en cours (jusqu'à 24 h, parfois plus).
- **Étapes Android** :
  - [x] App Android « Flirt Coach Pro » créée, pas encore associée à un store (2026-11-19).
  - [x] Bloc **bannière** « Flirt Coach Pro - Banniere » et bloc **récompensée** « Flirt Coach
    Pro - Recompensee » (récompense : 2 `credits`).
  - [x] Bloc récompensé : **vérification côté serveur** vers
    `https://<ref>.supabase.co/functions/v1/admob-ssv`, URL validée par AdMob.
  - [x] Confidentialité et messages : message RGPD « Flirt Coach Pro - RGPD » publié
    (2026-11-19, étape 9) — français par défaut, boutons Consentir, Refuser (activé pour tous
    les pays, comme l'exige la CNIL) et Gérer les options ; URL de la politique de
    confidentialité renseignée ; 199 partenaires publicitaires courants.
  - [x] Paramètres de blocage **de l'app seulement** : catégories sensibles « Rencontres » et
    « Références sexuelles » bloquées (alcool et jeux d'argent bloqués par défaut) ;
    classification maximale **T** (annonces pour adultes MA bloquées).
  - [x] Identifiants : blocs dans `config/prod.json` (`ADMOB_BANNER_ANDROID`,
    `ADMOB_REWARDED_ANDROID`) ; identifiant d'app dans `ADMOB_APP_ID_ANDROID`, à passer à la
    compilation (`-PadmobAppId=…`).
  - [x] Tâche 15 faite.
  - [ ] Après la mise en ligne : associer l'app AdMob à la fiche Google Play (examen AdMob) et
    publier `app-ads.txt` sur le site du développeur.
- **iOS** (avec la tâche 5) : app iOS, mêmes blocs, message IDFA, identifiant d'app dans
  `ios/Runner/Info.plist`.
- **Coût** : gratuit (AdMob reverse une part des revenus).
- **Vérification** : une vidéo vue jusqu'au bout ajoute 2 crédits dans l'app. Pas encore
  observé en production : 0 crédit vidéo en base au 2026-11-20.

## 9. GitHub et CI macOS

- [x] Dépôt GitHub créé ; la CI (`.github/workflows/ci.yml`) vérifie l'app, les fonctions et la
  base à chaque envoi.
- [ ] Compilation iOS (avec la tâche 5) : elle demande un Mac. Option sans Mac : un job GitHub
  Actions sur runner `macos` avec les certificats (tâche 11) en secrets du dépôt.
- **Coût** : minutes macOS facturées au-delà du quota gratuit GitHub.
- **Vérification** : onglet Actions du dépôt : CI verte.

## 10. Textes légaux relus et hébergés

- **Pourquoi** : obligation légale (RGPD) et exigence des deux stores (URL de politique de
  confidentialité).
- **Quand** : avant la publication.
- **Étapes** :
  - [ ] Faire relire `assets/legal/privacy_fr.txt` et `assets/legal/terms_fr.txt` par un juriste
    (le droit français y est supposé).
  - [x] Textes publiés sur GitHub Pages (branche `gh-pages`), générés depuis l'app par
    `scripts/legal_pages.py` (2026-11-19, étape 8) :
    https://kelenix.github.io/Flirt-Coach/confidentialite.html et
    https://kelenix.github.io/Flirt-Coach/conditions.html ; depuis le 2026-11-23, en anglais :
    `privacy.html` et `terms.html`, en allemand : `datenschutz.html` et
    `nutzungsbedingungen.html`, en espagnol : `privacidad.html` et `terminos.html` (tâche 20). Mise à jour : voir
    [Exploitation](operations.md#mettre-à-jour-les-textes-légaux-en-ligne).
  - [ ] Renseigner l'URL dans la fiche Google Play (App Store avec la tâche 5).
- **Coût** : honoraires du juriste ; hébergement souvent gratuit.
- **Vérification** : les URL s'ouvrent sans connexion ; le texte est identique à celui de l'app.

## 11. Clés de signature

- **Pourquoi** : un store n'accepte que des versions signées ; la clé ne doit jamais être perdue.
- **Quand** : avec la compilation, **uniquement sur ton autre machine**. Ta consigne : la clé
  n'est jamais créée ni enregistrée sur ce poste.
- **Étapes Android** :
  - [x] Créer une clé (2026-11-20, sur l'autre machine) : `%USERPROFILE%\cles\flirt-coach-pro-upload.jks`,
    hors du dépôt, alias `upload`, RSA 2048, valide jusqu'en 2054 ; `android/key.properties`
    créé à côté. Empreinte SHA-256 du certificat d'envoi :
    `98:ED:4E:73:EA:F6:52:A8:9E:CD:7D:B8:97:4C:BC:86:04:A4:0A:E4:42:CC:B3:2B:92:B3:6D:BE:47:E6:A1:67`.
  - [ ] La sauvegarder : mot de passe dans le gestionnaire de mots de passe, copie chiffrée du
    `.jks` hors de l'autre machine.
  - [x] Signature d'application par Google Play : active (vérifié le 2026-11-20), clé de
    signature gérée par Google ; la clé d'envoi a été enregistrée au premier dépôt.
  - [x] Configuration de signature préparée ici sans aucune clé : Gradle lit
    `android/key.properties` s'il existe (modèle : `android/key.properties.example`).
  - [ ] Sur l'autre machine, suivre le guide pas à pas :
    [Première version Google Play](operations.md#première-version-google-play-sur-lautre-machine).
- **iOS** (avec la tâche 5) : certificats et profils de distribution dans le compte Apple (Xcode
  les gère).
- **Coût** : aucun.
- **Vérification** : `flutter build appbundle` produit un fichier accepté par la console Play.

## 12. Éditeur et e-mail de support

**État : ✅ fait.**

- **Pourquoi** : mentions obligatoires dans les textes légaux ; contact exigé par les stores.
- [x] `LEGAL_PUBLISHER` (éditeur) et `SUPPORT_EMAIL` (contact) renseignés dans
  `config/prod.json`.
- Si le juriste demande l'adresse postale de l'éditeur (tâche 10), l'ajouter à
  `LEGAL_PUBLISHER`.
- **Vérification** : Réglages → Politique de confidentialité n'affiche plus « (à compléter avant
  publication) » ; « Contacter le support » apparaît.

## 13. Modération des signalements

- **Pourquoi** : améliorer le coach et répondre aux abus.
- **Quand** : chaque semaine après la publication.
- **Étapes** : voir [Exploitation](operations.md#modérer-les-signalements).
- **Coût** : ton temps.

## 14. Clé secrète RevenueCat

- **Pourquoi** : à la suppression d'un compte, effacer aussi le client chez RevenueCat (RGPD).
- **Quand** : avec la tâche 7, avant la publication.
- **Étapes** :
  - [ ] RevenueCat → API keys → créer une clé secrète, puis
    `supabase secrets set REVENUECAT_SECRET_API_KEY=<clé>`.
- **Vérification** : après une suppression de compte de test, le client n'apparaît plus dans
  RevenueCat.

## 15. Blocs AdMob autorisés

- **Pourquoi** : sans cette liste, un rappel signé venant du bloc AdMob de n'importe quel éditeur
  pourrait créditer des comptes.
- **Quand** : avec la tâche 8, avant la publication.
- **Étapes** :
  - [x] `ADMOB_AD_UNIT_IDS` posé sur Supabase avec l'identifiant du bloc « récompensée »
    Android (2026-11-19) ; ajouter `,<id ios>` avec la tâche 5.
- **Vérification** : une vidéo vue jusqu'au bout crédite toujours. Un bloc absent de la liste se
  traduit par des appels à `admob-ssv` en erreur 403 dans les journaux des fonctions (le motif
  précis n'y figure pas).

## 16. Achats sandbox pendant les tests

- **Pourquoi** : par sécurité, le serveur ignore les achats de test, qui sont gratuits.
- **Quand** : pendant la phase de test des achats uniquement.
- **Étapes** :
  - [ ] `supabase secrets set REVENUECAT_ALLOW_SANDBOX=true` pour tester.
  - [ ] **Avant la publication** : `supabase secrets unset REVENUECAT_ALLOW_SANDBOX`.
- **Vérification** : `supabase secrets list` ne contient plus ce nom au moment de publier.

## 17. Protection contre la création de comptes en série

**État : décision attendue.**

- **Pourquoi** : chaque compte anonyme reçoit 5 crédits par jour ; un script peut en créer
  beaucoup (seule limite actuelle : celle de Supabase par adresse IP).
- **Options** :

  | Option | Effet | Contraintes |
  |--------|-------|-------------|
  | CAPTCHA invisible (Cloudflare Turnstile ou hCaptcha) à la connexion anonyme | bloque les scripts simples | compte chez le fournisseur ; intégration dans l'app |
  | Attestation d'appareil (Play Integrity / App Attest) | ne crédite que des installations authentiques | plus robuste ; configuration dans les consoles Google et Apple |
  | Ne rien faire au lancement, surveiller | aucune friction | risque de coûts IA si abus |

- **Coût** : Turnstile et Play Integrity ont des quotas gratuits (voir tarifs).
- **Ce qu'il me faut** : ton choix ; j'implémente ensuite.

## 18. Mesure de fluidité sur ton téléphone

- **Pourquoi** : les mesures de rendu faites sur émulateur ne sont pas représentatives.
- **Étapes** :
  - [ ] Brancher le téléphone en USB (débogage USB activé), puis lancer la commande de
    [Performance](performance.md#mesurer-sur-ton-téléphone).
- **Vérification** : `build/performance.json` existe ; me transmettre ce fichier.

### APK de test sur ton téléphone (2026-11-19)

APK compilée avec la configuration de production (serveur en ligne, vrais blocs AdMob), signée
avec la clé de débogage.

- **Installer** : copier `app-release.apk` sur le téléphone, l'ouvrir et autoriser
  « Installer des applis inconnues ». Désinstaller cette APK avant d'installer plus tard la
  version du Play Store, sinon les signatures différentes bloquent l'installation.
- **Publicités** :
  - Ne clique jamais sur tes propres pubs : AdMob peut suspendre le compte.
  - Le plus sûr : AdMob → Paramètres → Appareils de test → ajouter ton téléphone, avec
    l'identifiant publicitaire lu dans les paramètres Android (Google → Annonces).
- **À vérifier** :
  - accueil 18+ ;
  - génération (texte et capture d'écran) et Mode Respect ;
  - analyse et banque de messages ;
  - vidéo récompensée (+2 crédits) ;
  - Réglages → « J'ai un code », avec le code de `.env.cloud` : il donne Premium 30 jours et
    utilise 1 activation sur 20.
- **Pas encore testable** : les achats. Produits et offre RevenueCat en place depuis le
  2026-11-20 ; restent la version installée depuis le test fermé, un compte testeur de
  licence et `REVENUECAT_ALLOW_SANDBOX` (tâche 16).

## 19. Test fermé Google Play

- **Pourquoi** : obligatoire pour ce compte avant d'accéder à la production (compte personnel
  créé après le 13 novembre 2023) ; déjà fait pour d'autres apps.
- **Quand** : au plus tôt, car c'est l'étape la plus longue (14 jours, plus les examens de
  Google). Achats et publicités peuvent être finalisés pendant le test, par des versions mises
  à jour.
- **Étapes** :
  - [x] Terminer la configuration de l'app dans la console (2026-11-19 ; réponses détaillées
    dans la [fiche du store](store/fiche-store.md), sections 6 et 7) :
    - [x] Fiche du store : nom, descriptions, icône, bannière, 7 captures, étiquette IA.
    - [x] Catégorie et coordonnées.
    - [x] Déclarations : confidentialité, annonces, classification, identifiant publicitaire,
      gouvernement, finances, santé.
    - [x] Code d'accès Premium (ADR-031) : développé, déployé, secret posé sur le cloud. Le code
      est en commentaire dans `supabase/functions/.env.cloud` (non versionné).
    - [x] Détails d'accès : instructions en anglais, attestation cochée par toi.
    - [x] Code court de 8 caractères (`XXXX-XXXX`, encadré en haut de `.env.cloud`) : posé sur
      le serveur et saisi dans le champ *Password* des détails d'accès. Vérifié le
      2026-11-19.
    - [x] Public cible et contenu : 18 ans et plus uniquement.
    - [x] Sécurité des données : envoyée.
  - [x] Canal « Test chiusi - Alpha » : disponible dans tous les pays (178), choix du
    2026-11-19. Les pays de la version publique se choisiront à part.
  - [x] Nouvelle liste de testeurs « Flirt Coach Pro » (ta décision du 2026-11-19), créée et
    associée au canal le 2026-11-20 avec une première adresse (la tienne). Vise 15 à 20
    personnes pour garder 12 inscrits sans interruption. Ajouter des adresses : Test chiusi -
    Alpha → Tester → flèche de la liste « Flirt Coach Pro ».
  - [x] Déposer la première version dans la console (depuis l'autre machine, guide :
    [Première version Google Play](operations.md#première-version-google-play-sur-lautre-machine)) :
    AAB 1.0.0 (1) compilé, signé et déposé le 2026-11-20 ; il est dans la bibliothèque des app
    bundles.
  - [x] Le placer dans le brouillon de « Test chiusi - Alpha » (2026-11-20, « Aggiungi dalla
    raccolta ») : nom `1.0.0 (1)`, notes en français, 14,6 Mo à l'installation. Un seul
    avertissement, attendu : aucun testeur choisi. Le brouillon des « Test interni », créé
    par erreur, est supprimé.
  - [x] Envoyé en revue le 2026-11-20 : 14 modifications (release 1.0.0 (1), pays, testeurs,
    fiche, déclarations, catégorie). Google fait d'abord des contrôles rapides (au plus
    14 minutes), puis la revue (souvent moins de 7 jours). La publication gérée est désactivée :
    le test fermé sera publié dès l'approbation. Suivi : Play Console → Panoramica della
    pubblicazione, et les e-mails de Google.
  - [ ] Inviter au moins 12 testeurs (liste d'e-mails ou groupe Google) ; chacun accepte avec le
    lien d'inscription, actif après la publication :
    https://play.google.com/apps/testing/com.flirtcoach.flirt_coach
  - [ ] Garder au moins 12 testeurs inscrits sans interruption pendant 14 jours.
  - [ ] Demander l'accès à la production depuis le tableau de bord (questions sur le test).
- **Coût** : aucun.
- **Vérification** : le tableau de bord de l'app permet de demander l'accès à la production.

## 20. Mise en ligne de l'anglais, de l'allemand et de l'espagnol

- **Pourquoi** : l'app est prête en anglais (ADR-034), en allemand (ADR-035) et en espagnol
  (ADR-036) dans le code ; il faut publier le serveur, une nouvelle version et les fiches pour
  que les testeurs en profitent.
- **Quand** : avec la prochaine version envoyée au test fermé (1.1.0). La base est mise à jour
  **juste avant** l'envoi en revue : avant, les versions 1.0.0 installées afficheraient la
  banque de messages en français et en anglais mélangés ; la 1.1.0, elle, a besoin de la base à
  jour.
- **Étapes** :
  - [ ] (Conseillé) Faire relire les textes anglais par un anglophone : `lib/l10n/app_en.arb`,
    `assets/help/faq_en.txt` et la banque (`supabase/migrations/20261123000000_message_bank_languages.sql`).
  - [ ] (Conseillé) Faire relire les textes allemands par un germanophone : `lib/l10n/app_de.arb`,
    `assets/help/faq_de.txt` et la banque (`supabase/migrations/20261123010000_message_bank_german.sql`).
  - [ ] (Conseillé) Faire relire les textes espagnols par un hispanophone, idéalement un
    d'Espagne et un d'Amérique latine : `lib/l10n/app_es.arb`, `assets/help/faq_es.txt` et la
    banque (`supabase/migrations/20261123020000_message_bank_spanish.sql`).
  - [x] Espagnol, serveur : `scripts/deploy-cloud.ps1` lancé le 2026-11-23, confirmé par toi ;
    migration `20261123020000` appliquée (banque cloud : 40 messages `fr`, `en`, `de` et `es`,
    5 catégories chacune), 8 fonctions redéployées sans changement à 10:07 UTC. Jusqu'à la
    1.1.0, la 1.0.0 affiche la banque dans les quatre langues (32 messages par catégorie).
  - [x] Espagnol, pages légales en ligne (2026-11-23, commit `35642cf` sur `gh-pages`) :
    https://kelenix.github.io/Flirt-Coach/privacidad.html et
    https://kelenix.github.io/Flirt-Coach/terminos.html, avec éditeur et contact ; les autres
    pages gardent leur texte, leur menu propose les quatre langues.
  - [x] Espagnol, Play Console : traductions « Spagnolo (America Latina) – es-419 » et
    « Spagnolo (Spagna) – es-ES » ajoutées le 2026-11-23, avec ton accord, mêmes textes
    (section 12 de la fiche du store) : nom, description courte (73/80) et longue (2334/4000) ;
    visuels repris de la fiche française ; déclaration des visuels IA inchangée.
    **Enregistrées, pas envoyées** : avec la fiche allemande, « 3 modifiche » attendent dans
    la Panoramica della pubblicazione, à envoyer avec la 1.1.0. « Spagnolo (Stati Uniti) –
    es-US » existe aussi, non ajoutée : à ajouter avec les mêmes textes si l'on vise les
    hispanophones des États-Unis.
  - [ ] **Décision (financière)** : prix locaux pour l'Amérique latine (Mexique, Colombie,
    Argentine…), sinon la Play Console y convertit les prix en euros, trop élevés.
  - [x] Allemand, serveur : `scripts/deploy-cloud.ps1` lancé le 2026-11-23, confirmé par toi ;
    migration `20261123010000` appliquée (banque cloud : 40 messages `fr`, `en` et `de`,
    5 catégories chacune), 8 fonctions redéployées sans changement. Jusqu'à la 1.1.0, la 1.0.0
    affiche la banque dans les trois langues (24 messages par catégorie).
  - [x] Allemand, pages légales en ligne (2026-11-23, commit `b86dc56` sur `gh-pages`) :
    https://kelenix.github.io/Flirt-Coach/datenschutz.html et
    https://kelenix.github.io/Flirt-Coach/nutzungsbedingungen.html, avec éditeur et contact ;
    les autres pages gardent leur texte, leur menu propose les trois langues.
  - [x] Allemand, Play Console : traduction « Tedesco – de-DE » ajoutée le 2026-11-23, avec ton
    accord : nom, description courte (72/80) et longue (2399/4000) de la section 11 de la fiche
    du store ; visuels repris de la fiche française ; déclaration des visuels IA inchangée.
    **Enregistrée, pas envoyée** : « 1 modifica » attend dans la Panoramica della
    pubblicazione (Google y fait seulement ses contrôles rapides automatiques). À envoyer avec
    la 1.1.0 ; les pages légales allemandes vers lesquelles elle renvoie sont en ligne.
  - [ ] Juriste : relire `privacy_de.txt` et `terms_de.txt`, et dire si le marché allemand
    exige une mention d'éditeur (« Impressum ») en plus des informations des stores
    (tâche 10) ; relire aussi `privacy_es.txt` et `terms_es.txt`.
  - [ ] Sur l'autre machine : version `1.1.0+2` dans `pubspec.yaml`, section `[Non publié]` du
    `CHANGELOG.md` renommée en `[1.1.0]`, compilation et signature de l'AAB, dépôt dans
    « Test chiusi - Alpha » avec les notes de version de chaque langue de fiche (fr-FR,
    en-US, de-DE, es-419, es-ES : [fiche du store](store/fiche-store.md), section 10).
  - [x] Serveur déployé par toi le 2026-11-23 vers 09:02 UTC (`scripts/deploy-cloud.ps1`) :
    migration `20261123000000` appliquée (banque cloud : 40 messages `fr` et 40 `en`), 8
    fonctions redéployées après le commit de l'anglais. Conséquence attendue jusqu'à la
    1.1.0 : la version 1.0.0 installée affiche la banque en français et en anglais mélangés
    (16 messages par catégorie) ; le reste ne change pas pour elle.
  - [x] Pages légales anglaises en ligne (2026-11-23, commit `32e8f2d` sur `gh-pages`) :
    https://kelenix.github.io/Flirt-Coach/privacy.html et
    https://kelenix.github.io/Flirt-Coach/terms.html, avec éditeur et contact ; les pages
    françaises gardent le même texte, leur menu propose aussi l'anglais.
  - [x] Play Console : traduction « Inglese (Stati Uniti) – en-US » de la fiche ajoutée le
    2026-11-23, avec ton accord (Schede dello Store → Scheda predefinita → Gestisci lingue) :
    nom, description courte (68/80) et longue (2119/4000) de la section 10 de la fiche du
    store ; visuels repris de la fiche française ; déclaration des visuels IA inchangée.
    **Envoyée en revue par toi le 2026-11-23, seule** (sans nouvelle version), puis approuvée
    et publiée le jour même : sans conséquence, les liens de la description sont en ligne et la
    fiche ne promet rien que la 1.0.0 ne fasse ; elle est simplement en avance sur l'app. Captures anglaises : plus tard
    (même section).
  - [ ] Juriste : relire aussi `privacy_en.txt` et `terms_en.txt` (tâche 10).
- **Coût** : aucun (relecture éventuelle).
- **Vérification** : sur un téléphone en anglais (puis en allemand, en espagnol), l'app s'affiche dans
  cette langue (accueil, menu, aide, textes légaux, banque) ; un refus ou une explication du
  Mode Respect arrive dans cette langue ; sur un téléphone en français, rien ne change.

