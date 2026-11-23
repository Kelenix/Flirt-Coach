# Fiche store — Google Play et App Store

Textes prêts à copier dans la Play Console et App Store Connect : français (sections 1 à 9,
fiche par défaut), anglais (section 10), allemand (section 11) et espagnol (section 12). Les longueurs indiquées sont les limites des stores ;
chaque texte les respecte.

> Textes légaux en ligne (tâche manuelle 10) :
> https://kelenix.github.io/Flirt-Coach/confidentialite.html et
> https://kelenix.github.io/Flirt-Coach/conditions.html (en anglais : `privacy.html` et
> `terms.html` ; en allemand : `datenschutz.html` et `nutzungsbedingungen.html` ; en espagnol :
> `privacidad.html` et `terminos.html`). `{{EMAIL_SUPPORT}}` : la valeur de
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

Avis en anglais : réponses types en section 10.

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
- [ ] Fiches anglaise (section 10), allemande (section 11) et espagnoles (section 12) à jour,
      notes de version dans chaque langue de fiche.

## 10. Fiche en anglais (en-US)

Textes de la fiche anglaise (Play Console → Présence sur le Store → Fiche principale → gérer
les traductions → ajouter « English (United States) – en-US » ; App Store : ajouter la
localisation « English (U.S.) »). Mêmes règles et mêmes limites que la fiche française.

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach Pro |
| Sous-titre | App Store | 30 | Flirting and texting coach |
| Description courte | Google Play | 80 | Find the right words to flirt with respect: 3 replies in an instant. |
| Texte promotionnel | App Store | 170 | Paste a message or import a screenshot: your coach suggests 3 natural replies, in your style. 5 free credits every day. |

Description longue :

```text
Don't know what to reply? Flirt Coach Pro finds the right words for you, in seconds.

Paste the last message you received, choose the situation and the style: your coach suggests 3 natural replies, ready to copy. You're free to edit them before sending.

FOR EVERY MOMENT OF THE CONVERSATION
• Reply to a message
• Start a conversation after a match
• Flirt, or revive a conversation that's fading
• Get ready for a date
• Apologize, or end things gently

7 STYLES THAT SOUND LIKE YOU
Classic, Funny, Romantic, Mysterious, Direct, Elegant, Cheeky.

REPLY FROM A SCREENSHOT
Import a screenshot of the conversation: the coach reads it and suggests a fitting reply. Your screenshot is never stored.

RESPECT MODE
Before sending, check that your message isn't too pushy, too sexual or manipulative. The coach explains why and suggests a more respectful version.

CONVERSATION ANALYSIS
Find out whether your conversation is moving forward, stalling or fading, the next step to take, and the right moment to suggest a date.

AND ALSO
• A free message library, available even offline
• The history of your generated messages
• Replies in the language of your conversation

NO SIGN-UP
No name, no email. You can delete your account and all your data at any time, from the settings.

FREE, OR PREMIUM
• Free: 5 credits every day, the message library, and extra credits by watching a short video.
• Credit packs, with no subscription and no expiry date.
• Premium: all 7 styles, screenshots, Respect Mode and analysis included, history, no ads, up to 100 messages a day.

Weekly, monthly or annual Premium subscriptions renew automatically at the price shown in the app, unless cancelled at least 24 hours before the end of the current period, in your Google Play or App Store account settings. Payment is charged to your account when you confirm the purchase.

Flirt Coach Pro is for people aged 18 and over. Replies are suggestions generated by artificial intelligence: no results are guaranteed.

Privacy Policy: https://kelenix.github.io/Flirt-Coach/privacy.html
Terms of Use: https://kelenix.github.io/Flirt-Coach/terms.html
```

Mots-clés App Store (100 caractères au plus) :

```text
flirt,dating,texting,rizz,pickup lines,reply,conversation,message,date,AI,match,charm,romance
```

Notes de version 1.1, par langue :

