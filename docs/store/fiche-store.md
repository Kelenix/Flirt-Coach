# Fiche store — Google Play et App Store

Textes prêts à copier dans la Play Console et App Store Connect pour la version 1.0 (français).
Les longueurs indiquées sont les limites des stores ; chaque texte les respecte.

> À compléter avant soumission : `{{URL_CONFIDENTIALITE}}`, `{{URL_CONDITIONS}}` (tâche
> manuelle 10) et `{{EMAIL_SUPPORT}}` (tâche manuelle 12). Le nom définitif dépend de la tâche
> manuelle 3.

## 1. Identité

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach |
| Sous-titre | App Store | 30 | Coach de drague et messages |
| Description courte | Google Play | 80 | Trouve les bons mots pour flirter avec respect : 3 réponses en un instant. |
| Texte promotionnel | App Store | 170 | Colle un message ou importe une capture : ton coach te propose 3 réponses naturelles, dans ton style. 5 crédits offerts chaque jour. |

## 2. Description longue (les deux stores, 4 000 caractères au plus)

```text
Tu ne sais pas quoi répondre ? Flirt Coach te propose les bons mots, en quelques secondes.

Colle le dernier message reçu, choisis la situation et le style : ton coach te propose 3 réponses naturelles, prêtes à copier. Tu restes libre de les modifier avant de les envoyer.

POUR CHAQUE MOMENT DE LA CONVERSATION
• Répondre à un message
• Démarrer une conversation après un match
• Flirter, relancer une conversation qui s'essouffle
• Préparer un rendez-vous
• S'excuser, ou rompre en douceur

7 STYLES POUR TE RESSEMBLER
Classique, Drôle, Romantique, Mystérieux, Direct, Élégant, Provocateur léger.

RÉPONDRE À PARTIR D'UNE CAPTURE D'ÉCRAN
Importe une capture de la conversation : le coach la lit et propose une réponse adaptée. Ta capture n'est jamais conservée.

MODE RESPECT
Avant d'envoyer, vérifie que ton message n'est ni trop insistant, ni trop sexualisé, ni manipulateur. Le coach t'explique pourquoi et te propose une version plus respectueuse.

ANALYSE DE CONVERSATION
Découvre si votre échange progresse, stagne ou recule, la prochaine étape à suivre, et le bon moment pour proposer un rendez-vous.

ET AUSSI
• Une banque de messages gratuite, disponible même hors connexion
• L'historique de tes messages générés
• Les réponses dans la langue de ta conversation

SANS INSCRIPTION
Ni nom, ni e-mail. Tu peux supprimer ton compte et toutes tes données à tout moment, depuis les réglages.

GRATUIT, OU PREMIUM
• Gratuit : 5 crédits chaque jour, la banque de messages, et des crédits en regardant une courte vidéo.
• Packs de crédits, sans abonnement et sans date d'expiration.
• Premium : les 7 styles, la capture d'écran, le Mode Respect et l'analyse inclus, l'historique, sans publicité, jusqu'à 100 messages par jour.

Abonnements Premium hebdomadaire, mensuel ou annuel, renouvelés automatiquement au prix indiqué dans l'app, sauf résiliation au moins 24 h avant la fin de la période en cours, depuis les réglages de ton compte Google Play ou App Store. Le paiement est débité sur ton compte à la confirmation de l'achat.

Flirt Coach est réservé aux personnes de 18 ans et plus. Les réponses sont des suggestions générées par intelligence artificielle : aucun résultat n'est garanti.

Politique de confidentialité : {{URL_CONFIDENTIALITE}}
Conditions d'utilisation : {{URL_CONDITIONS}}
```

## 3. Mots-clés (App Store, 100 caractères au plus)

```text
drague,séduction,séduire,message,rencontre,rendez-vous,conversation,réponse,IA,match,charme,amour
```

Sans espace après les virgules ; le nom de l'app et la catégorie sont déjà indexés et n'y
figurent pas. **Ne jamais y mettre le nom d'une autre app** (motif de refus Apple).

## 4. Notes de version 1.0

```text
Bienvenue dans Flirt Coach !
• 3 réponses prêtes à copier, pour 7 situations et dans 7 styles
• Réponses à partir d'une capture d'écran
• Mode Respect : vérifie ton message avant de l'envoyer
• Analyse de conversation et historique avec Premium
• Banque de messages gratuite, même hors connexion
```

Pour les versions suivantes : partir de la section correspondante du
[journal des modifications](../../CHANGELOG.md), en ne gardant que ce qui change pour
l'utilisateur, formulé en bénéfice (« Les réponses arrivent plus vite »), sans jargon.

## 5. Captures d'écran

Ordre et accroche à incruster au-dessus de chaque capture (fond du kit de marque, titres en
Poppins) :

| # | Écran | Accroche |
|---|-------|----------|
| 1 | Résultats | Trouve les bons mots |
| 2 | Générer un message | 7 situations, 7 styles |
| 3 | Capture d'écran importée | Réponds à partir d'une capture |
| 4 | Mode Respect (« À revoir ») | Flirte avec respect |
| 5 | Analyse de conversation | Sache où vous en êtes |
| 6 | Banque de messages | Des idées, même hors connexion |

