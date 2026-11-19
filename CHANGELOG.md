# Journal des modifications

Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) ·
versions : [SemVer](https://semver.org/lang/fr/).

## [Non publié]

Rien pour l'instant.

## [1.0.0] — en préparation (non publiée)

Première version complète de Flirt Coach.

### Ajouté

- **Accueil 18+** : confirmation d'âge obligatoire, session anonyme sans inscription, liens vers la
  politique de confidentialité et les conditions d'utilisation.
- **Génération de messages** : 3 réponses prêtes à copier, 7 situations, 7 styles (Classique
  gratuit, les autres en Premium), contexte facultatif ; réponses dans la langue de la conversation.
- **Capture d'écran** : 3 réponses à partir d'une capture de conversation, jamais conservée.
- **Mode Respect** : vérifie si un message est insistant, sexualisé ou manipulateur, et propose
  une version respectueuse.
- **Analyse de conversation** (Premium) : dynamique de l'échange, prochaine étape, idée de
  rendez-vous quand le contexte s'y prête.
- **Banque de messages** : 40 messages dans 5 catégories, consultable hors connexion.
- **Historique** (Premium) : générations passées, copie, suppression à l'unité.
- **Crédits et Premium** : 5 crédits gratuits par jour, packs de 20/50/100 crédits, abonnements
  hebdomadaire, mensuel et annuel, écran d'offre annuelle présenté une fois à J+3, restauration
  des achats, y compris sur un nouveau téléphone (l'abonnement suit le compte store).
- **Publicités** (version gratuite) : consentement RGPD, bannière discrète, vidéo facultative
  donnant 2 crédits (5 par jour).
- **Confiance** : signalement d'une réponse, réglages, préférences publicitaires, suppression
  définitive du compte, aide et questions fréquentes dans l'app.
- Identité visuelle du kit de marque néon (logo, icône, écrans, icônes au trait).

### Sécurité

- Données protégées par RLS ; crédits, Premium et récompenses décidés uniquement par le serveur.
- Quotas d'appels IA comptés avant l'appel : 10 par minute, 100 par jour.
- Achats de test ignorés en production ; packs remboursés repris ; rappels publicitaires limités
  aux blocs de l'éditeur ; signalements vérifiés.

### Qualité

- 117 tests de l'app, 110 tests de la base, 51 tests serveur, un parcours de bout en bout sur
  appareil ; écrans principaux conformes aux recommandations d'accessibilité.
- Démarrage en moins de 2 s ; APK de 24 Mo par architecture.
