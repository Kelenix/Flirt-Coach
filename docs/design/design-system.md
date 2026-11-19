# Design system — Flirt Coach Pro

> Phase 3 — UI/UX. Source : `Kit di brand Flirt Coach in stile neon.png` (ADR-010).
> Toutes ces valeurs vivent dans `lib/core/theme/` ; aucune valeur visuelle en dur ailleurs.

## Couleurs

| Token | Valeur | Usage |
|-------|--------|-------|
| `primary` | `#FF4D79` | Actions, CTA |
| `secondary` | `#9B5CFF` | Accents, icônes, sélection |
| `background` | `#1A1033` | Fond principal (sombre) |
| `surfaceTint` | `#FFD6E6` | Cartes et sections claires |
| `surface` | `#F8F8FC` | Cartes de résultat, champs |
| `onDark` | `#FFFFFF` | Texte sur fond sombre |
| `onLight` | `#1A1033` | Texte sur surface claire |
| `card` | `#2A1D4A` | Panneaux sur fond sombre (dérivé du fond) |
| `error` | `#FF6B6B` | Erreurs |

Dégradé de marque : `primary → secondary` (logo, halo d'arrière-plan). Les CTA sont en
`primary` plein.

**Thème unique sombre** : le kit ne définit qu'une identité néon sur fond sombre ; pas de
thème clair en V1 (ADR-012).

**Contraste (WCAG)** : blanc sur `#1A1033` ≈ 17:1 ✔ ; `#1A1033` sur `#F8F8FC` ≈ 16:1 ✔.
Blanc sur `#FF4D79` ≈ 3,2:1 : conforme AA pour texte large/gras uniquement → libellés de
bouton en Poppins SemiBold 16 minimum ; jamais de petit texte blanc sur rose.

## Typographie

| Rôle | Police | Graisse | Taille |
|------|--------|---------|--------|
| Titre d'écran | Poppins | Bold | 28 |
| Titre de section | Poppins | SemiBold | 20 |
| Bouton | Poppins | SemiBold | 16 |
| Corps | Inter | Regular | 16 |
| Corps secondaire | Inter | Regular | 14 |
| Libellé / légende | Inter | Medium | 12 |

Polices embarquées (`assets/fonts/`), tailles suivant le réglage système de l'utilisateur.

## Espacements, rayons

Grille de 4 : `xs 4 · sm 8 · md 16 · lg 24 · xl 32`. Rayons : champ/carte `16`, bouton
pilule `28`, puce de style `20`. Marge d'écran horizontale `24`. Zones tactiles ≥ 48 dp.

## Composants

| Composant | Variantes / états |
|-----------|-------------------|
| `PrimaryButton` | dégradé rose + ombre ; icône optionnelle ; désactivé ; chargement |
| `SecondaryButton` | contour violet sur fond clair (« Passer Premium ») |
| `TonalButton` | fond lavande, icône (« Regarder une pub (+2 crédits) ») |
| `StyleSelector` | grille 2 colonnes ; sélectionné = dégradé violet + bord rose ; verrouillé = cadenas |
| `CopyableTextCard` | carte claire, émoji, « Réponse n », bouton Copier |
| `CreditsBadge` | pastille vitrée, pièces dorées ; couronne pour Premium |
| `BrandLogo` / `BrandWordmark` | bulle + cœur + étincelles ; « Flirt Coach » blanc/rose |
| `BrandCheckItem` | coche rose arrondie + texte |
| `BrandWave` | rubans ondulés violet → rose (accueil) |
| `GradientBackground` | fond sombre + halo dégradé |
| Menu (`showFeatureMenu`) | feuille du bas violette, tuiles icône + libellé |

Icônes : Lucide au trait (`AppIcons`), jamais d'icônes Material pleines.

## États d'écran

Chaque écran gère : chargement (indicateur dans le bouton ou squelette), vide, erreur
(`ErrorView`), succès. Hors-ligne = état d'erreur « Pas de connexion ».

## Accessibilité

Libellés `Semantics` sur les icônes seules (copier, signaler, cadenas) ; ordre de lecture
logique ; aucun contenu porté par la couleur seule (le cadenas double la couleur) ;
animations coupées si l'utilisateur a activé « réduire les animations ».

## Ton des textes

Tutoiement, phrases courtes, complice sans vulgarité. Textes centralisés dans
`lib/l10n/app_fr.arb` (français seul en V1, structure prête pour d'autres langues).
