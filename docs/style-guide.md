# Charte éditoriale

Règles d'écriture de tous les textes visibles par l'utilisateur : app, aide, fiches store,
réponses du support. Elle complète le [design system](design/design-system.md) (règles visuelles).

## 1. Notre voix

Flirt Coach Pro parle comme **un ami de confiance qui sait écrire** : complice, encourageant, jamais
moqueur ni vulgaire. Il aide à séduire **avec respect**.

| Nous sommes | Nous ne sommes pas |
|-------------|--------------------|
| complices et chaleureux | familiers ou grivois |
| encourageants | condescendants (« Facile ! », « Même toi tu peux… ») |
| clairs et concrets | techniques (« requête », « serveur », « token ») |
| honnêtes sur ce que fait l'IA | prometteurs (« succès garanti », « 100 % de réponses ») |
| respectueux de la personne en face | manipulateurs (« technique infaillible », « fais-la craquer ») |

## 2. Règles de base

- **Tutoiement** partout dans l'app, l'aide et le support. Les textes légaux restent neutres.
- **Phrases courtes** : une idée par phrase, deux phrases au plus dans un message.
- **Ne présume jamais le genre** de la personne avec qui l'utilisateur parle : « la personne »,
  « lui dire » (complément neutre), « votre échange ». Jamais « elle », « ta copine », « le mec ».
- **Ne promets aucun résultat** : ce sont des *suggestions* ; l'avertissement « Aucun résultat
  n'est garanti » figure à l'accueil.
- **Parle de l'utilisateur, pas de l'app** : « Tes crédits ont été ajoutés » plutôt que « Le
  système a crédité ton compte ».

## 3. Vocabulaire

| Utiliser | Éviter | Pourquoi |
|----------|--------|----------|
| le coach | l'IA, l'algorithme, le bot | personnifie un rôle bienveillant (l'IA est mentionnée dans l'avertissement) |
| réponse, proposition | output, résultat généré | langage courant |
| crédit(s) | jeton, token, point | un seul terme pour la monnaie de l'app |
| Premium (majuscule, sans article : « avec Premium ») | abonnement Pro, VIP, le premium | nom du produit |
| capture d'écran | screenshot, screen | français |
| Mode Respect, Banque de messages | vérificateur, templates | noms des fonctionnalités, toujours identiques |
| situation, style | catégorie, ton, mode | termes affichés à l'écran |
| la personne | la cible, la conquête, le match | respect |
| supprimer définitivement | purger, effacer à jamais | précis sans dramatiser |

Termes interdits dans tout texte : *pick-up*, *rizz*, *technique infaillible*, *faire craquer*,
*conquête*, *cible*, et toute allusion sexuelle explicite.

## 4. Forme

| Règle | Exemple |
|-------|---------|
| Majuscule seulement au premier mot (pas de « Title Case ») | « Générer un message », pas « Générer Un Message » |
| Boutons : verbe à l'infinitif + objet, 30 caractères au plus | « Vérifier mon message », « Restaurer mes achats » |
| Coût d'une action affiché dans le bouton quand il y en a un | « Régénérer (1 crédit) », « Regarder une pub (+2 crédits) » |
| Nombres en chiffres | « 3 réponses », « 5 crédits », « 24 h » |
| Pluriels gérés par le format ICU, jamais « crédit(s) » à l'écran | `{count, plural, =1{1 crédit} other{{count} crédits}}` |
| Points de suspension : un seul caractère `…` | « Colle son dernier message… » |
| Guillemets français pour citer un libellé | Réglages → « Supprimer mon compte » |
| Pas de point final dans les titres, libellés et boutons ; un point dans les phrases | « Supprimer ton compte ? » / « Entrée supprimée. » |
| Points d'exclamation : seulement pour une réussite | « Copié ! », « Bienvenue dans Premium ! » |
| Émojis : aucun dans les libellés et les messages ; seule exception, les pictogrammes des cartes de réponses, issus du kit | 😉 💕 🚀 sur l'écran Résultats |

## 5. Modèles par type de message

### Erreur : ce qui s'est passé → quoi faire → rassurer

> « Le coach est momentanément indisponible. Ton crédit n'a pas été utilisé, réessaie. »

Jamais de code technique, jamais de faute rejetée sur l'utilisateur (« Tu as mal… »). Si aucun
crédit n'a été débité, **le dire**.

### Refus du coach : sans jugement, avec une piste

> « Je ne peux pas t'aider avec ce message. Essaie une approche plus respectueuse. »

### Confirmation : courte et utile

> « Copié ! Tu peux le coller dans ta conversation. »

### Action irréversible : question + conséquences + bouton explicite

> Titre « Supprimer ton compte ? » · corps listant ce qui est effacé et ce qui ne l'est pas ·
> boutons « Annuler » / « Supprimer définitivement ».

### Écran réservé à Premium : bénéfice d'abord

> « Retrouve tous tes messages générés et copie-les à nouveau quand tu veux. »

### Monétisation : transparente, sans pression

- Prix et période toujours visibles ; conditions de renouvellement affichées sous le bouton.
- Aucune urgence artificielle (« dernière chance », compte à rebours), aucune culpabilisation
  (« Non merci, je préfère rater des dates »).
- Le refus est toujours possible et neutre (fermer l'écran).

## 6. Accessibilité des textes

- Chaque icône sans texte a un libellé lu par le lecteur d'écran (ex. « Drôle, réservé à
  Premium » pour un style verrouillé).
- Une information n'est jamais portée par la couleur seule (le verrou accompagne le style grisé).
- Les textes doivent rester lisibles avec la police agrandie à 200 % : éviter les libellés longs
  dans les boutons et les puces.

## 7. Textes produits par le coach

Les consignes du modèle (`generate/prompt.ts`, `screenshot-reply/screenshot.ts`,
`respect-check/respect.ts`, `conversation-analysis/analysis.ts` dans `supabase/functions/`)
appliquent la même charte aux réponses générées :

- réponses dans **la langue de la conversation** ; explications du Mode Respect et de l'analyse
  en français ;
- jamais de contenu sexuel explicite, haineux, insistant après un refus ou manipulateur ;
- messages courts, naturels, prêts à envoyer ; émojis permis avec parcimonie (ils sont destinés
  à la conversation, pas à l'interface).

Toute modification de ces consignes est testée (tests Deno) puis redéployée
([exploitation](operations.md#déployer)).

## 8. Ajouter ou modifier un texte de l'app

1. Ajouter la clé dans `lib/l10n/app_fr.arb`, nommée *écran + élément* en camelCase
   (`historyDeleteTitle`), avec ses `placeholders` s'il y a des variables.
2. Lancer `flutter gen-l10n` (ou simplement `flutter run` / `flutter test`).
3. L'utiliser via `AppLocalizations.of(context)` : **aucun texte en dur dans un widget**.
4. Relire avec cette charte, à voix haute, puis vérifier l'écran avec la police agrandie.

Les textes de l'aide (`assets/help/faq_fr.txt`) et les textes légaux (`assets/legal/`) suivent les
mêmes règles ; les textes légaux sont relus par un juriste avant publication
([tâche manuelle 10](manual-tasks.md#10-textes-légaux-relus-et-hébergés)).
