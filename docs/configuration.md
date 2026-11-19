# Configuration

Flirt Coach Pro a deux types de configuration, qui ne se mélangent jamais :

| Où | Contenu | Visible par l'utilisateur ? |
|----|---------|-----------------------------|
| **App** : `config/<environnement>.json`, injecté à la compilation | URL et clé publique du serveur, identifiants publics d'achats et de publicité, mentions légales | oui (un binaire mobile se décompile) : **aucun secret** |
| **Serveur** : secrets des Edge Functions | clé IA, secrets de webhook, clés privées | non |

## 1. Configuration de l'app

L'app lit sa configuration avec `--dart-define-from-file` :

```powershell
flutter run --dart-define-from-file=config/dev.json
```

Les fichiers `config/*.json` ne sont **pas versionnés**. Partir des modèles :

| Fichier | Usage | Modèle |
|---------|-------|--------|
| `config/dev.json` | émulateur Android + Supabase local | `config/dev.example.json` |
| `config/phone.json` | téléphone + Supabase local (même Wi-Fi) | `config/phone.example.json` |
| `config/prod.json` | Supabase cloud (builds de test et de publication) | `config/prod.example.json` |

### Variables

| Variable | Obligatoire | Description | Exemple / source |
|----------|-------------|-------------|------------------|
| `SUPABASE_URL` | oui | adresse du projet Supabase | local émulateur : `http://10.0.2.2:54321` · téléphone : `http://<IP du PC>:54321` · cloud : `https://<ref>.supabase.co` |
| `SUPABASE_ANON_KEY` | oui | clé **publishable** (ou `anon`) — publique, les données sont protégées par RLS | `supabase status` (local) · tableau de bord → Project Settings → API (cloud) |
| `REVENUECAT_ANDROID_KEY` | non | clé **publique** du SDK RevenueCat pour Google Play. Vide : achats indisponibles | RevenueCat → Project → API keys |
| `REVENUECAT_IOS_KEY` | non | idem pour l'App Store | idem |
| `ADMOB_BANNER_ANDROID` | non | bloc d'annonces bannière Android. Vide : aucune bannière | AdMob → Apps → Ad units (les modèles contiennent les identifiants **de test** de Google) |
| `ADMOB_REWARDED_ANDROID` | non | bloc d'annonces « récompensée » Android | idem |
| `ADMOB_APP_ID_ANDROID` | publication | identifiant d'app AdMob Android, gardé ici pour la compilation (`-PadmobAppId=…`) ; l'app ne le lit pas | AdMob → Apps → App settings |
| `ADMOB_BANNER_IOS` | non | bannière iOS | idem |
| `ADMOB_REWARDED_IOS` | non | récompensée iOS | idem |
| `LEGAL_PUBLISHER` | avant publication | nom et adresse de l'éditeur, cités dans les textes légaux. Vide : « (à compléter avant publication) » | à fournir |
| `SUPPORT_EMAIL` | avant publication | contact support, données personnelles et signalements. Vide : lien « Contacter le support » masqué | à fournir |

Si `SUPABASE_URL` ou `SUPABASE_ANON_KEY` manque, l'app affiche l'écran « Configuration
manquante » au lieu de démarrer.

### Identifiants AdMob natifs

En plus des blocs d'annonces, AdMob exige un **identifiant d'application** dans le binaire :

| Plateforme | Où | Par défaut |
|------------|----|------------|
| Android | propriété Gradle à la compilation : `flutter build appbundle -PadmobAppId=<ADMOB_APP_ID_ANDROID de config/prod.json> …` | identifiant de test de Google |
| iOS | `ios/Runner/Info.plist`, clé `GADApplicationIdentifier` | identifiant de test de Google |

### Identifiant de l'application

| Plateforme | Identifiant | Où |
|------------|-------------|----|
| Android | `com.flirtcoach.flirt_coach` | `applicationId`, `android/app/build.gradle.kts` |
| iOS | `com.flirtcoach.flirtCoach` | `PRODUCT_BUNDLE_IDENTIFIER`, `ios/Runner.xcodeproj/project.pbxproj` |

