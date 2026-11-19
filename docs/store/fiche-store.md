# Fiche store — Google Play et App Store

Textes prêts à copier dans la Play Console et App Store Connect pour la version 1.0 (français).
Les longueurs indiquées sont les limites des stores ; chaque texte les respecte.

> Textes légaux en ligne (tâche manuelle 10) :
> https://kelenix.github.io/Flirt-Coach/confidentialite.html et
> https://kelenix.github.io/Flirt-Coach/conditions.html. `{{EMAIL_SUPPORT}}` : la valeur de
> `SUPPORT_EMAIL` dans `config/prod.json` (tâche manuelle 12). Nom confirmé : « Flirt Coach
> Pro » (tâche manuelle 3).

## 1. Identité

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach Pro |
| Sous-titre | App Store | 30 | Coach de drague et messages |
| Description courte | Google Play | 80 | Trouve les bons mots pour flirter avec respect : 3 réponses en un instant. |
| Texte promotionnel | App Store | 170 | Colle un message ou importe une capture : ton coach te propose 3 réponses naturelles, dans ton style. 5 crédits offerts chaque jour. |

## 2. Description longue (les deux stores, 4 000 caractères au plus)

```text
Tu ne sais pas quoi répondre ? Flirt Coach Pro te propose les bons mots, en quelques secondes.

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

Flirt Coach Pro est réservé aux personnes de 18 ans et plus. Les réponses sont des suggestions générées par intelligence artificielle : aucun résultat n'est garanti.

Politique de confidentialité : https://kelenix.github.io/Flirt-Coach/confidentialite.html
Conditions d'utilisation : https://kelenix.github.io/Flirt-Coach/conditions.html
```

## 3. Mots-clés (App Store, 100 caractères au plus)

```text
drague,séduction,séduire,message,rencontre,rendez-vous,conversation,réponse,IA,match,charme,amour
```

Sans espace après les virgules ; le nom de l'app et la catégorie sont déjà indexés et n'y
figurent pas. **Ne jamais y mettre le nom d'une autre app** (motif de refus Apple).

## 4. Notes de version 1.0

```text
Bienvenue dans Flirt Coach Pro !
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

Visuels Google Play prêts dans [`visuels/`](visuels/), générés par
`python scripts/store_assets.py` à partir des écrans bruts de `visuels/ecrans/` (captures de
l'émulateur, 1080 × 2400, conversations fictives) :

| Fichier | Emplacement dans la Play Console | Format |
|---------|----------------------------------|--------|
| `icone-512.png` | Icône de l'application | 512 × 512, PNG 32 bits |
| `banniere-1024x500.png` | Image de présentation | 1024 × 500, PNG sans transparence |
| `capture-1-accueil.png` à `capture-7-banque.png` | Captures d'écran du téléphone, dans l'ordre | 1080 × 1920 (9:16), PNG sans transparence |

Accroche incrustée au-dessus de chaque capture (fond du kit de marque, titres en Poppins) :

| # | Écran | Accroche |
|---|-------|----------|
| 1 | Accueil (premier écran) | Gagne en confiance |
| 2 | Résultats | Trouve les bons mots |
| 3 | Générer un message | 7 situations, 7 styles |
| 4 | Capture d'écran importée | Réponds à partir d'une capture |
| 5 | Mode Respect (« À revoir ») | Flirte avec respect |
| 6 | Analyse de conversation | Sache où vous en êtes |
| 7 | Banque de messages | Des idées, même hors connexion |

Déposés dans la Play Console le 2026-11-19 (fiche par défaut, fr-FR). L'icône, la bannière et
la capture 1 montrent le logo, créé avec une IA : ils y sont déclarés « créés avec l'IA »
(ADR-032). La bannière reprend le logo du kit tel quel. Pour changer une accroche, modifier `CAPTIONS` dans
le script ; pour changer un écran, remplacer son fichier dans `visuels/ecrans/` ; puis relancer
le script. Toujours des conversations fictives, sans nom ni photo de personne réelle.
App Store (tâche 5) : captures iPhone 6,9" (1320 × 2868 px) à produire le moment venu ; vérifier
les formats exigés dans chaque console au moment de la soumission.

## 6. Catégorie, public et classification

| Champ | Google Play | App Store |
|-------|-------------|-----------|
| Catégorie | Style de vie (« Lifestyle » dans la console) | Style de vie (secondaire : Réseaux sociaux) |
| Public cible | 18 ans et plus uniquement (section « Public cible et contenu ») | — |
| Classification | questionnaire IARC envoyé le 2026-11-19 (réponses ci-dessous) : PEGI 3, USK 12, ESRB 13+, ClassInd 14 | questionnaire d'âge : choisir la tranche la plus élevée proposée (18+) |
| Annonces | « Contient des annonces » : oui | — |
| Achats intégrés | oui | oui |
| Coordonnées | `{{EMAIL_SUPPORT}}` ; site web : `https://kelenix.github.io/Flirt-Coach/` | URL d'assistance (page web avec `{{EMAIL_SUPPORT}}`) |
| Politique de confidentialité | `https://kelenix.github.io/Flirt-Coach/confidentialite.html` | `https://kelenix.github.io/Flirt-Coach/confidentialite.html` |
| Conditions (CLUF) | — | `https://kelenix.github.io/Flirt-Coach/conditions.html` dans la description (obligatoire avec un abonnement) |