```text
<fr-FR>
Flirt Coach Pro parle maintenant anglais, allemand, espagnol et portugais !
• L'app s'affiche dans la langue du téléphone : français, anglais, allemand, espagnol ou portugais
• Conseils et explications du coach dans la langue de l'app
• Banque de messages dans les cinq langues
</fr-FR>
<en-US>
Flirt Coach Pro now speaks English, German, Spanish and Portuguese!
• The app follows your phone's language: English, French, German, Spanish or Portuguese
• The coach's advice and explanations in the app's language
• Message library in all five languages
</en-US>
<de-DE>
Flirt Coach Pro spricht jetzt Deutsch, Englisch, Spanisch und Portugiesisch!
• Die App folgt der Sprache deines Handys: Deutsch, Englisch, Französisch, Spanisch oder Portugiesisch
• Ratschläge und Erklärungen des Coachs in der Sprache der App
• Nachrichtensammlung in allen fünf Sprachen
</de-DE>
<es-419>
¡Flirt Coach Pro ahora habla español, inglés, alemán y portugués!
• La aplicación sigue el idioma de tu teléfono: español, inglés, francés, alemán o portugués
• Consejos y explicaciones del coach en el idioma de la aplicación
• Biblioteca de mensajes en los cinco idiomas
</es-419>
<es-ES>
¡Flirt Coach Pro ahora habla español, inglés, alemán y portugués!
• La aplicación sigue el idioma de tu teléfono: español, inglés, francés, alemán o portugués
• Consejos y explicaciones del coach en el idioma de la aplicación
• Biblioteca de mensajes en los cinco idiomas
</es-ES>
<pt-BR>
O Flirt Coach Pro agora fala português, inglês, alemão e espanhol!
• O app segue o idioma do seu telefone: português, inglês, francês, alemão ou espanhol
• Conselhos e explicações do coach no idioma do app
• Biblioteca de mensagens nos cinco idiomas
</pt-BR>
<pt-PT>
O Flirt Coach Pro agora fala português, inglês, alemão e espanhol!
• O app segue o idioma do seu telefone: português, inglês, francês, alemão ou espanhol
• Conselhos e explicações do coach no idioma do app
• Biblioteca de mensagens nos cinco idiomas
</pt-PT>
```

Captures : les visuels actuels montrent l'app en français. Pour la fiche anglaise, refaire les
7 écrans bruts avec l'émulateur en anglais (mêmes conversations fictives, traduites) dans
`visuels/ecrans/en/`, avec les accroches : Build your confidence · Find the right words ·
7 situations, 7 styles · Reply from a screenshot · Flirt with respect · Know where you stand ·
Ideas, even offline. En attendant, la fiche anglaise reprend les captures françaises.

