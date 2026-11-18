# Tâches manuelles (à faire par toi)

> Ce que Claude ne peut pas faire à ta place : créer des comptes, payer, signer, accepter des
> contrats. Chaque tâche indique à quel moment elle devient bloquante.

| # | Tâche | Bloquant pour | État |
|---|-------|---------------|------|
| 0 | Installer et démarrer **Docker Desktop** — la base de développement tourne dedans | Inc-0 | ✅ |
| 0c | Créer un **émulateur Android** (Android Studio → Device Manager) ou brancher un téléphone en mode développeur, pour voir l'app tourner | contrôle visuel | ✅ émulateur `FlirtCoach_Pixel` créé |
| 0b | Fournir le **logo et l'icône** du kit de marque en fichiers sources (SVG ou PNG haute définition) ; sinon Claude les redessine d'après l'image | Inc-0 | ⬜ |
| 1 | Créer un projet **Supabase** cloud (région UE) ; activer la connexion anonyme ; mettre l'URL dans `SUPABASE_URL` et la clé `anon` / *publishable* dans `SUPABASE_ANON_KEY` du fichier `config/prod.json` (non versionné, modèle `config/prod.example.json`). Les clés `service_role` / *secret* et le JWT secret ne vont **nulle part** dans l'app ni dans un fichier : le cloud les fournit lui-même aux Edge Functions | phase 6 (publication) | ✅ projet relié, 6 migrations et 6 Edge Functions déployées (`scripts/deploy-cloud.ps1`) · ✅ connexion anonyme · ✅ `ANTHROPIC_API_KEY` |
| 2 | Clé API **Anthropic** : en local, la mettre dans `supabase/functions/.env` (ligne `ANTHROPIC_API_KEY=…`, modèle dans `.env.example`, fichier non versionné) ; en production, `supabase secrets set ANTHROPIC_API_KEY=…`. Ne jamais la coller dans le chat ni dans le code | Inc-1 | ✅ local · ⬜ production |
| 3 | Choisir le **nom définitif** et l'**identifiant d'application** (ex. `com.tonentreprise.flirtcoach`) — définitif après publication | Inc-0 | ⬜ |
| 4 | Compte **Google Play Console** (frais uniques) | Inc-5, phase 6 | ⬜ |
| 5 | Compte **Apple Developer** (abonnement annuel) | Inc-5 (iOS), phase 6 | ⬜ |
| 6 | Créer les produits dans les deux stores : 3 abonnements (hebdo, mensuel, annuel + offre promo annuelle) et 3 packs de crédits (20/50/100), avec les prix définitifs | Inc-5 | ⬜ |
| 7 | Compte **RevenueCat** relié aux deux stores : produits `flirtcoach_premium_weekly`, `flirtcoach_premium_monthly`, `flirtcoach_premium_annual` (un seul droit « premium »), `flirtcoach_credits_20/50/100` ; une offre « current » contenant les 6 ; webhook vers `…/functions/v1/revenuecat-webhook` avec l'en-tête `Authorization: Bearer <secret>` ; le même secret en `REVENUECAT_WEBHOOK_SECRET` (`supabase secrets set`) ; clés publiques SDK dans `config/*.json` (`REVENUECAT_ANDROID_KEY`, `REVENUECAT_IOS_KEY`) | Inc-5 (achats réels) | ⬜ |
| 7b | Dans les stores, configurer l'**offre annuelle remisée** (offre d'introduction ou promotionnelle) proposée à J+3 | Inc-5 | ⬜ |
| 8 | Compte **AdMob** : app Android + iOS, blocs « bannière » et « récompensée » (récompense : 2 crédits) ; **vérification côté serveur** de la récompensée vers `…/functions/v1/admob-ssv` ; message de consentement RGPD (et message IDFA pour iOS) dans « Confidentialité et messages » ; **bloquer les catégories « Rencontres » et contenus pour adultes** (INTAKE §3.3). Puis : identifiant d'app Android via `-PadmobAppId=…` à la compilation, identifiant iOS dans `ios/Runner/Info.plist` (`GADApplicationIdentifier`), blocs d'annonces dans `config/prod.json` (`ADMOB_*`). En développement, les identifiants de **test** de Google sont utilisés | Inc-6 (annonces réelles) | ⬜ |
| 9 | Dépôt **GitHub** (CI ; runner macOS nécessaire pour compiler iOS depuis un poste Windows) | Inc-0 (CI) | ⬜ |
| 10 | Faire relire par un juriste `assets/legal/privacy_fr.txt` et `assets/legal/terms_fr.txt` (rédigés par Claude, droit français supposé), puis les **héberger sur une URL publique** (exigée par les fiches des stores) | phase 6 | ⬜ |
| 11 | Clés de signature Android (keystore) et certificats iOS | phase 6 | ⬜ |
| 12 | Renseigner dans `config/prod.json` : `LEGAL_PUBLISHER` (nom et adresse de l'éditeur) et `SUPPORT_EMAIL` (support, données personnelles, signalements). Tant qu'ils sont vides, les textes légaux affichent « (à compléter avant publication) » et le lien « Contacter le support » est masqué | Inc-10 | ⬜ |
| 13 | Examiner régulièrement les **signalements** : tableau de bord Supabase → table `reports` (texte signalé, motif, date) | après publication | ⬜ |
| 14 | RevenueCat (avec la tâche 7) : clé **secrète** API en secret serveur `supabase secrets set REVENUECAT_SECRET_API_KEY=…` pour effacer aussi le client RevenueCat lors d'une suppression de compte (RGPD) | Inc-10 | ⬜ |
