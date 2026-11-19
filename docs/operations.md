# Exploitation

Opérations courantes une fois l'app en service : déployer, gérer les secrets, surveiller,
modérer, réagir à un incident.

## Déployer

### Base de données et Edge Functions

```powershell
powershell -ExecutionPolicy Bypass -File scripts\deploy-cloud.ps1
```

Le script (projet cible lu dans `config/prod.json`) :

1. vérifie que le compte Supabase connecté voit le projet, sinon lance `supabase login` ;
2. relie le dossier au projet (`supabase link`, mot de passe de la base demandé) ;
3. applique les nouvelles migrations (`supabase db push`, **confirmation demandée**) ;
4. déploie les 8 Edge Functions (regroupées côté serveur, sans Docker) ;
5. affiche les noms des secrets présents.

Règles : une migration appliquée sur le cloud n'est jamais modifiée (en créer une nouvelle) ;
toujours lancer `supabase test db` et les tests Deno avant.

### Application

| Cible | Commande |
|-------|----------|
| Test interne (APK) | `flutter build apk --release --target-platform android-arm,android-arm64 --dart-define-from-file=config/prod.json` |
| Google Play | `flutter build appbundle --release --dart-define-from-file=config/prod.json -PadmobAppId=<id AdMob Android>` |
| App Store | à compiler sur macOS (`flutter build ipa`) — voir tâches manuelles 5 et 9 |

Avant chaque version : numéro de version dans `pubspec.yaml` (`1.0.1+2` : nom + numéro de
build croissant), entrée dans `CHANGELOG.md`, tests verts.

## Gérer les secrets

```powershell
supabase secrets list
```

```powershell
supabase secrets set NOM=valeur
```

```powershell
supabase secrets unset NOM
```

Liste et rôle de chaque secret : [`configuration.md`](configuration.md#2-secrets-du-serveur-edge-functions).
Une modification de secret s'applique aux appels suivants, sans redéploiement.

**Rotation d'une clé exposée** (clé IA, secret de webhook) : en créer une nouvelle chez le
fournisseur, `supabase secrets set …`, vérifier une génération, puis révoquer l'ancienne. Pour le
secret RevenueCat, mettre à jour le même en-tête dans le tableau de bord RevenueCat.

## Surveiller

| Quoi | Où |
|------|----|
| Erreurs des Edge Functions | tableau de bord Supabase → Edge Functions → Logs (aucun contenu utilisateur n'y figure, seulement des types d'erreur et références) |
| Remboursements en échec | journaux contenant `refund failed` (référence de la tentative) : recréditer à la main si besoin |
| Consommation IA et coûts | console Anthropic |
| Achats, abonnements, remboursements | tableau de bord RevenueCat |
| Revenus publicitaires | AdMob |
| Base (taille, requêtes lentes) | tableau de bord Supabase → Reports |

## Modérer les signalements

Tableau de bord Supabase → Table Editor → `reports` (texte signalé, motif, date). Les lignes
disparaissent avec le compte de leur auteur. Un motif récurrent sur un même type de demande
indique qu'il faut renforcer les consignes du modèle (`generate/prompt.ts`,
`screenshot-reply/screenshot.ts`, `respect-check/respect.ts` ou
`conversation-analysis/analysis.ts`, dans `supabase/functions/`), puis redéployer.

## Mettre à jour les textes légaux en ligne