Les captures de `docs/guide/images/` illustrent le guide mais sont trop petites pour les stores.
Formats à produire : Google Play, téléphone, 1080 × 1920 px au moins ; App Store, iPhone 6,9"
(1320 × 2868 px) — vérifier les formats exigés dans chaque console au moment de la soumission.
Utiliser des conversations fictives, sans nom ni photo de personne réelle.

## 6. Catégorie, public et classification

| Champ | Google Play | App Store |
|-------|-------------|-----------|
| Catégorie | Style de vie | Style de vie (secondaire : Réseaux sociaux) |
| Public cible | 18 ans et plus uniquement (section « Public cible et contenu ») | — |
| Classification | questionnaire IARC : thèmes romantiques, pas de nudité ni de contenu sexuel explicite ; contenu généré par IA | questionnaire d'âge : choisir la tranche la plus élevée proposée (18+) |
| Annonces | « Contient des annonces » : oui | — |
| Achats intégrés | oui | oui |
| Coordonnées | `{{EMAIL_SUPPORT}}` | URL d'assistance (page web avec `{{EMAIL_SUPPORT}}`) |
| Politique de confidentialité | `{{URL_CONFIDENTIALITE}}` | `{{URL_CONFIDENTIALITE}}` |
| Conditions (CLUF) | — | `{{URL_CONDITIONS}}` dans la description (obligatoire avec un abonnement) |

**Contenu généré par IA** (règles Google Play) : l'app permet de signaler une réponse (drapeau
sur chaque proposition) et filtre les contenus interdits côté serveur ; le mentionner si la
console le demande.

## 7. Déclarations de confidentialité (à faire valider avec la tâche manuelle 10)

| Donnée | Collectée | Finalité | Liée à l'utilisateur | Partagée |
|--------|-----------|----------|----------------------|----------|
| Identifiant utilisateur (anonyme) | oui | fonctionnement de l'app | oui | non |
| Messages saisis et réponses (historique) | oui | fonctionnement de l'app | oui | non (traités par le fournisseur d'IA pour le compte de l'éditeur) |
| Captures d'écran | traitées, **non conservées** | fonctionnement de l'app | — | non (traitement éphémère) |
| Historique d'achats | oui | fonctionnement de l'app (droits Premium, crédits) | oui | non |
| Identifiant publicitaire, interactions avec les annonces | oui, version gratuite | publicité (AdMob) | selon le consentement | oui (Google) |
| Nom, e-mail, contacts, localisation précise | **non** | — | — | — |

- Données chiffrées en transit : **oui**.
- Suppression des données : **oui**, dans l'app (Réglages → « Supprimer mon compte »).
- Suivi publicitaire (App Store) : déclaré, avec la demande d'autorisation iOS.
- Identifiant publicitaire (Play Console) : **oui**. Le SDK AdMob ajoute la permission `AD_ID`
  au manifeste final, avec `ACCESS_NETWORK_STATE`, `BILLING` (achats) et les permissions
  `ACCESS_ADSERVICES_*` : les déclarer telles quelles.

## 8. Répondre aux avis

Règles : répondre sous 48 h, tutoiement, remercier, jamais d'argumentation, renvoyer vers le
support pour un cas particulier ([réponses types](../support/faq.md#3-réponses-types)).

| Avis | Réponse type |
|------|--------------|
| Positif | Merci beaucoup ! Ravis que le coach t'aide à trouver les bons mots. |
| « Trop cher » / « pas assez de crédits » | Merci pour ton retour. Tu as 5 crédits offerts chaque jour, et tu peux en gagner en regardant une courte vidéo. Les packs de crédits n'expirent pas, sans abonnement. |
| « Achat non reçu » | Désolé pour ce souci ! Ouvre l'écran Premium et touche « Restaurer mes achats ». Si rien ne change, écris-nous à {{EMAIL_SUPPORT}} : on regarde ça ensemble. |
| « Réponses nulles / pas naturelles » | Merci, ton avis nous aide. Ajoute du contexte (où vous en êtes, ce que tu sais de la personne) : les réponses deviennent bien plus personnelles. Essaie aussi un autre style. |
| « Le coach refuse ma demande » | Flirt Coach aide à séduire avec respect : il refuse les messages explicites, insistants ou manipulateurs, sans débiter de crédit. Le Mode Respect peut t'aider à reformuler. |
| « Réponses en anglais » | Le coach répond dans la langue de la conversation. Colle un message en français et écris le contexte en français. |

## 9. Avant de soumettre

- [ ] Tâches manuelles 3, 4/5, 6, 7, 8, 10, 11, 12, 14 et 15 terminées ; décision prise sur la
      tâche 17.
- [ ] `REVENUECAT_ALLOW_SANDBOX` retiré des secrets (tâche manuelle 16).
- [ ] Version et numéro de build incrémentés dans `pubspec.yaml`, `CHANGELOG.md` à jour.
- [ ] Textes légaux de l'app identiques aux pages publiées ; « (à compléter avant publication) »
      n'apparaît plus nulle part.
- [ ] Compte de démonstration : inutile (connexion anonyme), le préciser dans les notes pour la
      revue Apple ; mentionner que Premium se teste avec un compte sandbox.
- [ ] Captures au bon format, sans donnée personnelle réelle.
- [ ] Achat et restauration testés en sandbox sur les deux plateformes.