Identifiants confirmés le 2026-11-19 (tâche manuelle 3, ADR-028). L'identifiant Android devient
**définitif** dès la création de l'app dans la Play Console. Apple n'accepte pas le caractère
« _ ».

## 2. Secrets du serveur (Edge Functions)

| Secret | Obligatoire | Utilisé par | Rôle |
|--------|-------------|-------------|------|
| `ANTHROPIC_API_KEY` | oui | fonctions IA | clé de l'API Claude |
| `REVENUECAT_WEBHOOK_SECRET` | pour les achats | `revenuecat-webhook` | secret partagé : RevenueCat l'envoie dans `Authorization: Bearer <secret>` |
| `REVENUECAT_SECRET_API_KEY` | recommandé | `delete-account` | efface aussi le client RevenueCat à la suppression d'un compte (RGPD) |
| `REVENUECAT_ALLOW_SANDBOX` | phase de test uniquement | `revenuecat-webhook` | `true` : les achats de test (sandbox) donnent des droits. **À retirer avant la publication** |
| `ADMOB_AD_UNIT_IDS` | pour les pubs | `admob-ssv` | blocs « récompensée » autorisés à créditer, séparés par des virgules (partie après « / ») |
| `REVIEW_ACCESS_CODE_SHA256` | pour la revue des stores | `redeem-code` | empreinte SHA-256 (hexadécimal) du code d'accès Premium, en majuscules sans tirets ; vide : aucun code accepté (ADR-031). Le code en clair n'est que dans `supabase/functions/.env.cloud` (non versionné) |
| `REVIEW_ACCESS_MAX_REDEMPTIONS` | non (20 par défaut) | `redeem-code` | nombre maximal d'activations par code |
| `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` | automatique | toutes | fournis par Supabase lui-même, ne jamais les définir à la main |

### En local

Fichier `supabase/functions/.env` (non versionné), créé depuis `supabase/functions/.env.example`,
puis :

```powershell
supabase functions serve --env-file supabase/functions/.env
```

### Sur le cloud

```powershell
supabase secrets set ANTHROPIC_API_KEY=ta_cle
```

```powershell
supabase secrets list
```

`secrets list` n'affiche que les noms et une empreinte, jamais les valeurs. Ne jamais coller une
clé dans le code, un fichier versionné, un ticket ou une conversation.

## 3. Constantes métier

Ces règles ne sont pas des réglages : les changer est une évolution du produit.

| Règle | Valeur | Source de vérité (serveur) | Comment la modifier |
|-------|--------|----------------------------|---------------------|
| Crédits gratuits par jour (non cumulables, remis à minuit UTC) | 5 | `daily_credit_allowance()` ; défaut et contrainte de `credit_balances.daily_credits` | nouvelle migration |
| Appels IA par minute (tous) | 10 | `ai_rate_limit_per_minute()` | nouvelle migration |
| Appels IA par jour (tous, Premium compris) | 100 | `premium_daily_limit()` | nouvelle migration |
| Vidéos récompensées par jour / crédits par vidéo | 5 / 2 | `ad_reward_daily_limit()`, `ad_reward_credits()` | nouvelle migration |
| Signalements | 20 par 24 h glissantes | `report_generation()` | nouvelle migration |
| Coût : génération / Mode Respect / capture | 1 / 1 / 2 crédits | `index.ts` de chaque fonction | redéploiement des fonctions |
| Crédits par pack | 20 / 50 / 100 | `revenuecat-webhook/revenuecat.ts` | redéploiement des fonctions |
| Taille maximale d'une image | 3,5 Mo | `maxImageBytes`, `screenshot-reply/screenshot.ts` | redéploiement des fonctions |

**Copies dans l'app**, à mettre à jour dans le même changement : coûts affichés
(`generation_request.dart`), packs (`revenuecat_purchases_repository.dart`), taille d'image
(`screenshot_picker.dart`) et textes de `app_fr.arb` qui citent ces nombres (« 5 nouveaux »,
« +2 crédits », « 2 crédits », « 100 messages »).
