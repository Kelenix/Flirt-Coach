# Registre des risques — Flirt Coach Pro

> Phase 2 — Project Manager. P = probabilité, I = impact (1 faible → 3 fort). 🔴 = P×I ≥ 6.

| # | Risque | P | I | | Parade |
|---|--------|---|---|---|--------|
| R1 | Rejet store : appli IA + séduction, public 18+ | 2 | 3 | 🔴 | Classification adulte, signalement in-app (US-07), modération serveur, aucune promesse de résultat, suppression de compte, mentions d'abonnement conformes |
| R2 | Coût IA supérieur aux revenus (abus, Premium « illimité ») | 2 | 3 | 🔴 | Quotas serveur, plafond 100/jour Premium, modèle rapide, longueur d'entrée bornée, 1 seul appel par génération |
| R3 | Fraude aux crédits / faux Premium | 2 | 3 | 🔴 | Ledger serveur, RLS lecture seule, achats et récompenses validés serveur |
| R4 | Données de tiers dans les captures (RGPD) | 2 | 3 | 🔴 | Non-conservation (ADR-006), politique claire, relecture juridique (tâche manuelle 10) |
| R5 | Contenu généré inapproprié malgré les consignes | 2 | 3 | 🔴 | Règles dans le prompt système, sortie structurée validée, refus sans débit, signalement, jeux de tests d'abus |
| R6 | Injection de prompt via message collé ou capture | 3 | 2 | 🔴 | Contenu utilisateur isolé comme donnée, schéma de sortie strict, aucun outil ni accès donné au modèle |
| R7 | Docker absent du poste → base locale indisponible | 3 | 2 | 🔴 | Tâche manuelle 0 ; en attendant, code et migrations écrits et testés sans base (tests unitaires/widgets), vérification base dès Docker installé |
| R8 | Build iOS impossible sous Windows | 3 | 2 | 🔴 | Runner macOS GitHub Actions ; vérification manuelle iOS reportée à la phase 6 |
| R9 | Plugin natif non compatible (achats, pubs) | 1 | 2 | | Plugins officiels/maintenus, versions vérifiées à l'installation |
| R10 | Comptes stores / AdMob / RevenueCat créés trop tard | 2 | 2 | | Listés dès maintenant dans `manual-tasks.md` ; Inc-5 et Inc-6 développés derrière des interfaces testables sans compte |
| R11 | Logo/icône indisponibles en fichiers sources | 2 | 1 | | Redessin vectoriel d'après le kit |

## Chemin critique

Docker (R7) → Inc-0/Inc-1 vérifiés de bout en bout → clé IA (tâche 2) → Inc-1 réel.
Comptes stores + RevenueCat → Inc-5. AdMob → Inc-6. Hébergement des textes légaux → publication.