Réponses aux avis en anglais (mêmes règles qu'en section 8, « you » chaleureux) :

| Avis | Réponse type |
|------|--------------|
| Positif | Thank you so much! We're glad the coach helps you find the right words. |
| « Trop cher » | Thanks for your feedback. You get 5 free credits every day, and you can earn more by watching a short video. Credit packs never expire, with no subscription. |
| « Achat non reçu » | Sorry about that! Open the Premium screen and tap “Restore purchases”. If nothing changes, write to us at {{EMAIL_SUPPORT}} and we'll sort it out together. |
| « Réponses pas naturelles » | Thanks, your feedback helps us. Add some context (where things stand, what you know about them): replies become much more personal. Try another style too. |
| « Le coach refuse ma demande » | Flirt Coach Pro helps you flirt with respect: it refuses explicit, pushy or manipulative messages, without using any credits. Respect Mode can help you rephrase. |
| « Réponses dans une autre langue » | The coach replies in the language of the conversation. Paste a message in English and write the context in English. |

## 11. Fiche en allemand (de-DE)

Textes de la fiche allemande (Play Console → Schede dello Store → Scheda predefinita →
Gestisci lingue → « Tedesco – de-DE » ; App Store : localisation « German »). Mêmes règles
et mêmes limites que la fiche française ; tutoiement (« du »), comme dans l'app.

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach Pro |
| Sous-titre | App Store | 30 | Dein Coach für Flirts & Chats |
| Description courte | Google Play | 80 | Finde die richtigen Worte, um respektvoll zu flirten: 3 Antworten im Nu. |
| Texte promotionnel | App Store | 170 | Füge eine Nachricht ein oder importiere einen Screenshot: Dein Coach schlägt dir 3 natürliche Antworten in deinem Stil vor. Jeden Tag 5 Credits gratis. |

Description longue :

```text
Du weißt nicht, was du antworten sollst? Flirt Coach Pro findet in Sekunden die richtigen Worte für dich.

Füge die letzte erhaltene Nachricht ein, wähle die Situation und den Stil: Dein Coach schlägt dir 3 natürliche Antworten zum Kopieren vor. Du kannst sie vor dem Senden frei anpassen.

FÜR JEDEN MOMENT DES GESPRÄCHS
• Auf eine Nachricht antworten
• Nach einem Match ein Gespräch beginnen
• Flirten oder ein einschlafendes Gespräch wiederbeleben
• Ein Date vorbereiten
• Sich entschuldigen oder sanft Schluss machen

7 STILE, DIE ZU DIR PASSEN
Klassisch, Witzig, Romantisch, Geheimnisvoll, Direkt, Elegant, Frech.

ANTWORTEN AUS EINEM SCREENSHOT
Importiere einen Screenshot des Gesprächs: Der Coach liest ihn und schlägt eine passende Antwort vor. Dein Screenshot wird nie gespeichert.

RESPEKT-MODUS
Prüfe vor dem Senden, ob deine Nachricht nicht zu aufdringlich, zu sexuell oder manipulativ ist. Der Coach erklärt dir, warum, und schlägt eine respektvollere Version vor.

GESPRÄCHSANALYSE
Finde heraus, ob sich euer Gespräch entwickelt, stockt oder abkühlt, welcher Schritt als Nächstes kommt und wann der richtige Moment für ein Date ist.

UND AUSSERDEM
• Eine kostenlose Nachrichtensammlung, auch offline verfügbar
• Der Verlauf deiner erstellten Nachrichten
• Antworten in der Sprache deines Gesprächs

OHNE ANMELDUNG
Kein Name, keine E-Mail-Adresse. Du kannst dein Konto und alle deine Daten jederzeit in den Einstellungen löschen.

KOSTENLOS ODER PREMIUM
• Kostenlos: jeden Tag 5 Credits, die Nachrichtensammlung und zusätzliche Credits für ein kurzes Video.
• Credit-Pakete, ohne Abo und ohne Ablaufdatum.
• Premium: alle 7 Stile, Screenshots, Respekt-Modus und Analyse inklusive, Verlauf, keine Werbung, bis zu 100 Nachrichten pro Tag.

Wöchentliche, monatliche oder jährliche Premium-Abos verlängern sich automatisch zum in der App angegebenen Preis, sofern sie nicht spätestens 24 Stunden vor Ende des laufenden Zeitraums in den Einstellungen deines Google-Play- oder App-Store-Kontos gekündigt werden. Die Zahlung wird bei Bestätigung des Kaufs von deinem Konto abgebucht.

Flirt Coach Pro ist für Personen ab 18 Jahren. Die Antworten sind von künstlicher Intelligenz erstellte Vorschläge: Es gibt keine Erfolgsgarantie.

Datenschutzerklärung: https://kelenix.github.io/Flirt-Coach/datenschutz.html
Nutzungsbedingungen: https://kelenix.github.io/Flirt-Coach/nutzungsbedingungen.html
```

Mots-clés App Store (100 caractères au plus) :

```text
flirten,dating,chat,anmachsprüche,nachricht,antwort,date,KI,match,verlieben,romantik,gespräch
```

Captures : comme pour l'anglais, la fiche allemande reprend les captures françaises en
attendant des captures de l'app en allemand (accroches proposées : Gewinne Selbstvertrauen ·
Finde die richtigen Worte · 7 Situationen, 7 Stile · Antworten aus einem Screenshot · Flirte
mit Respekt · Wisse, wo ihr steht · Ideen, auch offline).

