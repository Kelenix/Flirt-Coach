# Flirt Coach

Coach de drague et messages : application mobile (Android + iOS) d'aide à la communication
romantique par IA, pour adultes, positionnée « séduction respectueuse ».

Stack : Flutter · Riverpod · go_router · Supabase (Postgres, Auth, RLS, Edge Functions).

## Prérequis

- Flutter 3.41+ (`flutter --version`)
- Docker Desktop **démarré** (la base de développement tourne dedans)
- Supabase CLI (`supabase --version`)
- Un émulateur Android ou un téléphone

## Lancer en local

1. Démarrer la base (premier lancement : télécharge les images, quelques minutes) :

   ```powershell
   supabase start
   ```

   Les migrations de `supabase/migrations/` sont appliquées automatiquement.
   `supabase db reset` rejoue tout depuis zéro.

2. Créer la configuration locale à partir du modèle :

   ```powershell
   Copy-Item config/dev.example.json config/dev.json
   ```

   Puis coller dans `config/dev.json` la clé `anon` (ou `publishable`) affichée par
   `supabase status`. L'URL `http://10.0.2.2:54321` est celle de ta machine vue depuis
   l'émulateur Android ; sur un téléphone réel, mets l'adresse IP de ton PC.

3. Donner la clé de l'IA aux Edge Functions (une seule fois) : créer
   `supabase/functions/.env` sur le modèle de `supabase/functions/.env.example`, avec ta
   clé API Anthropic. Ce fichier n'est jamais versionné. Puis servir les fonctions :

   ```powershell
   supabase functions serve
   ```

4. Lancer l'app :

   ```powershell
   flutter run --dart-define-from-file=config/dev.json
   ```

## Tester sur un vrai téléphone Android

L'APK produit par `flutter run` sur l'émulateur ne fonctionne **pas** sur un téléphone : il est
compilé pour le processeur de l'émulateur et vise l'adresse `10.0.2.2`, qui n'existe que dans
l'émulateur. Pour un téléphone :

1. Le PC et le téléphone sont sur le **même Wi-Fi** ; Docker, `supabase start` et
   `supabase functions serve --env-file supabase/functions/.env` tournent sur le PC.
2. Adresse IP Wi-Fi du PC : `ipconfig` (ligne « Adresse IPv4 » de la carte Wi-Fi). La mettre
   dans `config/phone.json` (copie de `config/phone.example.json`). Elle peut changer quand
   le PC se reconnecte : recompiler alors.
3. Compiler en mode **profile** : version compilée, fluide comme la version publiée, et
   autorisée à parler en HTTP au serveur local (la version « debug » est saccadée sur
   téléphone) :

   ```powershell
   flutter build apk --profile --target-platform android-arm,android-arm64 --dart-define-from-file=config/phone.json
   ```

4. Installer `build/app/outputs/flutter-apk/app-profile.apk` sur le téléphone (autoriser
   l'installation d'applications de sources inconnues pour l'app qui ouvre le fichier).

Pour une installation sans PC allumé, il faudra le serveur Supabase en ligne
(`docs/manual-tasks.md`, tâche 1).

## Vérifier

```powershell
flutter analyze
```

```powershell
flutter test
```

Tests des règles d'accès de la base (Supabase local démarré) :

```powershell
supabase test db
```

Tests de l'Edge Function (dans Docker, sans installer Deno) :

```powershell
docker run --rm -v "${PWD}/supabase/functions:/fn" -w /fn/generate denoland/deno:2.9.8 test --allow-env .
```

Après une modification d'un modèle `freezed` (`*.dart` avec `@freezed`) :

```powershell
dart run build_runner build -d
```

Si `supabase` ne trouve pas Docker, ajoute le dossier de Docker Desktop au PATH de la session :

```powershell
$env:Path = "$env:LOCALAPPDATA\Programs\DockerDesktop\resources\bin;$env:Path"
```

## Où trouver quoi

| Sujet | Fichier |
|-------|---------|
| Avancement, prochaine action | `PROJECT_STATE.md` |
| Décisions et leurs raisons | `DECISION_LOG.md` |
| Ce que tu dois faire toi-même (comptes, clés) | `docs/manual-tasks.md` |
| Besoin fonctionnel | `INTAKE.md`, `docs/product/user-stories.md` |
| Architecture, flux, données | `docs/architecture.md`, `docs/system-design.md`, `docs/data-model.md` |
| Design (kit de marque néon) | `docs/design/` |
| Risques | `docs/risks.md` |

## Secrets

Aucun secret dans le code ni dans le dépôt. L'URL et la clé `anon` Supabase sont publiques
par nature (les données sont protégées par RLS) et passent par `config/*.json`, non versionné.
La clé IA et la clé `service_role` ne vivent que dans les secrets des Edge Functions.

## Supabase cloud

- `config/prod.json` (non versionné, modèle `config/prod.example.json`) : `SUPABASE_URL` + clé *publishable* / `anon`.
- Déployer migrations et Edge Functions : `powershell -ExecutionPolicy Bypass -File scripts\deploy-cloud.ps1`.
- APK branché sur le cloud : `flutter build apk --profile --target-platform android-arm,android-arm64 --dart-define-from-file=config/prod.json`.
