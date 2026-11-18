# Performance — Flirt Coach

Mesures de la phase 5 (2026-11-18). Appareil : émulateur Android 15, x86_64, GPU émulé,
mode **profile**. Un émulateur n'est pas représentatif d'un téléphone modeste : les chiffres
de rendu graphique sont à confirmer sur appareil réel (commande en bas de page).

## Budgets (skill 11)

| Mesure | Budget | Résultat | État |
|--------|--------|----------|------|
| Démarrage à froid (jusqu'au premier affichage) | < 2 s | 1,75–1,90 s (5 essais) | ✅ juste |
| Construction d'une image (code Flutter) | < 16,7 ms | moyenne 2,1 ms · 90ᵉ c. 3,6 ms · 99ᵉ c. 18 ms | ✅ |
| Rendu graphique d'une image | < 16,7 ms | moyenne 8,6 ms · 90ᵉ c. 17 ms · 17 % hors budget | ⚠️ GPU émulé : à mesurer sur téléphone |
| Mémoire (PSS, après navigation) | stable | ~218 Mo (émulateur, rendu Impeller inclus) | ✅ stable, à confirmer sur téléphone |
| Requêtes | pas de N+1, listes paginées | une requête par écran ; historique paginé par 20 ; banque en une requête + copie locale | ✅ |

## Démarrage : où part le temps

Instrumentation temporaire de `main()` (retirée ensuite) :

- code Dart de démarrage (préférences, lecture de session) : ~100 ms ;
- ~600 ms d'attente du **premier échange avec la partie Android** (enregistrement des
  plugins natifs : publicité, achats, stockage sécurisé), quel que soit l'appel qui le
  déclenche en premier ;
- le reste (~1 s) : démarrage du moteur Flutter sur l'émulateur.

Décision : pas d'optimisation du code de démarrage (gain non mesurable). L'écran de lancement
Android est passé au fond du kit (`#1A1033`) : plus de flash blanc avant le premier écran.

## Optimisations appliquées

| Optimisation | Avant | Après |
|--------------|-------|-------|
| `logo_horizontal_dark.png` retiré du paquet (inutilisé) | 0,76 Mo embarqués | 0 |
| Symbole du logo redimensionné à sa taille d'affichage max (128 dp × 3) | 716 px, 318 Ko | 400 px, 117 Ko |
| Wordmark redimensionné (260 dp × 3) | 1454 px, 283 Ko | 800 px, 123 Ko |
| Écran de lancement Android au fond du kit (Android 5 à 15) | blanc | `#1A1033` |

Décodage mémoire des logos : ~4,4 Mo → ~1,6 Mo.

## Taille de l'application

| Paquet | Taille |
|--------|--------|
| APK release universel ARM (2 architectures) | 41 Mo |
| APK release arm64 seul (ce que télécharge un téléphone récent via le Play Store) | 24,4 Mo |
| APK release armeabi-v7a seul (anciens téléphones 32 bits) | 22,3 Mo |

Le Play Store distribue un **App Bundle** (`flutter build appbundle`) : chaque téléphone ne
télécharge que son architecture. Postes principaux : moteur Flutter (~11 Mo arm64), code de
l'app compilé (~7 Mo), code Java/Kotlin des SDK (pub, achats : ~3,5 Mo).

## Mesurer sur ton téléphone

Téléphone branché en USB, débogage USB activé :

```powershell
flutter drive --profile --no-dds -d <id-du-téléphone> --driver=test_driver/integration_test.dart --target=integration_test/parcours_test.dart
```

Les mesures sont écrites dans `build/performance.json` (clé `parcours_principal`).
Seuils à viser : 90ᵉ centile de rendu < 16,7 ms et moins de 5 % d'images hors budget.
Si ce n'est pas le cas, pistes par ordre de coût : `RepaintBoundary` autour de la vague de
l'accueil, ombres floues des cartes et du bouton principal allégées.
