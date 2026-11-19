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
  bannière 1024 × 500, 6 captures 1080 × 1920 avec accroche) ; à déposer avec la fiche du
  store (tâche 19).
- **Test fermé obligatoire** pour ce compte (tâche 19) : c'est l'étape la plus longue
  (14 jours) ; les étapes sont ordonnées pour le lancer au plus tôt.
- La compilation des versions envoyées aux stores se fait sur une autre machine ; elle sera
  abordée plus tard.

## Récapitulatif

| # | Tâche | Bloquant pour | État |
|---|-------|---------------|------|
| 0 | Docker Desktop, émulateur Android, logo source | développement | ✅ Fait |
| 1 | Projet Supabase cloud | tests sur téléphone, publication | ✅ Fait (reste : plan avec sauvegardes) |
| 2 | Clé API Anthropic | toute génération | ✅ Fait, en local et sur le cloud |
| 3 | Nom et identifiants de l'app | publication | ✅ Décidé : « Flirt Coach Pro », identifiants inchangés |
| 4 | Compte Google Play Console | achats réels Android, publication | App créée, profil de paiement et taux de 15 % actifs |
| 5 | Compte Apple Developer | iOS | Après la mise en ligne Android |
| 6 | Produits d'achat dans les stores | achats réels | À faire, guidé |
| 7 | RevenueCat (et 7b : prix de lancement de l'annuel) | achats réels | Projet, app, clé, notifications et webhook en place ; produits à faire |
| 8 | AdMob | publicités réelles | App, blocs, blocages et consentement RGPD en place ; compte en validation ; Play Store à associer après la mise en ligne |
| 9 | GitHub et CI macOS | compilation iOS | En partie (CI faite ; iOS avec la tâche 5) |
| 10 | Textes légaux relus et hébergés | publication | En ligne (GitHub Pages) ; relecture par un juriste à faire |
| 11 | Clés de signature Android et iOS | publication | Plus tard, avec la compilation |
| 12 | Éditeur et e-mail de support | publication | ✅ Fait |
| 13 | Modération des signalements | après publication | Après la publication |
| 14 | Clé secrète RevenueCat | suppression de compte complète | Plus tard, avec la tâche 7 |
| 15 | Blocs AdMob autorisés | sécurité des récompenses | ✅ Fait (Android) |
| 16 | Achats sandbox (phase de test) | tests d'achat | Plus tard, avec la tâche 7 |
| 17 | Protection contre la création de comptes en série | publication | **Décision attendue** |
| 18 | Mesure de fluidité sur ton téléphone | qualité | Plus tard |
| 19 | Test fermé Google Play (12 testeurs, 14 jours) | publication (production) | À faire, au plus tôt (textes et visuels de la fiche prêts) |

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
  - [ ] Nom de l'app dans la console : encore « Flirt Coach » ; le passer à « Flirt Coach Pro »
    dans la fiche du store.
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
  reste bloquée.
- **Étapes Google Play** :
  - [ ] 3 abonnements distincts, chacun avec un forfait de base à renouvellement automatique :
    `flirtcoach_premium_weekly`, `flirtcoach_premium_monthly`, `flirtcoach_premium_annual`
    (un seul abonnement à 3 forfaits ne serait pas reconnu par l'app).
  - [ ] 3 produits consommables : `flirtcoach_credits_20`, `flirtcoach_credits_50`,
    `flirtcoach_credits_100`.
  - [ ] Prix décidés : 6,99 € / 12,99 € / 49,99 € et 2,99 € / 5,99 € / 9,99 €.
- **App Store** (avec la tâche 5) : mêmes identifiants et mêmes prix ; les 3 abonnements dans un
  même groupe.
- **Coût** : commission du store sur chaque vente. Google Play (barème 2026) : 15 % sur les
  abonnements ; sur les packs, 15 % avec l'inscription au taux de 15 % (tâche 4), 25 à 30 % sans.
- **Vérification** : les 6 produits sont « actifs » ou « prêts à soumettre ».

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
    package qu'après l'envoi de la première version (attendu). Après cet envoi : « Check
    again ».
  - [ ] Supprimer le fichier de la clé de Téléchargements (ou le ranger dans un gestionnaire
    de mots de passe).
  - [x] Notifications Google en temps réel : sujet
    `projects/flirt-coach-pro/topics/Play-Store-Notifications` (Google Play y a le rôle
    « Diffuseur Pub/Sub »), relié à RevenueCat ; Play Console : abonnements, achats annulés et
    tous les produits ponctuels ; notification de test reçue par RevenueCat (étape 5).
  - [ ] Créer un droit (*entitlement*) `premium` relié aux 3 abonnements ; importer les 3 packs.
  - [ ] Créer une offre (*offering*) contenant les 6 produits et la marquer **Current** : l'app
    affiche l'offre « Current », quel que soit son nom.
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
- **Vérification** : une vidéo vue jusqu'au bout ajoute 2 crédits dans l'app.

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
    https://kelenix.github.io/Flirt-Coach/conditions.html. Mise à jour : voir
    [Exploitation](operations.md#mettre-à-jour-les-textes-légaux-en-ligne).
  - [ ] Renseigner l'URL dans la fiche Google Play (App Store avec la tâche 5).
- **Coût** : honoraires du juriste ; hébergement souvent gratuit.
- **Vérification** : les URL s'ouvrent sans connexion ; le texte est identique à celui de l'app.

## 11. Clés de signature

- **Pourquoi** : un store n'accepte que des versions signées ; la clé ne doit jamais être perdue.
- **Quand** : avec la compilation, sur la machine qui produit les versions des stores.
- **Étapes Android** :
  - [ ] Créer une clé :
    `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
  - [ ] La conserver **hors du dépôt** (gestionnaire de mots de passe et copie de secours).
  - [ ] Activer « Signature d'application par Google Play » dans la console.
  - [ ] Me signaler que la clé existe : je branche la configuration de signature (fichier
    `key.properties` non versionné).
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

## 19. Test fermé Google Play

- **Pourquoi** : obligatoire pour ce compte avant d'accéder à la production (compte personnel
  créé après le 13 novembre 2023) ; déjà fait pour d'autres apps.
- **Quand** : au plus tôt, car c'est l'étape la plus longue (14 jours, plus les examens de
  Google). Achats et publicités peuvent être finalisés pendant le test, par des versions mises
  à jour.
- **Étapes** :
  - [ ] Terminer la configuration de l'app dans la console (fiche du store, déclarations sur le
    contenu, URL de la politique de confidentialité). Textes prêts dans la
    [fiche du store](store/fiche-store.md), visuels dans `docs/store/visuels/`.
  - [ ] Envoyer une version dans le canal de test fermé (depuis l'autre machine).
  - [ ] Inviter au moins 12 testeurs (liste d'e-mails ou groupe Google) ; chacun accepte avec le
    lien d'inscription.
  - [ ] Garder au moins 12 testeurs inscrits sans interruption pendant 14 jours.
  - [ ] Demander l'accès à la production depuis le tableau de bord (questions sur le test).
- **Coût** : aucun.
- **Vérification** : le tableau de bord de l'app permet de demander l'accès à la production.