Réponses aux avis en allemand (mêmes règles qu'en section 8, « du ») :

| Avis | Réponse type |
|------|--------------|
| Positif | Vielen Dank! Wir freuen uns, dass dir der Coach hilft, die richtigen Worte zu finden. |
| « Trop cher » | Danke für dein Feedback. Du bekommst jeden Tag 5 kostenlose Credits und kannst weitere mit einem kurzen Video verdienen. Credit-Pakete verfallen nie, ganz ohne Abo. |
| « Achat non reçu » | Das tut uns leid! Öffne den Premium-Bildschirm und tippe auf „Käufe wiederherstellen“. Wenn sich nichts ändert, schreib uns an {{EMAIL_SUPPORT}}, dann klären wir das gemeinsam. |
| « Réponses pas naturelles » | Danke, dein Feedback hilft uns. Gib etwas Kontext an (wo ihr steht, was du über die Person weißt): Die Antworten werden dann viel persönlicher. Probier auch einen anderen Stil aus. |
| « Le coach refuse ma demande » | Flirt Coach Pro hilft dir, mit Respekt zu flirten: Er lehnt explizite, aufdringliche oder manipulative Nachrichten ab, ohne Credits zu verbrauchen. Der Respekt-Modus kann dir beim Umformulieren helfen. |
| « Réponses dans une autre langue » | Der Coach antwortet in der Sprache des Gesprächs. Füge eine Nachricht auf Deutsch ein und schreib den Kontext auf Deutsch. |

## 12. Fiche en espagnol (es-419 et es-ES)

Textes en espagnol neutre, à saisir **deux fois** dans la Play Console (Schede dello Store →
Scheda predefinita → Gestisci lingue) : « Spagnolo (America Latina) – es-419 » et
« Spagnolo (Spagna) – es-ES », avec les mêmes textes ; App Store : localisations « Spanish
(Mexico) » et « Spanish (Spain) ». Tutoiement (« tú »), sans « vosotros » ni expression propre à
un pays.

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach Pro |
| Sous-titre | App Store | 30 | Tu coach de citas y mensajes |
| Description courte | Google Play | 80 | Las palabras justas para coquetear con respeto: 3 respuestas al instante. |
| Texte promotionnel | App Store | 170 | Pega un mensaje o importa una captura: tu coach te propone 3 respuestas naturales, a tu estilo. 5 créditos gratis cada día. |

Description longue :

```text
¿No sabes qué responder? Flirt Coach Pro encuentra las palabras adecuadas por ti, en segundos.

Pega el último mensaje que recibiste, elige la situación y el estilo: tu coach te propone 3 respuestas naturales, listas para copiar. Puedes modificarlas antes de enviarlas.

PARA CADA MOMENTO DE LA CONVERSACIÓN
• Responder un mensaje
• Iniciar una conversación después de un match
• Coquetear o reactivar una conversación que se apaga
• Preparar una cita
• Pedir perdón o terminar con delicadeza

7 ESTILOS QUE VAN CONTIGO
Clásico, Divertido, Romántico, Misterioso, Directo, Elegante, Atrevido.

RESPONDER A PARTIR DE UNA CAPTURA DE PANTALLA
Importa una captura de la conversación: el coach la lee y te propone una respuesta adecuada. Tu captura nunca se guarda.

MODO RESPETO
Antes de enviar, revisa que tu mensaje no sea demasiado insistente, demasiado sexual ni manipulador. El coach te explica por qué y te propone una versión más respetuosa.

ANÁLISIS DE CONVERSACIÓN
Descubre si la conversación avanza, se estanca o se enfría, cuál es el siguiente paso y el mejor momento para proponer una cita.

Y ADEMÁS
• Una biblioteca de mensajes gratis, disponible incluso sin conexión
• El historial de tus mensajes generados
• Respuestas en el idioma de tu conversación

SIN REGISTRO
Sin nombre ni correo electrónico. Puedes eliminar tu cuenta y todos tus datos en cualquier momento, desde la configuración.

GRATIS O PREMIUM
• Gratis: 5 créditos cada día, la biblioteca de mensajes y créditos extra por ver un video corto.
• Paquetes de créditos, sin suscripción y sin fecha de vencimiento.
• Premium: los 7 estilos, capturas, Modo Respeto y análisis incluidos, historial, sin anuncios, hasta 100 mensajes al día.

Las suscripciones Premium semanal, mensual o anual se renuevan automáticamente al precio indicado en la aplicación, salvo que se cancelen al menos 24 horas antes del final del periodo en curso, desde la configuración de tu cuenta de Google Play o App Store. El pago se cobra en tu cuenta al confirmar la compra.

Flirt Coach Pro está reservada a personas de 18 años o más. Las respuestas son sugerencias generadas por inteligencia artificial: no se garantiza ningún resultado.

Política de privacidad: https://kelenix.github.io/Flirt-Coach/privacidad.html
Términos de uso: https://kelenix.github.io/Flirt-Coach/terminos.html
```

Mots-clés App Store (100 caractères au plus) :

```text
ligar,coquetear,citas,chat,mensaje,respuesta,cita,IA,match,seducir,romance,conversación,amor
```

Captures : la fiche espagnole reprend les captures françaises en attendant des captures de
l'app en espagnol (accroches proposées : Gana confianza · Encuentra las palabras adecuadas ·
7 situaciones, 7 estilos · Responde desde una captura · Coquetea con respeto · Sabe en qué
punto están · Ideas, incluso sin conexión).

