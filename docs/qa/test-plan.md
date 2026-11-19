# Plan de test — Flirt Coach

État au 2026-11-18 (fin de phase 5). Tout est automatisé et lancé par la CI
(`.github/workflows/ci.yml`), sauf le test sur appareil (émulateur ou téléphone).

## Vue d'ensemble

| Niveau | Outil | Nombre | Lancement |
|--------|-------|--------|-----------|
| Base de données (RLS, crédits, quotas, achats, récompenses, historique, signalements, banque, transfert d'abonnement) | pgTAP | 110 | `supabase test db` |
| Edge Functions (validation, consignes IA, lecture des sorties, webhooks, rappels AdMob) | Deno | 51 | `deno test --allow-env` dans chaque fonction |
| App : logique, lecture des réponses serveur, écrans, parcours | flutter_test | 117 (accessibilité comprise) | `flutter test` |
| App : accessibilité (cibles tactiles Android/iOS, libellés, contraste) | flutter_test (guidelines) | 7 écrans | inclus dans `flutter test` |
| Bout en bout sur appareil + mesure de fluidité | integration_test | 1 parcours | `flutter drive --profile --no-dds …` (voir `docs/performance.md`) |

## Couverture par risque

| Risque | Couvert par |
|--------|-------------|
| Crédits accordés sans payer, double dépense, double crédit | `credits_test`, `usage_limits_test`, `purchases_test`, `ad_rewards_test`, `pack_refund_test` (SQL) ; `revenuecat_test`, `ssv_test` (Deno) |
| Accès aux données d'un autre utilisateur | `profiles_rls_test`, `history_test`, `reports_test`, `message_bank_test` (SQL) |
| Contenu IA inadapté, injection de consignes | tests de consignes et de lecture des sorties (Deno) ; refus affichés (Flutter) |
| Parcours utilisateur (18+, génération, Respect, analyse, capture, banque, historique, achats, pubs, réglages, suppression du compte) | `test/features/**` |
| Hors-ligne | banque (copie locale, délai 6 s), erreurs réseau + « Réessayer » (historique, banque, génération) |
| Régressions de la revue phase 5 | `test/features/phase5_regressions_test.dart` (C1 à C10) |
| Lecture des réponses serveur (chemin des paiements) | `test/core/server_responses_test.dart` |
| Accessibilité | `test/accessibility_test.dart` |
| Petits écrans / grande police | tests dédiés (accueil, Générer) |

## Ce qui n'est pas automatisé

- **Achats réels** (sandbox stores) et **vraie récompense publicitaire** : nécessitent les comptes
  RevenueCat / AdMob / stores (tâches manuelles 4 à 8, 14).
- **iOS** : aucun test sur appareil Apple (pas de Mac) ; à faire via la CI macOS (tâche 9).
- **Mesures de fluidité sur téléphone réel** : commande prête dans `docs/performance.md`.

## Règle

Tout défaut trouvé reçoit d'abord un test qui le reproduit, puis la correction
(cf. `phase5_regressions_test.dart`, `reports_test.sql` pour le contrôle `NULL`).