**Contenu généré par IA** (règles Google Play) : l'app permet de signaler une réponse (drapeau
sur chaque proposition) et filtre les contenus interdits côté serveur ; le mentionner si la
console le demande.

**Réponses IARC** (catégorie « Tous les autres types d'app », ADR-032) :
- Contenu dans le paquet de l'app : non.
- Échanges entre utilisateurs : non.
- Contenu en ligne (IA, banque de messages) : oui.
  - Violence : non.
  - Sexualité : oui, uniquement dans le texte et ce n'est pas le but de l'app (style
    « Provocateur léger », jamais explicite).
  - Langage offensant : non.
  - Substances : oui, dans le texte seulement (« boire un verre »).
- Promotion de produits pour adultes : non.
- Divers : achats numériques oui, sans achat aléatoire ; pas de position partagée ; pas de prix
  en argent ; ni navigateur ni app d'actualités.

**Accès pour la revue Google** (« Dettagli di accesso », en anglais, ADR-031) : nom « Premium
access for review » ; le code d'accès va dans le champ *Password* : les 8 caractères encadrés
en haut de `supabase/functions/.env.cloud`, **jamais** la longue chaîne
`REVIEW_ACCESS_CODE_SHA256` (empreinte pour le serveur). Il est saisi par l'éditeur et
jamais écrit ici ; attester l'accès complet seulement une fois le code en service. Texte du champ
*Other information* :

```text
No sign-in needed: the app creates an anonymous account automatically.
1. On first launch, tick "J'ai 18 ans ou plus" (I am 18 or older) and tap "Commencer" (Start).
2. Free features use the 5 daily credits.
3. To unlock Premium (all styles, history, no ads): tap the menu icon (top left) > "Réglages" (Settings) > "J'ai un code" (I have a code), enter the access code given in the Password field, then confirm. Premium stays active for 30 days.
```

## 7. Déclarations de confidentialité (saisies dans la Play Console le 2026-11-19, ADR-032)

Les noms entre parenthèses sont ceux de la console (en italien).

| Donnée (console) | Origine | Partagée | Temporaire | Obligatoire | Finalités |
|------------------|---------|----------|------------|-------------|-----------|
| Position approximative | AdMob (adresse IP) | oui (Google) | non | oui | analyse, publicité, prévention des fraudes |
| ID utilisateur | compte anonyme, RevenueCat | non | non | oui | fonctionnement, prévention des fraudes |
| Autres informations personnelles | déclaration d'âge (18+) | non | non | oui | fonctionnement, conformité |
| Historique d'achats | crédits, abonnements | non | non | oui | fonctionnement |
| Autres messages dans l'app | messages collés (historique, limites) | non (fournisseur d'IA = sous-traitant) | non | oui | fonctionnement |
| Photos | captures importées, **non conservées** | non | **oui** | non | fonctionnement |
| Interactions avec l'app | AdMob | oui (Google) | non | oui | analyse, publicité, prévention des fraudes |
| Autres contenus générés par l'utilisateur | contexte, signalements | non | non | non | fonctionnement, prévention des fraudes |
| Données de diagnostic | AdMob | oui (Google) | non | oui | analyse, publicité, prévention des fraudes |
| Identifiants de l'appareil | AdMob (identifiant publicitaire) | oui (Google) | non | oui | analyse, publicité, prévention des fraudes |

- **Non collectés** : nom, e-mail, contacts, localisation précise.
- **Données chiffrées en transit** : **oui**.
- **Création de compte** : « l'app ne permet pas de créer un compte » (compte anonyme sans
  identifiant ni connexion, ADR-032).
- **Suppression des données** : **oui**, dans l'app (Réglages → « Supprimer mon compte ») ou par
  e-mail. Lien déclaré : la page de confidentialité.
- **État** : enregistrée le 2026-11-19, avec toutes les déclarations du contenu. Tout partira
  en revue avec la première version.
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
| « Le coach refuse ma demande » | Flirt Coach Pro aide à séduire avec respect : il refuse les messages explicites, insistants ou manipulateurs, sans débiter de crédit. Le Mode Respect peut t'aider à reformuler. |
| « Réponses en anglais » | Le coach répond dans la langue de la conversation. Colle un message en français et écris le contexte en français. |

## 9. Avant de soumettre

- [ ] Tâches manuelles 3, 4/5, 6, 7, 8, 10, 11, 12, 14 et 15 terminées ; décision prise sur la
      tâche 17.
- [ ] `REVENUECAT_ALLOW_SANDBOX` retiré des secrets (tâche manuelle 16).
- [ ] Version et numéro de build incrémentés dans `pubspec.yaml`, `CHANGELOG.md` à jour.
- [ ] Textes légaux de l'app identiques aux pages publiées ; « (à compléter avant publication) »
      n'apparaît plus nulle part.
- [ ] Accès pour la revue : code d'accès Premium en service et saisi dans « Dettagli di
      accesso » (Google, ADR-031) ; pour Apple, le préciser dans les notes de revue.
- [ ] Captures au bon format, sans donnée personnelle réelle.
- [ ] Achat et restauration testés en sandbox sur les deux plateformes.