Prix : en Amérique latine hispanophone, environ la moitié du prix américain depuis le
2026-11-23 (ADR-037, grille complète dans le journal de décisions) ; l'Espagne garde les prix
en euros.

Réponses aux avis en espagnol (mêmes règles qu'en section 8, « tú ») :

| Avis | Réponse type |
|------|--------------|
| Positif | ¡Muchas gracias! Nos alegra que el coach te ayude a encontrar las palabras adecuadas. |
| « Trop cher » | Gracias por tu comentario. Tienes 5 créditos gratis cada día y puedes ganar más viendo un video corto. Los paquetes de créditos nunca vencen, sin suscripción. |
| « Achat non reçu » | ¡Lamentamos el problema! Abre la pantalla Premium y toca «Restaurar compras». Si nada cambia, escríbenos a {{EMAIL_SUPPORT}} y lo resolvemos juntos. |
| « Réponses pas naturelles » | Gracias, tu opinión nos ayuda. Agrega contexto (en qué punto están, lo que sabes de la persona): las respuestas serán mucho más personales. Prueba también otro estilo. |
| « Le coach refuse ma demande » | Flirt Coach Pro te ayuda a coquetear con respeto: rechaza los mensajes explícitos, insistentes o manipuladores, sin gastar créditos. El Modo Respeto puede ayudarte a reformularlos. |
| « Réponses dans une autre langue » | El coach responde en el idioma de la conversación. Pega un mensaje en español y escribe el contexto en español. |

## 13. Fiche en portugais (pt-BR et pt-PT)

Textes en portugais du Brésil, à saisir **deux fois** dans la Play Console (Schede dello Store →
Scheda predefinita → Gestisci lingue) : « Portoghese (Brasile) – pt-BR » et « Portoghese
(Portogallo) – pt-PT », avec les mêmes textes ; App Store : localisations « Portuguese
(Brazil) » et « Portuguese (Portugal) ». « você », comme dans l'app (ADR-038).

| Champ | Store | Limite | Texte |
|-------|-------|--------|-------|
| Nom de l'app | les deux | 30 | Flirt Coach Pro |
| Sous-titre | App Store | 30 | Coach de flerte e mensagens |
| Description courte | Google Play | 80 | As palavras certas para flertar com respeito: 3 respostas num instante. |
| Texte promotionnel | App Store | 170 | Cole uma mensagem ou importe uma captura: seu coach sugere 3 respostas naturais, no seu estilo. 5 créditos grátis todo dia. |

Description longue :

```text
Não sabe o que responder? O Flirt Coach Pro encontra as palavras certas para você, em segundos.

Cole a última mensagem que você recebeu, escolha a situação e o estilo: seu coach sugere 3 respostas naturais, prontas para copiar. Você pode editá-las antes de enviar.

PARA CADA MOMENTO DA CONVERSA
• Responder a uma mensagem
• Iniciar uma conversa depois de um match
• Flertar ou reanimar uma conversa que está esfriando
• Se preparar para um encontro
• Pedir desculpas ou terminar com delicadeza

7 ESTILOS COM A SUA CARA
Clássico, Divertido, Romântico, Misterioso, Direto, Elegante, Ousado.

RESPONDER A PARTIR DE UMA CAPTURA DE TELA
Importe uma captura da conversa: o coach lê e sugere uma resposta adequada. Sua captura nunca é salva.

MODO RESPEITO
Antes de enviar, verifique se sua mensagem não é insistente demais, sexual demais ou manipuladora. O coach explica o porquê e sugere uma versão mais respeitosa.

ANÁLISE DE CONVERSA
Descubra se a conversa está avançando, parada ou esfriando, qual é o próximo passo e o melhor momento para propor um encontro.

E TAMBÉM
• Uma biblioteca de mensagens grátis, disponível até sem conexão
• O histórico das suas mensagens geradas
• Respostas no idioma da sua conversa

SEM CADASTRO
Sem nome, sem e-mail. Você pode excluir sua conta e todos os seus dados a qualquer momento, nas configurações.

GRÁTIS OU PREMIUM
• Grátis: 5 créditos todo dia, a biblioteca de mensagens e créditos extras ao assistir a um vídeo curto.
• Pacotes de créditos, sem assinatura e sem data de validade.
• Premium: os 7 estilos, capturas, Modo Respeito e análise incluídos, histórico, sem anúncios, até 100 mensagens por dia.

As assinaturas Premium semanal, mensal ou anual são renovadas automaticamente pelo preço indicado no app, a menos que sejam canceladas pelo menos 24 horas antes do fim do período em curso, nas configurações da sua conta do Google Play ou da App Store. O pagamento é cobrado na sua conta ao confirmar a compra.

O Flirt Coach Pro é destinado a pessoas de 18 anos ou mais. As respostas são sugestões geradas por inteligência artificial: nenhum resultado é garantido.

Política de Privacidade: https://kelenix.github.io/Flirt-Coach/privacidade.html
Termos de Uso: https://kelenix.github.io/Flirt-Coach/termos.html
```

Mots-clés App Store (100 caractères au plus) :

```text
paquera,flerte,namoro,encontro,chat,mensagem,resposta,cantada,IA,match,romance,conversa
```

Captures : la fiche portugaise reprend les captures françaises en attendant des captures de
l'app en portugais (accroches proposées : Ganhe confiança · Encontre as palavras certas ·
7 situações, 7 estilos · Responda a partir de uma captura · Flerte com respeito · Saiba em que
ponto vocês estão · Ideias, até sem conexão).