La politique de confidentialité et les conditions sont publiées sur GitHub Pages
(https://kelenix.github.io/Flirt-Coach/), depuis la branche `gh-pages`. La source reste
`assets/legal/*.txt`, pour que l'app et le site affichent le même texte.

1. Modifier le texte dans `assets/legal/` (et la date « Dernière mise à jour »).
2. Générer les pages (lit l'éditeur et le contact dans `config/prod.json`) :

   ```powershell
   python scripts/legal_pages.py
   ```

3. Publier le contenu de `build/legal-pages/` sur `gh-pages` :

   ```powershell
   git worktree add ..\flirt-coach-legal gh-pages
   ```

   ```powershell
   Copy-Item build\legal-pages\* ..\flirt-coach-legal -Force; git -C ..\flirt-coach-legal add -A; git -C ..\flirt-coach-legal commit -m "Textes légaux : mise à jour"; git -C ..\flirt-coach-legal push
   ```

   ```powershell
   git worktree remove ..\flirt-coach-legal
   ```

4. Publier aussi une nouvelle version de l'app, qui embarque le texte.

## Incidents fréquents

| Symptôme | Cause probable | Action |
|----------|----------------|--------|
| Toutes les générations répondent « coach indisponible » | clé IA absente, invalide ou quota Anthropic atteint | `supabase secrets list` ; console Anthropic ; journaux des fonctions |
| « Configuration manquante » au lancement | app compilée sans `--dart-define-from-file` | recompiler avec le bon fichier `config/*.json` |
| Achat validé mais pas de Premium | webhook non configuré, secret différent, événement sandbox ignoré | RevenueCat → Webhooks : réponse de chaque envoi (`ignored` et son motif, ex. `sandbox`) ; journaux Supabase : code HTTP seul (401 = secret différent) |
| Premium perdu après un changement de téléphone | « Restaurer mes achats » pas fait, ou ancien abonnement inconnu du serveur (réponse `nothing_to_transfer`) | [rétablir Premium](#rétablir-premium-après-un-changement-de-téléphone) |
| Vidéo vue mais pas de crédits | rappel SSV non configuré ou bloc absent de `ADMOB_AD_UNIT_IDS` | journaux de `admob-ssv` : code 403 (signature invalide ou bloc non autorisé, sans distinction) ; vérifier la configuration SSV et `ADMOB_AD_UNIT_IDS` |
| Personne ne peut entrer dans l'app | connexion anonyme désactivée | Authentication → Sign In / Providers → *Allow anonymous sign-ins* |
| Build release bloqué (« fichier utilisé par un autre processus ») | démon Gradle resté actif | `android\gradlew.bat --stop`, puis recompiler |

## Rétablir Premium après un changement de téléphone

Cas normal, automatique : sur le nouveau téléphone, l'utilisateur touche « Restaurer mes
achats » ; RevenueCat rattache l'abonnement au nouveau compte anonyme et envoie un événement
`TRANSFER` ; le webhook déplace le droit Premium (réponse `premium_transferred`).

Si la réponse est `nothing_to_transfer` (le serveur ne connaissait aucun abonnement actif pour
l'ancien compte, par exemple après un webhook manqué ou un compte supprimé), le rétablir à la
main :

1. Demander à l'utilisateur le numéro de commande du store (« GPA.… » chez Google).
2. RevenueCat → rechercher la transaction → fiche du client : l'événement `TRANSFER` indique le
   nouvel identifiant (un UUID, celui du compte Supabase de la nouvelle installation), le produit
   et l'échéance de l'abonnement.
3. Tableau de bord Supabase → SQL Editor, en remplaçant les trois valeurs :

   ```sql
   select public.set_premium('<nouvel identifiant>', true, '<produit>', '<échéance ISO 8601>');
   ```

4. Demander à l'utilisateur de rouvrir l'app : « Premium » apparaît dans le badge de crédits.

## Code d'accès Premium (revue des stores)

Les testeurs de Google et d'Apple n'ont le droit ni d'acheter ni d'utiliser un essai gratuit.
Dans l'app, Réglages → « J'ai un code » donne Premium pendant 30 jours (ADR-031).

- **Où est le code** : en commentaire dans `supabase/functions/.env.cloud` (non versionné).
  Le serveur n'en connaît que l'empreinte (`REVIEW_ACCESS_CODE_SHA256`).
- **Où le donner** : Play Console → Contenuti app → Dettagli di accesso, champ *Password*
  (instructions en anglais : [fiche du store](store/fiche-store.md), section 6). Pour Apple :
  notes de revue d'App Store Connect.
- **Suivre les activations** (SQL Editor) :
  `select count(*) from public.access_code_redemptions;`
- **Changer le code** (divulgué, ou plafond de 20 atteint) :
  1. Générer 16 caractères aléatoires parmi `ABCDEFGHJKMNPQRSTVWXYZ23456789`.
  2. Calculer l'empreinte SHA-256 du code en majuscules, sans tirets.
  3. `supabase secrets set REVIEW_ACCESS_CODE_SHA256=<empreinte>`.
  4. Mettre le nouveau code dans `.env.cloud` et dans la Play Console.

  L'ancien code cesse aussitôt de fonctionner. Les accès déjà donnés vont jusqu'à leur terme.
- **Désactiver** : `supabase secrets unset REVIEW_ACCESS_CODE_SHA256` ; plus aucun code n'est
  accepté.

## Tests des Edge Functions

Sans installer Deno, depuis la racine du projet (Docker démarré), pour une fonction :

```powershell
docker run --rm -v "${PWD}/supabase/functions:/fn" -w /fn/generate denoland/deno:2.9.8 test --allow-env .
```

Remplacer `generate` par `respect-check`, `screenshot-reply`, `conversation-analysis`,
`revenuecat-webhook` ou `admob-ssv`. La CI (`.github/workflows/ci.yml`) lance le format, le lint,
la vérification de types et les tests de toutes les fonctions.

## Sauvegardes

Les sauvegardes dépendent du plan Supabase choisi (voir la page des tarifs Supabase). Avant la
publication, choisir un plan avec sauvegardes quotidiennes des données (tâche manuelle 1). Le
schéma, lui, est entièrement reconstructible depuis les migrations du dépôt.
