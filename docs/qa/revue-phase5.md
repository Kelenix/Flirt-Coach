# Revue de la phase 5 — Qualité & performance

Deux relectures indépendantes (sécurité serveur + app, code Flutter), vérifiées dans le code
avant correction. Mesures de performance sur émulateur Android (x86_64, mode profile).

Légende : ✅ corrigé · ⏸️ reporté (raison) · ❓ décision du propriétaire du produit.

## Sécurité (serveur et app)

| # | Gravité | Constat | Décision |
|---|---------|---------|----------|
| S1 | Important | Plafond Premium (100/jour) contournable par requêtes simultanées : il comptait les générations enregistrées, insérées après l'appel IA | ✅ table `ai_usage` : chaque tentative est comptée sous verrou, avant l'appel |
| S2 | Important | Appels IA illimités sans payer : refus et captures illisibles remboursés, aucune limite de débit | ✅ limites par utilisateur : 10 appels/minute, 30 tentatives/jour en gratuit |
| S3 | Important | Comptes anonymes créés en série = 5 crédits gratuits chacun (CAPTCHA désactivé) | ❓ CAPTCHA ou attestation d'appareil : décision et comptes à créer |
| S4 | Important | Webhook RevenueCat : achats « sandbox » acceptés comme réels | ✅ ignorés sauf `REVENUECAT_ALLOW_SANDBOX=true` (phase de test) |
| S5 | Important | Pack de crédits remboursé jamais repris | ✅ reprise du solde bonus (au plus le montant du pack), idempotente — remplace ADR-017 sur ce point |
| S6 | Important | Rappel AdMob : bloc d'annonces non vérifié (un autre bloc pouvait créditer) | ✅ liste autorisée `ADMOB_AD_UNIT_IDS` |
| S7 | Mineur | Signalements : texte libre, nombre illimité | ✅ le texte doit venir de la génération ; 20 par jour |
| S8 | Mineur | Échec de remboursement non journalisé | ✅ journalisé (type d'erreur seulement) |
| S9 | Mineur | admob-ssv : rechargement des clés Google forçable | ✅ au plus une fois par minute, `key_id` numérique |
| S10 | Mineur | `refund_credits` lit la date du remboursement, pas du débit | ⏸️ effet rare et faible (crédits du jour rendus le lendemain) |
| S11 | Mineur, incertain | Événement RevenueCat tardif après remboursement | ⏸️ à traiter avec la mise en place réelle de RevenueCat |
| S12 | Important avant publication | Événement `TRANSFER` (réinstallation + « Restaurer ») ignoré | ⏸️ nécessite la clé secrète RevenueCat (tâche 14) : à faire en phase 6 |

## Code de l'app

| # | Gravité | Constat | Décision |
|---|---------|---------|----------|
| C1 | Important | Après une erreur, Générer rouvre les propositions précédentes (autre conversation) ; verdict/analyse précédents restent affichés | ✅ |
| C2 | Important | Après suppression du compte, le portefeuille de l'ancien compte reste affiché | ✅ relu après création de la nouvelle session |
| C3 | Important | Portefeuille jamais relu (crédits du jour invisibles sans relancer l'app ; hors-ligne sans « Réessayer ») | ✅ relu au retour dans l'app ; erreur + Réessayer |
| C4 | Important | Paywall : 2 achats identiques consécutifs, pas de confirmation | ✅ |
| C5 | Mineur | Aucun délai maximal sur les appels serveur | ✅ |
| C6 | Mineur | Capture importée depuis le menu ignorée hors « Répondre » | ✅ bascule sur « Répondre » |
| C7 | Mineur | Lecture des réponses serveur fragile (valeur inconnue = « erreur inattendue » après débit ; verdict Respect déduit à tort) | ✅ lecture tolérante, verdict lu du serveur |
| C8 | Mineur | Consentement publicitaire demandé aux Premium | ✅ seulement pour les gratuits |
| C9 | Mineur | Historique : entrée supprimée qui réapparaît ; égalité d'horodatage | ✅ |
| C10 | Mineur | Double tap = double appel | ✅ garde dans les contrôleurs |
| C11 | Mineur, incertain | Session perdue sans retour à l'accueil | ⏸️ cas non reproduit |
| C12 | Mineur | Page légale : chargement relancé à chaque affichage, erreur ignorée | ✅ |
| C13 | Mineur | Erreurs inattendues jamais journalisées | ✅ type d'erreur journalisé |
| C14 | Mineur | Architecture : interfaces dans `data/`, provider dans un écran | ✅ ; `failureMessage` dans `core` : ⏸️ (déplacement sans gain fonctionnel) |
| C15 | Mineur | Pastille de crédits < 48 dp ; guillemets en dur | ✅ |
| C16 | Suggestion | Duplication (actions de contrôleur, barres de message) | ✅ helpers communs |
| C17 | Tests | Couche data non testée (lecture JSON, codes d'erreur) | ✅ fonctions de lecture extraites et testées |

## Accessibilité (tests automatiques ajoutés)

| # | Constat | Décision |
|---|---------|----------|
| A1 | Texte blanc des boutons roses : contraste 3,5 (4,5 requis pour du texte normal) | ✅ libellés de boutons en gras (Poppins Bold) : « gros texte » WCAG, seuil 3:1 ; couleurs du kit inchangées |
| A2 | Style sélectionné (« Classique ») : contraste 4,2 | ✅ idem, en gras |

## Performance

Voir `docs/performance.md`.

## Constat en cours de correction

| # | Constat | Décision |
|---|---------|----------|
| R1 | Ma première version du contrôle des signalements laissait passer n'importe quel texte quand un champ était absent (logique `NULL` SQL) | ✅ trouvé par le test, corrigé (`coalesce`) avant tout déploiement |
