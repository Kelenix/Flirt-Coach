# Sécurité — Flirt Coach

État après la revue indépendante de la phase 5 (2026-11-18). Détail des constats et de leur
traitement : `docs/qa/revue-phase5.md`.

## Principes

- **Le serveur fait foi** : crédits, Premium, récompenses et quotas ne sont décidés que côté
  serveur (Edge Functions + fonctions SQL `security definer`). L'app n'accorde jamais rien.
- **RLS partout** : toutes les tables ont la RLS active ; aucune règle d'écriture côté client.
  Les fonctions qui prennent un utilisateur en paramètre sont réservées au `service_role` ;
  celles appelables par l'app ne lisent que `auth.uid()`.
- **Aucun secret dans l'app** : seulement l'URL Supabase, la clé publishable et les clés
  publiques RevenueCat / identifiants AdMob. Clé IA, `service_role` et secrets de webhook
  vivent dans les secrets des Edge Functions.
- **Session** dans le Keychain (iOS) / Keystore (Android) via `flutter_secure_storage`.

## Menaces et mesures

| Menace | Mesure |
|--------|--------|
| S'accorder crédits ou Premium | Écritures uniquement par fonctions serveur ; tests SQL « le client ne peut pas… » |
| Rejouer un achat ou une récompense | Référence unique par transaction (`ON CONFLICT`) ; webhook et rappel AdMob idempotents |
| Achat de test (sandbox) pris pour un vrai | Ignoré, sauf `REVENUECAT_ALLOW_SANDBOX=true` pendant la phase de test |
| Pack de crédits remboursé | Crédits restants repris (au plus le montant du pack) |
| Faux rappel AdMob (bloc d'un autre éditeur) | Signature ECDSA vérifiée + liste `ADMOB_AD_UNIT_IDS` |
| Appels IA sans payer (refus, captures illisibles remboursés), requêtes simultanées | Chaque tentative comptée sous verrou avant l'appel : 10 par minute, 100 par jour |
| Webhook RevenueCat forgé | Secret partagé comparé en temps constant |
| Injection de consignes dans le message ou la capture | Données balisées, sortie contrainte par schéma JSON, aucun outil ; aucune donnée d'un autre utilisateur dans le contexte |
| Lecture des données d'un autre utilisateur | RLS ; historique lisible seulement par son auteur Premium |
| Faux signalements / inondation de la modération | Texte vérifié dans la génération ; 20 signalements par jour |
| Fuite de données dans les journaux | Journaux sans contenu utilisateur (type d'erreur, référence technique) |
| Trafic intercepté | HTTPS uniquement en release (trafic en clair autorisé seulement en debug/profile pour le serveur local) |
| Compte supprimé, rappels de paiement ensuite | Ignorés proprement (200 `unknown_user`) au lieu d'être rejoués sans fin |

## Risques résiduels (décision ou action requise)

| Risque | Statut |
|--------|--------|
| **Création en série de comptes anonymes** (5 crédits gratuits chacun) | ❓ décision : CAPTCHA (Turnstile / hCaptcha) ou attestation d'appareil (Play Integrity / App Attest). Limite actuelle : celle de Supabase par adresse IP |
| Événement RevenueCat `TRANSFER` (réinstallation + « Restaurer ») | ⏸️ à traiter avec la mise en place réelle de RevenueCat (clé secrète requise) — avant publication |
| Événement RevenueCat tardif après remboursement | ⏸️ idem |
| Pinning de certificat | Non retenu : pas de données bancaires, HTTPS + RLS suffisent ; complexité de rotation |

## Permissions et déclarations des stores

- Android : seulement `INTERNET`. Sélecteur de photos du système pour les captures (aucune
  permission permanente sur la galerie).
- Données à déclarer (Google Play « Sécurité des données » / Apple « App Privacy ») :
  identifiant de compte anonyme ; contenu saisi par l'utilisateur (messages, captures traitées
  puis non conservées) ; historique d'achats ; données publicitaires (AdMob, version gratuite,
  avec consentement) ; aucun partage à des fins de revente. À reprendre dans la phase 6.