Prix : au Brésil, prix en euros convertis par la Play Console, un prix local reste à décider
(tâche 20) ; le Portugal garde les prix en euros.

Réponses aux avis en portugais (mêmes règles qu'en section 8, « você ») :

| Avis | Réponse type |
|------|--------------|
| Positif | Muito obrigado! Ficamos felizes que o coach ajude você a encontrar as palavras certas. |
| « Trop cher » | Obrigado pelo seu comentário. Você recebe 5 créditos grátis todo dia e pode ganhar mais assistindo a um vídeo curto. Os pacotes de créditos nunca expiram, sem assinatura. |
| « Achat non reçu » | Sentimos muito pelo problema! Abra a tela Premium e toque em “Restaurar compras”. Se nada mudar, escreva para {{EMAIL_SUPPORT}} e resolvemos juntos. |
| « Réponses pas naturelles » | Obrigado, sua opinião nos ajuda. Adicione contexto (em que ponto vocês estão, o que você sabe sobre a pessoa): as respostas ficam muito mais pessoais. Experimente também outro estilo. |
| « Le coach refuse ma demande » | O Flirt Coach Pro ajuda você a flertar com respeito: ele recusa mensagens explícitas, insistentes ou manipuladoras, sem gastar créditos. O Modo Respeito pode ajudar a reformular. |
| « Réponses dans une autre langue » | O coach responde no idioma da conversa. Cole uma mensagem em português e escreva o contexto em português. |
