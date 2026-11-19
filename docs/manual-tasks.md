# Tâches manuelles

Ce que personne ne peut faire à ta place : créer des comptes, payer, signer, accepter des
contrats, fournir des informations légales. Chaque tâche indique **pourquoi**, **quand**, les
**étapes**, le **coût** et comment **vérifier**.

> Les tarifs indiqués sont indicatifs (état connu fin 2026) : vérifie-les sur le site officiel
> avant de t'engager.

## Récapitulatif

| # | Tâche | Bloquant pour | État |
|---|-------|---------------|------|
| 0 | Docker Desktop, émulateur Android, logo source | développement | Fait |
| 1 | Projet Supabase cloud | tests sur téléphone, publication | Fait (plan avec sauvegardes : à faire) |
| 2 | Clé API Anthropic | toute génération | Fait, en local et sur le cloud |
| 3 | Nom et identifiants définitifs de l'app | publication | À faire |
| 4 | Compte Google Play Console | achats réels Android, publication | À faire |
| 5 | Compte Apple Developer | iOS, publication | À faire |
| 6 | Produits d'achat dans les stores | achats réels | À faire |
| 7 | RevenueCat (et 7b : prix de lancement de l'annuel) | achats réels | À faire |
| 8 | AdMob | publicités réelles | À faire |
| 9 | GitHub et CI macOS | compilation iOS | En partie (CI faite, iOS à faire) |
| 10 | Textes légaux relus et hébergés | publication | À faire |
| 11 | Clés de signature Android et iOS | publication | À faire |
| 12 | Éditeur et e-mail de support | publication | À faire |
| 13 | Modération des signalements | après publication | À faire |
| 14 | Clé secrète RevenueCat | suppression de compte complète | À faire |
| 15 | Blocs AdMob autorisés | sécurité des récompenses | À faire |
| 16 | Achats sandbox (phase de test) | tests d'achat | À faire |
| 17 | Protection contre la création de comptes en série | publication | **Décision attendue** |
| 18 | Mesure de fluidité sur ton téléphone | qualité | À faire |

---

## 0. Environnement de développement

**État : fait.** Docker Desktop installé, émulateur `FlirtCoach_Pixel` créé, logo fourni
(`assets/images/Logo Flirt Coach con Cuore Brillante.png`).

## 1. Projet Supabase cloud

- **Pourquoi** : héberge la base, l'authentification et les fonctions serveur en ligne.
- **Quand** : fait ; le choix du plan est à revoir avant publication.
- **Étapes restantes** :
  1. Tableau de bord Supabase → Organization → Billing : choisir un plan qui inclut des
     sauvegardes quotidiennes.
  2. Vérifier que le projet est en région UE (données personnelles, RGPD).
- **Coût** : plan gratuit pour le développement ; plan payant à prévoir en production (de l'ordre
  de 25 $/mois).
- **Vérification** : Settings → Database → Backups affiche des sauvegardes.

## 2. Clé API Anthropic

**État : fait.** Clé en place en local (`supabase/functions/.env`) et sur le cloud
(`ANTHROPIC_API_KEY`).

- **Coût** : à l'usage (par appel). Suivre la consommation dans la console Anthropic et y fixer
  une limite de dépense mensuelle.

## 3. Nom et identifiants définitifs

- **Pourquoi** : l'identifiant d'application ne peut plus changer après la première publication.
- **Quand** : avant la création des fiches stores (tâches 4 et 5).
- **État actuel** : Android `com.flirtcoach.flirt_coach` (`android/app/build.gradle.kts`) ;
  iOS `com.flirtcoach.flirtCoach` (`ios/Runner.xcodeproj/project.pbxproj`). Apple n'accepte pas
  le caractère « _ ».
- **Étapes** :
  1. Choisir le nom affiché (aujourd'hui « Flirt Coach ») et vérifier qu'il est libre sur les deux
     stores et sans conflit de marque.
  2. Choisir les identifiants, idéalement sur un nom de domaine que tu possèdes
     (ex. `com.tonentreprise.flirtcoach`, sans « _ », valable sur les deux plateformes).
  3. Me les transmettre : je les reporte dans les projets Android et iOS.
- **Coût** : aucun (dépôt de marque éventuel en plus).
- **Vérification** : les identifiants figurent dans les deux fichiers cités.

## 4. Compte Google Play Console

- **Pourquoi** : publier sur Android et vendre abonnements et packs.
- **Quand** : avant les achats réels et la publication Android.
- **Étapes** :
  1. https://play.google.com/console → créer un compte développeur (vérification d'identité).
  2. Créer l'application avec l'identifiant choisi (tâche 3).
  3. Profil de paiement (marchand) pour recevoir les ventes.
- **Coût** : 25 $ une fois.
- **Vérification** : l'application apparaît dans la console.

## 5. Compte Apple Developer

- **Pourquoi** : publier sur iOS et vendre sur l'App Store.
- **Quand** : avant toute version iOS.
- **Étapes** :
  1. https://developer.apple.com/programs → adhérer (particulier ou organisation).
  2. App Store Connect → créer l'app avec l'identifiant choisi.
  3. Accords, taxes et coordonnées bancaires (« Paid Apps »).
- **Coût** : 99 $/an.
- **Vérification** : l'app apparaît dans App Store Connect.

## 6. Produits d'achat dans les stores

- **Pourquoi** : les prix et les produits sont définis dans chaque store.
- **Quand** : après les tâches 4 et 5, avant la tâche 7.
- **Étapes** (identiques sur les deux stores) :
  1. Abonnements dans un même groupe : `flirtcoach_premium_weekly`, `flirtcoach_premium_monthly`,
     `flirtcoach_premium_annual`.
  2. Produits consommables : `flirtcoach_credits_20`, `flirtcoach_credits_50`, `flirtcoach_credits_100`.
  3. Saisir les prix décidés : 6,99 € / 12,99 € / 49,99 € et 2,99 € / 5,99 € / 9,99 €.
- **Coût** : commission du store sur chaque vente.
- **Vérification** : les 6 produits sont « actifs » ou « prêts à soumettre ».

## 7. RevenueCat

- **Pourquoi** : relie les achats des deux stores au serveur, qui accorde les droits.
- **Quand** : après la tâche 6.
- **Étapes** :
  1. https://www.revenuecat.com → créer un projet, y connecter Google Play et l'App Store.
  2. Créer un droit (*entitlement*) `premium` relié aux 3 abonnements ; importer les 3 packs.
  3. Créer une offre (*offering*) contenant les 6 produits et la marquer **Current** : l'app
     affiche l'offre « Current », quel que soit son nom.
  4. Project settings → *Restore behavior* : garder **Transfer to new App User ID** (valeur par
     défaut). C'est ce qui rattache un abonnement à une nouvelle installation.
  5. Webhook : URL `https://<ref>.supabase.co/functions/v1/revenuecat-webhook`, en-tête
     `Authorization` = `Bearer <un secret long et aléatoire>`.
  6. Serveur : `supabase secrets set REVENUECAT_WEBHOOK_SECRET=<le même secret>`.
  7. Clés **publiques** du SDK dans `config/prod.json` : `REVENUECAT_ANDROID_KEY`,
     `REVENUECAT_IOS_KEY`.
- **7b — prix de lancement de l'abonnement annuel** : dans chaque store, créer une **offre de
  lancement** (*introductory offer*) sur l'abonnement annuel. L'app l'affiche à tout nouvel
  abonné éligible, sur tous les écrans Premium ; l'écran présenté une fois à J+3 met simplement
  l'abonnement annuel en avant. Une « offre promotionnelle » App Store ne serait pas appliquée.
- **Coût** : gratuit jusqu'à un certain revenu mensuel, puis un pourcentage (voir tarifs
  RevenueCat).
- **Vérification** : RevenueCat → Webhooks → « Send test event » obtient une réponse 200
  (`ignored`, motif `test`).

## 8. AdMob

- **Pourquoi** : publicités de la version gratuite et vidéos qui donnent des crédits.
- **Quand** : avant la publication avec publicités.
- **Étapes** :
  1. https://admob.google.com → créer les apps Android et iOS.
  2. Créer pour chacune un bloc **bannière** et un bloc **récompensée** (récompense : 2 crédits).
  3. Sur chaque bloc récompensé, activer la **vérification côté serveur** avec l'URL
     `https://<ref>.supabase.co/functions/v1/admob-ssv`.
  4. Confidentialité et messages : créer le message de consentement RGPD (et le message IDFA iOS).
  5. Contrôle des annonces : **bloquer les catégories « Rencontres » et le contenu pour adultes**.
  6. Identifiants : blocs dans `config/prod.json` (`ADMOB_*`) ; identifiant d'app Android passé à
     la compilation (`-PadmobAppId=…`) ; identifiant iOS dans `ios/Runner/Info.plist`.
  7. Puis tâche 15.
- **Coût** : gratuit (AdMob reverse une part des revenus).
- **Vérification** : une vidéo vue jusqu'au bout ajoute 2 crédits dans l'app.

## 9. GitHub et CI macOS

- **État** : dépôt GitHub créé ; la CI (`.github/workflows/ci.yml`) vérifie l'app, les fonctions
  et la base à chaque envoi.
- **Reste** : compiler iOS demande un Mac. Option sans Mac : un job GitHub Actions sur runner
  `macos` avec les certificats (tâche 11) en secrets du dépôt.
- **Coût** : minutes macOS facturées au-delà du quota gratuit GitHub.
- **Vérification** : onglet Actions du dépôt : CI verte.

## 10. Textes légaux relus et hébergés

- **Pourquoi** : obligation légale (RGPD) et exigence des deux stores (URL de politique de
  confidentialité).
- **Quand** : avant la publication.
- **Étapes** :
  1. Faire relire `assets/legal/privacy_fr.txt` et `assets/legal/terms_fr.txt` par un juriste (le
     droit français y est supposé).
  2. Publier les deux textes sur une page web publique (site de l'éditeur, page simple).
  3. Renseigner l'URL dans les fiches Google Play et App Store.
- **Coût** : honoraires du juriste ; hébergement souvent gratuit.
- **Vérification** : les URL s'ouvrent sans connexion ; le texte est identique à celui de l'app.

## 11. Clés de signature

- **Pourquoi** : un store n'accepte que des versions signées ; la clé ne doit jamais être perdue.
- **Quand** : avant la première version envoyée aux stores.
- **Étapes Android** :
  1. Créer une clé :
     `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
  2. La conserver **hors du dépôt** (gestionnaire de mots de passe et copie de secours).
  3. Activer « Signature d'application par Google Play » dans la console.
  4. Me signaler que la clé existe : je branche la configuration de signature (fichier
     `key.properties` non versionné).
- **Étapes iOS** : certificats et profils de distribution dans le compte Apple (Xcode les gère).
- **Coût** : aucun.
- **Vérification** : `flutter build appbundle` produit un fichier accepté par la console Play.

## 12. Éditeur et e-mail de support

- **Pourquoi** : mentions obligatoires dans les textes légaux ; contact exigé par les stores.
- **Quand** : avant la publication.
- **Étapes** : dans `config/prod.json`, renseigner `LEGAL_PUBLISHER` (nom et adresse de
  l'éditeur) et `SUPPORT_EMAIL` (une adresse que tu consultes).
- **Coût** : aucun.
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
- **Étapes** : RevenueCat → API keys → créer une clé secrète, puis
  `supabase secrets set REVENUECAT_SECRET_API_KEY=<clé>`.
- **Vérification** : après une suppression de compte de test, le client n'apparaît plus dans
  RevenueCat.

## 15. Blocs AdMob autorisés

- **Pourquoi** : sans cette liste, un rappel signé venant du bloc AdMob de n'importe quel éditeur
  pourrait créditer des comptes.
- **Quand** : avec la tâche 8, avant la publication.
- **Étapes** : `supabase secrets set ADMOB_AD_UNIT_IDS=<id android>,<id ios>` (partie après « / »
  des blocs « récompensée »).
- **Vérification** : une vidéo vue jusqu'au bout crédite toujours. Un bloc absent de la liste se
  traduit par des appels à `admob-ssv` en erreur 403 dans les journaux des fonctions (le motif
  précis n'y figure pas).

## 16. Achats sandbox pendant les tests

- **Pourquoi** : par sécurité, le serveur ignore les achats de test, qui sont gratuits.
- **Quand** : pendant la phase de test des achats uniquement.
- **Étapes** :
  1. `supabase secrets set REVENUECAT_ALLOW_SANDBOX=true` pour tester.
  2. **Avant la publication** : `supabase secrets unset REVENUECAT_ALLOW_SANDBOX`.
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
- **Étapes** : brancher le téléphone en USB (débogage USB activé), puis lancer la commande de
  [Performance](performance.md#mesurer-sur-ton-téléphone).
- **Vérification** : `build/performance.json` existe ; me transmettre ce fichier.
