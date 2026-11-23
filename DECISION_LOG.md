# Journal de décisions (DECISION_LOG)

> ADR léger. Chaque décision structurante prise par Claude **en autonomie** y est consignée :
> contexte → décision → alternatives écartées → conséquences. Le plus récent en haut.

---

## ADR-038 — Portugais du Brésil, cinquième langue

- **Date** : 2026-11-23
- **Statut** : Accepté
- **Décideur** : l'utilisateur (« ajoute le portugais ») ; choix de la variante et mise en
  œuvre : Claude (rôles : flutter-engineer, backend)
- **Contexte** : le Brésil est l'un des plus gros marchés des applications de rencontre en
  téléchargements, et réunit la grande majorité des lusophones ; le portugais ouvre aussi le
  Portugal, l'Angola et le Mozambique.
- **Décision** :
  - Un seul portugais, **celui du Brésil** (code `pt`, toutes régions) : « você », vocabulaire
    compris des deux côtés de l'Atlantique (« telefone » plutôt que « celular » ou
    « telemóvel », « captura de tela », « Configurações », « Denunciar »). Formulations sans
    accord de genre quand elles visent l'utilisateur ou la personne en face (« Boas-vindas ao
    Premium », « Cole a última mensagem da pessoa »), et dans la banque pour celui ou celle qui
    écrit (« Agradeço » plutôt que « Obrigado » / « Obrigada »).
  - Même structure que les langues précédentes : `app_pt.arb`, aide et textes légaux
    `*_pt.txt`, déclarations Android et iOS (`pt.lproj`), 40 messages de banque (migration
    `20261123030000`), pages légales `privacidade.html` et `termos.html`. Serveur inchangé.
  - Fiche store : mêmes textes pour « pt-BR » (Brésil) et « pt-PT » (Portugal), section 13 de
    la fiche du store.
- **Alternatives écartées** :
  - Portugais du Portugal comme base : marché bien plus petit ; il sonnerait étranger au
    Brésil, alors que les contenus brésiliens sont courants au Portugal.
  - Deux variantes dès maintenant : double relecture pour des écarts surtout de vocabulaire.
    Possible plus tard sans rien casser : un fichier `app_pt_PT.arb` qui ne contient que les
    écarts, si les avis portugais le demandent.
- **Conséquences** :
  - Le parcours des écrans du menu sans débordement couvre aussi le portugais.
  - Le Brésil garde les prix en euros convertis par la Play Console (ADR-037 l'avait laissé de
    côté faute de traduction) : un prix local est une décision financière de l'utilisateur
    (tâche 20).
  - Textes légaux traduits fidèlement ; le juriste dira si la loi brésilienne sur les données
    (LGPD) demande des mentions en plus (autorité ANPD, « encarregado »).
  - Après déploiement de la migration, la 1.0.0 affichera la banque dans les cinq langues
    jusqu'à la 1.1.0.
- **Impact** : métier (Brésil, Portugal), financier (prix au Brésil à décider), technique
  faible.

---

## ADR-037 — Prix locaux en Amérique latine hispanophone : environ la moitié du prix américain

- **Date** : 2026-11-23
- **Statut** : Accepté
- **Décideur** : l'utilisateur (« choisis et configure ces prix, en diminuant pour adapter
  localement ») ; choix de la grille et saisie dans la Play Console : Claude (rôle : publication)
- **Contexte** : la Play Console convertissait les prix en euros (ADR-033) dans chaque monnaie :
  le mensuel valait 265 MXN au Mexique, 14 300 CLP au Chili, 11,99 USD en Équateur, comme aux
  États-Unis, des niveaux élevés pour le pouvoir d'achat local. L'app est maintenant en
  espagnol (ADR-036).
- **Décision** : dans les pays hispanophones d'Amérique latine, prix fixé à **environ 50 % du
  prix américain**, saisi en USD et converti par Google (TVA locale incluse, arrondis locaux) :

  | Produit | États-Unis | Amérique latine (base) | Exemples après conversion |
  |---|---|---|---|
  | Hebdomadaire | 6,49 $ | 2,99 $ | 65 MXN · 3 600 CLP · 10 500 COP · 9,99 PEN |
  | Mensuel | 11,99 $ | 5,99 $ | 135 MXN · 7 300 CLP · 21 000 COP · 20,99 PEN |
  | Annuel | 45,99 $ | 22,99 $ | 509 MXN · 28 000 CLP · 81 000 COP · 78,99 PEN |
  | Pack 20 crédits | 2,69 $ | 1,29 $ | 29 MXN · 1 600 CLP · 4 500 COP · 4,49 PEN |
  | Pack 50 crédits | 5,49 $ | 2,69 $ | 59 MXN · 3 300 CLP · 9 500 COP · 9,49 PEN |
  | Pack 100 crédits | 8,99 $ | 4,49 $ | 99 MXN · 5 500 CLP · 15 500 COP · 15,99 PEN |

  - Abonnements : 11 pays (Mexique, Colombie, Chili, Pérou, Argentine, Bolivie, Costa Rica,
    Paraguay, Équateur, Salvador, Panama).
  - Packs : ces 11 pays plus Guatemala, Honduras, Nicaragua, République dominicaine, Uruguay et
    Venezuela (17).
  - Inchangés : Espagne (zone euro), Brésil (app non traduite en portugais), et tous les autres
    pays.
- **Alternatives écartées** :
  - Grille par pays fondée sur un indice de pouvoir d'achat : plus fine, mais 6 produits × 17
    prix à tenir à jour à la main ; la règle unique se recalcule en une saisie par produit.
  - Baisser aussi les 6 pays du groupe « Altri paesi (USD) » pour les abonnements : ce groupe
    partagé couvre d'autres pays du monde, qui auraient baissé aussi.
- **Conséquences** :
  - Pour les abonnements, Guatemala, Honduras, Nicaragua, République dominicaine, Uruguay et
    Venezuela restent au prix américain (groupe partagé de la console) ; leurs packs sont
    baissés.
  - Les prix ne s'appliquent qu'aux nouveaux abonnés (aucun abonné dans ces pays à ce jour) ;
    les changements de prix ne passent pas par la revue Google.
  - Argentine : prix fixés en pesos, à réviser tous les trois mois environ (inflation).
  - À réévaluer avec les premières données de conversion par pays (Play Console → Statistiche).
- **Impact** : financier (revenu par achat plus faible, volume attendu plus élevé), réversible.

---

## ADR-036 — Espagnol neutre, quatrième langue

- **Date** : 2026-11-23
- **Statut** : Accepté
- **Décideur** : l'utilisateur (« ajoute l'espagnol », 2ᵉ langue recommandée après l'allemand,
  ADR-035) ; mise en œuvre : Claude (rôles : flutter-engineer, backend)
- **Contexte** : l'espagnol ouvre d'un coup l'Espagne, l'Amérique latine et les hispanophones des
  États-Unis : surtout du volume de téléchargements, avec des revenus par utilisateur plus
  faibles qu'en Allemagne.
- **Décision** :
  - Un seul espagnol, **neutre** (code `es`, toutes régions) : tutoiement (« tú »), jamais
    « vosotros » ni expression propre à un pays, vocabulaire compris des deux côtés (« video »,
    « configuración », « reportar », « coquetear »). Formulations sans accord de genre quand
    elles visent l'utilisateur ou la personne en face (« Te damos la bienvenida », « ¿Te
    gustaría ir conmigo? »).
  - Même structure que les langues précédentes : `app_es.arb`, aide et textes légaux `*_es.txt`,
    déclarations Android et iOS, 40 messages de banque (migration `20261123020000`), pages
    légales `privacidad.html` et `terminos.html`. Serveur inchangé.
  - Fiche store : mêmes textes pour « es-419 » (Amérique latine) et « es-ES » (Espagne),
    section 12 de la fiche du store.
- **Alternatives écartées** : deux variantes (`es_ES` et `es_419`) : double traduction à
  maintenir pour des écarts minimes une fois les régionalismes évités ; à reconsidérer si les
  avis le demandent.
- **Conséquences** :
  - Le parcours des écrans du menu sans débordement couvre aussi l'espagnol.
  - Les prix en euros convertis par la Play Console sont élevés pour l'Amérique latine : des
    prix locaux sont une décision financière de l'utilisateur (tâche 20).
  - Après déploiement de la migration, la 1.0.0 affichera la banque dans les quatre langues
    jusqu'à la 1.1.0.
- **Impact** : métier (Espagne, Amérique latine), financier (prix locaux à décider), technique
  faible.

---

## ADR-035 — Allemand, troisième langue

- **Date** : 2026-11-23
- **Statut** : Accepté
- **Décideur** : l'utilisateur (choix de la langue, sur recommandation de Claude) ; mise en
  œuvre : Claude (rôles : flutter-engineer, backend)
- **Contexte** : après l'anglais (ADR-034), choix de la langue suivante. Indications de marché
  (sources publiques, chiffres détaillés payants) : pour l'assistant IA de séduction de
  référence, les premiers pays sont les États-Unis, le Royaume-Uni puis l'Allemagne (Sensor
  Tower) ; les États-Unis et le Royaume-Uni pèsent environ la moitié des revenus des apps de
  rencontre. L'espagnol et le portugais du Brésil apportent surtout du volume, avec des prix
  locaux à baisser.
- **Décision** : ajouter l'allemand (Allemagne, Autriche, Suisse alémanique), marché solvable
  adapté aux abonnements. Tutoiement (« du »), comme en français. Même structure que l'anglais :
  `app_de.arb`, aide et textes légaux `*_de.txt`, déclarations Android et iOS, 40 messages de
  banque (migration `20261123010000`), pages légales `datenschutz.html` et
  `nutzungsbedingungen.html`, fiche store (section 11). Rien à changer côté serveur. L'anglais
  reste la langue de repli.
- **Alternatives écartées** : espagnol (plus de volume, moins de revenus par utilisateur,
  prévu ensuite), portugais du Brésil (même raison).
- **Conséquences** :
  - Un test parcourt les écrans du menu en allemand (textes les plus longs) et échoue en cas
    de débordement.
  - Marché allemand : un juriste doit confirmer si une mention d'éditeur (« Impressum ») est
    exigée en plus des informations affichées par les stores (tâche 10).
  - Une fois la migration déployée, la 1.0.0 affichera la banque dans les trois langues
    jusqu'à la 1.1.0.
- **Impact** : métier (ouverture des pays germanophones), technique faible.

---

## ADR-034 — Interface en français et en anglais, anglais en repli

- **Date** : 2026-11-23
- **Statut** : Accepté
- **Décideur** : Claude (rôles : mobile-architect, flutter-engineer, backend), à la demande de
  l'utilisateur (« ajoute l'anglais, tout doit être traduit »)
- **Contexte** : l'app, en test fermé, était en français seul (Q4). Les testeurs parlent anglais
  et l'app sera publiée dans plusieurs pays. Exigences : tout traduire, ne rien casser, garder
  une structure qui accueille d'autres langues.
- **Décision** :
  - **Langue de l'interface** = celle du téléphone si l'app la propose (`fr`, `en`), sinon
    l'anglais (`preferred-supported-locales: [en]`). Une seule règle, `resolveAppLocale`
    (`lib/core/l10n/app_language.dart`), sert l'interface et les appels serveur. Pas de
    sélecteur dans l'app : Android 13+ (`res/xml/locales_config.xml`) et iOS
    (`CFBundleLocalizations`) proposent déjà le choix de langue par app dans les réglages du
    téléphone.
  - **Textes** : le français reste la langue source (`app_fr.arb`, modèle) ; `app_en.arb` est
    complet. Aide et textes légaux embarqués par langue (`<base>_<code>.txt`), pages légales
    web en français et en anglais. Textes d'autorisation iOS traduits (`InfoPlist.strings`).
    `test/l10n/translations_test.dart` vérifie que chaque langue est complète (clés, variables,
    fichiers embarqués, déclarations Android et iOS).
  - **IA** : chaque requête porte `locale` (code ISO 639). Les textes destinés à l'utilisateur
    (refus, explications du Mode Respect, analyse) sont écrits dans cette langue ; les messages à
    envoyer restent dans la langue de la conversation, la langue de l'app ne servant qu'en
    dernier recours. Les consignes système restent identiques pour toutes les langues (cache de
    prompt préservé) ; la langue est une ligne de la demande. Sans `locale` (versions 1.0.0) :
    français, comportement inchangé. Tout code ISO 639 est accepté : une nouvelle langue de
    l'app ne demande aucun changement côté serveur.
  - **Banque de messages** : colonne `language` (obligatoire, code ISO 639) et 40 messages
    anglais ; l'app lit la langue de son interface et garde une copie hors ligne par langue.
- **Alternatives écartées** :
  - Sélecteur de langue dans l'app : écran, préférence et code en plus pour un doublon des
    réglages du téléphone ; à ajouter si les utilisateurs le demandent.
  - Repli en français pour les autres langues : moins utile pour une publication
    internationale.
  - Une consigne système traduite par langue : autant de textes à maintenir et un cache de
    prompt divisé, alors que le modèle suit très bien une consigne de langue.
  - Banque traduite à la volée par l'IA : coût, délai, et plus de consultation hors ligne.
  - Une table par langue (ou une nouvelle table) pour la banque : protège les versions 1.0.0
    mais doublonne les données et laisse une table à supprimer plus tard.
- **Conséquences** :
  - Les versions 1.0.0 déjà installées lisent la banque sans filtre de langue : une fois la
    migration appliquée, elles afficheraient les messages français **et** anglais (16 par
    catégorie) jusqu'à leur mise à jour. La migration est donc appliquée au moment de publier la
    1.1.0 (tâche manuelle 20) ; la nouvelle version, elle, a besoin de la migration. Le reste
    (interface, IA, achats) ne change pas pour les versions 1.0.0.
  - Textes légaux anglais : traduction fidèle des français, à faire relire avec eux (tâche 10).
  - iOS : `InfoPlist.strings` ajouté au projet Xcode à la main (poste Windows) ; à vérifier à la
    première compilation iOS.
- **Impact** : technique (moyen, réversible) ; métier (ouverture aux pays anglophones et aux
  autres langues en repli anglais).

---

## ADR-033 — Produits Google Play : prix TTC en France

- **Date** : 2026-11-20
- **Statut** : Accepté
- **Décideur** : Claude (rôle : publication), sur l'accord de l'utilisateur pour créer les
  produits aux prix décidés (tâche 6).
- **Contexte** : la Play Console traite le prix saisi comme un prix **hors taxe** et ajoute la
  TVA de chaque pays. Avec 6,99 € saisis, un Français paierait 8,49 €. Or les prix décidés
  (6,99 / 12,99 / 49,99 € et 2,99 / 5,99 / 9,99 €) sont ceux affichés à l'utilisateur.
- **Décision** :
  - Prix décidés = prix TTC payés en France. Base hors taxe saisie pour tous les pays :
    5,83 / 10,83 / 41,66 € et 2,49 / 4,99 / 8,33 € (prix TTC ÷ 1,20). Les autres pays suivent
    la conversion automatique de Google (taux de change et arrondis locaux).
  - Abonnements : un forfait de base par abonnement (`weekly`, `monthly`, `annual`),
    renouvellement automatique, délai de grâce et suspension recommandés par Google (3, 7 et
    14 jours), réabonnement autorisé. Avantages repris de l'écran Premium de l'app.
  - Packs : produits à paiement unique, option d'achat `buy` compatible avec les anciennes
    versions de la bibliothèque de facturation, classés « contenus numériques ».
  - Les 6 produits sont actifs (175 pays pour les abonnements, 174 pour les packs).
- **Alternatives écartées** :
  - Saisir les prix décidés tels quels : +21 % pour l'utilisateur français, contraire à la
    décision.
  - Fixer à la main le prix de chaque pays de la zone euro : long, peu utile pour une app en
    français ; possible plus tard, pays par pays.
- **Conséquences** :
  - La TVA varie dans la zone euro, donc quelques prix diffèrent de la France. Hebdomadaire :
    7,49 € en Croatie et en Finlande. Annuel : 48,99 € au Luxembourg. Packs : de 2,89 à
    3,09 € pour 20 crédits selon le pays.
  - Hors zone euro, prix convertis automatiquement, par exemple :
    - États-Unis : 6,49 / 11,99 / 45,99 $ et 2,69 / 5,49 / 8,99 $ ;
    - Royaume-Uni : 5,99 / 10,99 / 41,99 £ et 2,49 / 4,99 / 8,49 £.
  - L'app affiche toujours le prix du store (ADR-017), donc rien à changer dans le code.
  - Pour changer un prix : même méthode (prix TTC visé ÷ 1,20 en base).
- **Impact** : financier — moyen.

---

## ADR-032 — Déclarations de la Play Console (contenu, données, visuels IA)

- **Date** : 2026-11-19
- **Statut** : Accepté
- **Décideur** : Claude (rôle : publication / sécurité). L'utilisateur a choisi l'étiquetage IA
  (logo créé avec une IA) et l'acceptation des conditions de l'IARC.
- **Contexte** : la fiche et les déclarations doivent décrire l'app telle qu'elle est. Une
  déclaration fausse peut entraîner un refus ou un retrait de l'app.
- **Décision** :
  - Classification IARC, catégorie « autres apps ». Contenu en ligne (IA) : oui.
    Contenu sexuel : oui, uniquement dans le texte et ce n'est pas le but de l'app (style
    « Provocateur léger », jamais explicite). Substances : oui, dans le texte (« boire un
    verre »). Pas de violence ni de langage offensant. Achats numériques : oui, sans achat
    aléatoire. Résultat : PEGI 3, USK 12, ESRB 13+, ClassInd 14.
  - Sécurité des données : pas de « création de compte ». Le compte anonyme n'a ni
    identifiant ni moyen de connexion, il n'entre donc pas dans la définition Google d'un
    « compte d'app ». Suppression des données : oui (app + e-mail), avec pour lien la
    politique de confidentialité. Données d'AdMob déclarées collectées et partagées
    (position approximative, interactions, diagnostic, identifiants) selon la documentation
    Google. Captures d'écran : traitement temporaire et facultatif.
  - Étiquette « créé avec l'IA » sur l'icône, la bannière et la capture d'accueil, qui
    montrent le logo. Les autres captures sont de vrais écrans.
  - Catégorie « Lifestyle » ; e-mail de contact public = e-mail de support ; site web =
    pages légales.
- **Alternatives écartées** :
  - Déclarer « pas de contenu sexuel ni de substances », ce qui sous-déclarerait la sortie de
    l'IA.
  - Déclarer un compte « Altro », ce qui imposerait une page de suppression de compte pour un
    compte que l'utilisateur ne voit pas.
- **Conséquences** :
  - À revoir si l'app ajoute une connexion (e-mail, Google) ou un nouveau SDK.
  - Une ancre vers la section « Tes droits » de la page de confidentialité rendrait le lien
    de suppression plus direct.
  - Réponses détaillées : `docs/store/fiche-store.md`, sections 6 et 7.
- **Impact** : légal / publication — fort.

---

## ADR-031 — Accès à Premium pour la revue Google par code

- **Date** : 2026-11-19
- **Statut** : Accepté (choix de l'utilisateur). Mis en œuvre et déployé le 2026-11-19 :
  migration `20261119000000_access_codes`, fonction `redeem-code`, Réglages → « J'ai un
  code ». Le secret est posé sur le cloud et le code est saisi dans la Play Console. Code
  ramené de 16 à 8 caractères à la demande de l'utilisateur, pour une saisie plus simple. Il
  reste sûr : 5 essais par heure et par compte, création de comptes anonymes limitée par
  adresse IP, plafond de 20 activations, code changeable.
- **Décideur** : utilisateur ; Claude (rôle : sécurité / backend) pour la conception
- **Contexte** : la Play Console (« Dettagli di accesso ») exige que les testeurs de Google
  accèdent à toute l'app, Premium compris, sans acheter ni utiliser d'essai gratuit. Elle
  exige aussi d'attester que les accès fournis ouvrent tout le contenu payant. L'app n'a pas
  d'identifiants (compte anonyme).
- **Décision** :
  - Ajouter dans Réglages « J'ai un code ». Le code saisi est vérifié par une Edge Function.
  - Le code secret est un secret Supabase, jamais dans l'app.
  - Un code valide donne Premium 30 jours au compte courant.
  - Le nombre d'activations est plafonné, une seule par compte, avec un nombre de tentatives
    limité. Le code peut être changé à tout moment.
  - L'utilisateur saisit lui-même le code dans la console.
- **Alternatives écartées** :
  - Instructions seules : risque de refus, Premium resterait fermé.
  - Codes promo Google Play : assimilés à un essai gratuit, que les testeurs n'ont pas le droit
    d'utiliser.
  - Compte de démonstration avec mot de passe : l'app n'a pas de connexion.
- **Conséquences** :
  - Les déclarations « Détails d'accès » et « Public cible » restent à finir.
  - La sécurité des données ne peut être validée qu'après le public cible.
  - Le code doit être dans la première version envoyée au test fermé.
  - Instructions anglaises prêtes dans `docs/store/fiche-store.md`.
- **Impact** : sécurité — moyen (un code divulgué donnerait Premium, d'où le plafond et la
  rotation) ; publication — fort.

---

## ADR-030 — Textes légaux en ligne sur GitHub Pages

- **Date** : 2026-11-19
- **Statut** : Accepté
- **Décideur** : utilisateur (hébergement) ; Claude (rôle : documentation) pour la mise en œuvre
- **Contexte** : Google Play exige une URL publique pour la politique de confidentialité (pas de
  PDF), et l'App Store des conditions d'utilisation pour un abonnement. Le texte en ligne doit
  être identique à celui de l'app.
- **Décision** : pages générées par `scripts/legal_pages.py` à partir de `assets/legal/*.txt`
  (éditeur et contact lus dans `config/prod.json`, comme dans l'app), au même format que
  l'écran de l'app ; publiées sur la branche `gh-pages` du dépôt public :
  https://kelenix.github.io/Flirt-Coach/. Pages autonomes : pas de police ni de script
  externes, donc aucune requête vers des tiers.
- **Alternatives écartées** : Firebase Hosting (proposé, non retenu par l'utilisateur) ; page
  d'Edge Function Supabase (le domaine supabase.co ne sert pas de HTML) ; PDF (refusé par
  Google Play).
- **Conséquences** : toute modification des textes passe par `assets/legal/`, puis par la
  génération et la publication (`docs/operations.md`) ; l'adresse ne change pas. La branche
  `gh-pages` ne contient que les pages générées. La relecture par un juriste reste conseillée.
- **Impact** : légal — fort (obligation des stores) ; technique — faible.

---

## ADR-029 — Nom de l'app : « Flirt Coach Pro »

- **Date** : 2026-11-19
- **Statut** : Accepté (remplace la partie « nom » d'ADR-028)
- **Décideur** : utilisateur
- **Contexte** : l'app a été créée dans la Play Console sous le nom « Flirt Coach Pro ».
  L'utilisateur confirme que ce nom remplace « Flirt Coach » partout et demande de ne pas
  modifier le logo.
- **Décision** :
  - « Flirt Coach Pro » partout où le nom est écrit : sous l'icône (Android `android:label`, iOS
    `CFBundleDisplayName`), dans l'app (`appName` ; titre de l'écran Premium « Flirt Coach Pro
    Premium »), mentions légales, aide intégrée, consignes du coach côté serveur, fiche du store,
    README et documentation.
  - Logo inchangé : symbole, mot-symbole « FlirtCoach » et bannière du README restent tels
    quels ; le libellé d'accessibilité du logo annonce « Flirt Coach Pro ».
  - Inchangés aussi : identifiants d'application, nom du paquet Dart `flirt_coach`, noms
    internes des projets Supabase et RevenueCat, noms de fichiers.
- **Alternatives écartées** : nouveau nom sur le store seulement ; mot-symbole retouché pour y
  ajouter « Pro » (exclu : le logo ne doit pas changer).
- **Conséquences** : certains lanceurs peuvent raccourcir le nom sous l'icône (15 caractères).
  Les consignes du coach au nouveau nom ne seront en ligne qu'au prochain déploiement de
  `generate`, `respect-check` et `conversation-analysis`.
- **Impact** : métier (marque) — moyen ; technique — faible.

---

## ADR-028 — Publication Android d'abord ; nom et identifiants conservés

- **Date** : 2026-11-19
- **Statut** : Accepté
- **Décideur** : utilisateur
- **Contexte** : préparation de la publication (phase 6). L'utilisateur a déjà un compte Google
  Play Console, utilisé pour d'autres applications, mais pas de compte Apple Developer. Il compile
  les versions des stores sur une autre machine.
- **Décision** :
  - Nom « Flirt Coach » et identifiants conservés : Android `com.flirtcoach.flirt_coach`, iOS
    `com.flirtcoach.flirtCoach`.
  - Google Play d'abord. Le compte Apple Developer et toute la partie iOS (produits App Store,
    apps iOS dans RevenueCat et AdMob, compilation iOS) viennent après la mise en ligne Android.
  - Préparation guidée une étape à la fois, suivie dans `docs/manual-tasks.md`.
- **Alternatives écartées** : identifiant bâti sur un nom de domaine possédé, sans « _ » ;
  lancement simultané sur Android et iOS.
- **Conséquences** : l'identifiant Android devient définitif à la création de l'app dans la Play
  Console. Les identifiants diffèrent entre Android et iOS, sans effet : RevenueCat et AdMob
  traitent chaque plateforme séparément. Les 99 $/an d'Apple sont reportés.
- **Impact** : métier (calendrier de lancement) — moyen ; technique — aucun.

---

## ADR-027 — Abonnement restauré sur une nouvelle installation (événement TRANSFER)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôles : backend, achats)
- **Contexte** : point S12 de la revue de phase 5. Une réinstallation ou un nouveau téléphone
  crée un nouveau compte anonyme ; « Restaurer mes achats » y rattache l'abonnement chez
  RevenueCat, qui envoie un événement `TRANSFER` (anciens identifiants → nouveaux). Le webhook
  l'ignorait : l'abonné perdait Premium.
- **Décision** :
  - Le webhook traite `TRANSFER` : il garde les identifiants Supabase (UUID) des listes
    `transferred_from` et `transferred_to` (l'événement ne porte ni utilisateur ni produit).
  - Nouvelle fonction SQL `transfer_premium(anciens, nouveaux)`, réservée au serveur : en une
    transaction, elle reporte le droit Premium actif le plus récent des anciens comptes sur les
    nouveaux (via `set_premium`, sans écraser un droit plus récent) et le retire aux anciens.
    Réponses du webhook : `premium_transferred` ou `nothing_to_transfer` ; rejouer l'événement
    est sans effet.
  - App : `restore()` indique si le store voit un abonnement Premium actif
    (`activeSubscriptions`). Si oui, l'app attend la confirmation du serveur comme après un
    achat ; sinon elle répond tout de suite « Aucun abonnement actif ». Nouveau message si le
    serveur tarde : « Abonnement retrouvé : Premium s'active dans quelques instants. »
- **Alternatives écartées** : interroger l'API REST RevenueCat à chaque `TRANSFER` (dépend de la
  clé secrète et d'un appel réseau de plus) ; procédure manuelle permanente (non viable).
- **Conséquences** : les crédits achetés et l'historique ne suivent toujours pas (inchangé). Si
  l'ancien compte n'avait aucun droit connu (webhook manqué, compte supprimé), la réponse est
  `nothing_to_transfer` et la procédure manuelle de `docs/operations.md` s'applique. Prérequis
  RevenueCat : « Restore behavior » = « Transfer to new App User ID » (tâche manuelle 7). Migration
  `20261118090000_premium_transfer` et webhook déployés sur le cloud le 2026-11-18.
- **Impact** : métier (conservation des abonnés) — fort ; sécurité — neutre (fonction réservée au
  serveur, 11 tests pgTAP, 1 test Deno, essai de bout en bout en local).

---

## ADR-026 — Organisation de la documentation

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : documentation)
- **Contexte** : Phase 7 ; l'utilisateur exige une documentation professionnelle, **dans le
  README**, avec l'identité de la marque. Il a explicitement écarté un site de documentation.
- **Décision** :
  - Le **`README.md` est la documentation principale** : bannière au logo, badges, sommaire,
    présentation, fonctionnalités, captures, modèle économique, schéma d'architecture, stack,
    démarrage, configuration, tests, compilation, structure, sécurité, limites connues.
  - Visuels du README dans `docs/assets/readme/` : bannière PNG générée depuis les logos et les
    polices du kit, schéma d'architecture en SVG (lisible partout, sans dépendre de Mermaid).
  - Les **annexes détaillées** restent dans `docs/` (une rubrique par document : architecture,
    flux, données, API, configuration, exploitation, tâches manuelles, guide utilisateur, FAQ et
    support, fiche store, charte éditoriale) et sont reliées depuis le README.
  - **Aide intégrée à l'app** (Réglages → « Aide et questions fréquentes », texte
    `assets/help/faq_fr.txt`), lisible hors connexion.
  - `CHANGELOG.md` au format Keep a Changelog + SemVer.
  - Contenu écrit **à partir du code** et relu par un agent indépendant (23 écarts corrigés) ;
    liens, ancres et images vérifiés par script.
- **Alternatives écartées** : site de documentation (MkDocs) — refusé par l'utilisateur ;
  diagrammes Mermaid dans le README — non affichés par tous les lecteurs Markdown.
- **Conséquences** : toute évolution met à jour le README ou l'annexe concernée dans le même
  changement. Corrigés au passage dans l'app : l'aide et l'écran Premium laissaient croire que la
  capture d'écran était réservée à Premium ; l'aide promettait une restauration de l'abonnement
  après changement de téléphone, impossible tant que l'événement RevenueCat `TRANSFER` n'est pas
  traité (procédure manuelle documentée, correctif à faire avant publication).
- **Impact** : métier (support, stores) — faible.

---

## ADR-025 — Corrections de la phase 5 (qualité, sécurité, performance)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décisions** :
  - **Quotas IA** : table `ai_usage` ; chaque tentative est comptée sous le verrou du
    portefeuille, avant l'appel : 10 par minute et 100 par jour pour tout utilisateur (refus et
    remboursements compris). Le plafond Premium ne dépend plus des lignes de `generations`.
  - **RevenueCat** : achats sandbox ignorés sauf `REVENUECAT_ALLOW_SANDBOX=true` ; pack remboursé
    → crédits restants repris (au plus le montant du pack). **Remplace ADR-017** sur ce point
    (« crédits non repris ») : la revue a montré qu'un achat-utilisation-remboursement était gratuit.
  - **AdMob** : seuls nos blocs d'annonces (`ADMOB_AD_UNIT_IDS`) créditent ; rechargement des
    clés Google limité à une fois par minute.
  - **Signalements** : le texte doit venir de la génération ; 20 par jour.
  - **App** : actions des contrôleurs factorisées (`GuardedAction`, garde anti double tap) ;
    portefeuille relu au retour dans l'app et après création d'une session ; délais maximaux
    (20 s, 70 s pour l'IA) ; lecture tolérante des réponses serveur ; consentement pub
    seulement pour les gratuits ; libellés de boutons en gras (contraste WCAG sans changer les
    couleurs du kit) ; écran de lancement Android au fond du kit.
- **Reportés** : protection anti-comptes en série (décision du propriétaire, tâche 17) ;
  événements RevenueCat `TRANSFER` / tardifs (phase 6, avec la clé secrète RevenueCat).
- **Conséquences** : 4 migrations (`20261118080000` à `080200`), webhooks et fonctions IA à
  redéployer ; 2 nouveaux secrets serveur (tâches 15, 16).

---

## ADR-024 — Confiance, réglages et suppression de compte (Inc-10)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décisions** :
  - **Signalement** : RPC `report_generation` (security definer) — l'utilisateur ne signale que ses
    propres générations, même gratuit (la lecture de `generations` est réservée à Premium). Texte
    signalé copié (examinable même si l'entrée est effacée), supprimé avec le compte. Bouton sur
    les cartes de Résultats.
  - **Suppression de compte** : Edge Function `delete-account` → `auth.admin.deleteUser` (cascade
    sur toutes les tables) ; client RevenueCat effacé si `REVENUECAT_SECRET_API_KEY` est défini.
    L'abonnement store se résilie dans le store (dit à l'utilisateur avant confirmation). Les
    rappels RevenueCat/AdMob visant un compte supprimé répondent 200 (`unknown_user`).
  - **Textes légaux** embarqués (`assets/legal/*.txt`), lisibles hors connexion et avant la
    confirmation d'âge ; éditeur et contact injectés depuis `config/*.json`.
  - **Préférences publicitaires** : formulaire UMP rouvert depuis les réglages, lien affiché
    seulement si le consentement s'applique.
  - Dépendance ajoutée : `url_launcher` (page d'abonnement du store, e-mail au support).
- **Reporté** : rattacher un e-mail (US-04) — nécessite un service d'envoi d'e-mails (SMTP)
  configuré sur Supabase ; le SMTP par défaut n'envoie qu'aux membres de l'équipe.
- **Alternatives écartées** : textes légaux uniquement en ligne (illisibles hors connexion,
  dépendance à un hébergement non encore créé) ; suppression « douce » du compte (contraire au
  droit à l'effacement).

---

## ADR-023 — Historique Premium et suppression (Inc-9)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : l'historique lit `generations` sous RLS (Premium uniquement, déjà en place).
  « Supprimer » appelle `delete_generation`, qui efface le message saisi, le contexte et les
  réponses et marque la ligne (`deleted_at`) ; la règle de suppression directe est retirée.
  Pagination par date (20 entrées), sans compteur total.
- **Pourquoi** : le plafond Premium (100 générations/jour) compte les lignes du jour ; une vraie
  suppression permettait de le contourner. Le contenu, seule donnée personnelle, disparaît bien.
- **Alternatives écartées** : compteur d'usage séparé (plus de code, remboursements à gérer) ;
  garder la suppression directe (faille de facturation).
- **Conséquences** : la suppression du compte (Inc-10) supprime tout par cascade.

---

## ADR-022 — Banque de messages (Inc-8)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : contenu en base (`message_bank`, migration) plutôt qu'embarqué dans l'app :
  modifiable sans nouvelle version. Lecture seule pour tout utilisateur connecté, sans crédit
  (H5). L'app garde la dernière copie dans SharedPreferences (contenu public, non sensible) et
  la sert si le réseau manque ou ne répond pas en 6 s. 8 messages par catégorie, en français,
  respectueux (aucune pression ni manipulation).
- **Reporté** : « personnaliser avec l'IA » (H5) — l'écran Générer couvre déjà ce besoin
  (situations ouverture, relance, rendez-vous, excuses, rupture douce).
- **Alternatives écartées** : fichier JSON embarqué (mise à jour = nouvelle version des stores) ;
  base locale SQLite (dépendance de plus pour 40 lignes).

---

## ADR-021 — Analyse de conversation (Inc-7)

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : nouvelle Edge Function `conversation-analysis` sur le socle `serveAiEndpoint`
  (Premium uniquement, aucun crédit, compte dans le plafond de 100/jour). Entrée : texte collé
  **ou** capture (validation d'image partagée avec `screenshot-reply` via `parseImage`).
  Sortie : dynamique (progresse / stagne / recule), constat et prochaine étape en français,
  message et éventuel rendez-vous dans la langue de la conversation. Le serveur retire toute
  proposition de rendez-vous si la conversation recule (consentement, INTAKE §7).
- **Limite** : conversation ≤ 4000 caractères, alignée sur `generations.input_text` (pas de migration).
- **Alternatives écartées** : ouvrir l'analyse aux gratuits contre crédits (contraire à l'INTAKE
  §2.4) ; migration pour allonger `input_text` (inutile pour un échange collé).
- **Conséquences** : 1 Edge Function de plus à déployer (tâche manuelle de déploiement inchangée).

---

## ADR-020 — Refonte UI conforme au kit de marque, nouveau logo

- **Date** : 2026-11-18
- **Statut** : Accepté (demande de l'utilisateur : « les icônes et fenêtres ne respectent pas le kit »)
- **Décision** : icônes au trait **Lucide** (`lucide_icons_flutter`, centralisées dans `AppIcons`) ;
  logo tiré du nouveau fichier `Logo Flirt Coach con Cuore Brillante.png` → `logo_symbol.png`
  (bulle + étincelles), `logo_wordmark_dark.png`, `logo_horizontal_dark.png` ; icône d'app
  (adaptive Android + iOS) générée par `flutter_launcher_icons`. Écrans refaits selon le kit :
  accueil (logo, wordmark, vague, coches roses), Générer (menu grille, badge crédits doré,
  champs clairs, styles en grille 2 colonnes), menu en feuille du bas, Résultats (cartes
  « Réponse n » avec émoji et copier), Mode Respect, Premium.
- **Correctif lié** : `keepAliveWhile` garde un contrôleur `autoDispose` vivant pendant une
  opération en cours (erreur « Future already completed » vue sur la vidéo récompensée).
- **Alternatives écartées** : Material Icons (style plein, différent du kit) ; SVG redessinés
  à la main (long, risque d'écart avec le logo fourni).
- **Conséquences** : 1 dépendance d'icônes ; le logo d'origine reste dans `assets/images`
  (non embarqué). Vérifié sur émulateur, écran par écran.

---

## ADR-019 — Langue des réponses et transitions

- **Date** : 2026-11-18
- **Statut** : Accepté (demandes de l'utilisateur)
- **Décision** :
  - Les messages proposés sont écrits dans la langue de la conversation (message reçu ou
    texte visible sur la capture), à défaut celle du contexte saisi, en dernier recours en
    français ; consigne explicite que la langue des consignes (français) ne compte pas.
    Les textes destinés à l'utilisateur de l'app (raison d'un refus, explications du mode
    Respect) restent en français, langue de l'interface.
  - Transitions : `FadeForwardsPageTransitionsBuilder` (fondu + glissement Material 3) sur
    Android, sur le fond de la marque ; glissement natif sur iOS.
  - Tests sur téléphone : APK en mode profile (compilé, fluide), le mode debug étant saccadé.
- **Constat lié** : la permission Internet manquait dans le manifeste Android principal
  (présente seulement en debug/profile) : une version publiée n'aurait eu aucun accès réseau.
  Corrigé.
- **Impact** : produit / qualité.

## ADR-018 — Publicités : consentement d'abord, crédits par rappel signé uniquement

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : mobile / backend / security)
- **Contexte** : INTAKE §3.3 (bannière discrète, vidéo +2 crédits, jamais pour Premium, pas de
  plein écran au lancement) ; ADR-008 ; RGPD (UE) et ATT (iOS).
- **Décision** :
  - SDK `google_mobile_ads` 9.2.0. Consentement Google (UMP) demandé avant la toute première
    annonce ; sans consentement exploitable, aucune annonce n'est chargée. iOS : texte de
    suivi (`NSUserTrackingUsageDescription`), demande ATT via le message UMP configuré dans
    AdMob.
  - Bannière adaptative ancrée en bas des écrans Générer et Mode Respect, gratuits seulement.
    Aucune annonce plein écran, aucune au lancement.
  - Vidéo récompensée proposée seulement quand les crédits manquent et qu'il reste des vidéos
    (5/jour). L'identifiant Supabase est transmis à AdMob ; les 2 crédits ne sont accordés
    que par l'Edge Function `admob-ssv`, après vérification de la signature ECDSA de Google
    (clés publiques de Google, en cache 6 h) ; idempotent par `transaction_id`.
  - Portefeuille : une seule fonction SQL `wallet_of` (crédits, Premium, vidéos restantes)
    pour l'app et toutes les Edge Functions.
  - Développement : identifiants d'app et blocs d'annonces **de test publics de Google**.
- **Conséquences** : le rappel AdMob exige une URL publique (Supabase cloud) : en local, la
  vidéo se joue mais les crédits restent « en attente ». Identifiants AdMob réels à fournir
  (tâche manuelle 8) ; lien « préférences publicitaires » à ajouter dans les réglages (Inc-10).
- **Impact** : légal (RGPD, ATT) / financier / sécurité.

## ADR-017 — Achats : le store prévient le serveur, l'app n'accorde jamais de droit

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : backend / security / mobile)
- **Contexte** : INTAKE §3 (abonnements hebdo/mensuel/annuel, packs 20/50/100) ; ADR-004
  (RevenueCat) ; risque R3 (fraude).
- **Décision** :
  - Produits : `flirtcoach_premium_weekly|monthly|annual` (même droit « Premium »),
    `flirtcoach_credits_20|50|100` (consommables). Le nombre de crédits est fixé par le
    serveur. Prix et période d'essai/remise configurés dans les stores, affichés tels quels.
  - App : SDK `purchases_flutter` 11.0.2, identifiant RevenueCat = identifiant Supabase.
    Après un achat, l'app relit le portefeuille (6 essais, 1 s) et annonce honnêtement
    « tes avantages arrivent » si le serveur n'a pas encore reçu l'événement.
  - Serveur : Edge Function `revenuecat-webhook` (sans JWT, secret partagé en
    `Authorization: Bearer …`, comparaison à temps constant). Crédits idempotents
    (`grant_credits`, référence = transaction store, index unique). Premium : un événement
    plus ancien n'écrase pas un plus récent ; résiliation = actif jusqu'à l'échéance ;
    remboursement = retrait immédiat. Remboursement d'un pack : journalisé, non repris
    (les crédits peuvent avoir été dépensés).
  - Offre J+3 : date de première utilisation stockée sur le téléphone, paywall « annuel mis
    en avant » montré une seule fois aux non-abonnés (H8).
- **Conséquences** : comptes Google Play, Apple et RevenueCat requis pour tester un vrai achat
  (tâches manuelles 4 à 7). Sans clé RevenueCat, le paywall affiche « achats indisponibles ».
- **Impact** : financier / sécurité.

## ADR-016 — Capture d'écran : lue par Claude, jamais stockée

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : backend / security)
- **Contexte** : INTAKE §2.2 (capture → 3 réponses, 2 crédits ou Premium) et §7.3 (pas de
  conservation au-delà du nécessaire) ; la capture contient les messages d'un tiers.
- **Décision** : sélecteur de photos du système (`image_picker`, aucune permission permanente
  sur la galerie) ; image réduite sur le téléphone (1280 px de large, JPEG 85 %) ; envoyée en
  base64 à l'Edge Function `screenshot-reply`, qui vérifie le vrai type dans les octets
  (PNG/JPEG/WebP/GIF), limite à 3,5 Mo, la transmet à Claude puis l'oublie. Seules les
  3 réponses sont enregistrées (`input_text` nul). Capture illisible → 422, crédits rendus.
- **Conséquences** : la capture transite par l'API Anthropic (sous-traitant à déclarer dans la
  politique de confidentialité, Inc-10). Pas de « rouvrir la capture » depuis l'historique.
- **Impact** : légal / sécurité.

## ADR-015 — Outils de l'incrément 1

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `freezed` pour les modèles du domaine (fichiers générés versionnés, régénérés
  en CI). Edge Function en Deno avec dépendances épinglées dans
  `supabase/functions/generate/deno.json` : SDK Anthropic **1.9.0** (la 1.10.0, publiée la
  veille, est bloquée par la règle Deno d'âge minimal des dépendances — règle conservée),
  `supabase-js` 2.119.0. Tests et vérifications Deno lancés via l'image Docker
  `denoland/deno:2.9.8` : pas d'installation de Deno sur le poste.
- **Impact** : technique (réversible).

## ADR-014 — Modèle IA de génération : Claude Opus 5.5, effort bas

- **Date** : 2026-11-18
- **Statut** : Accepté (coût à confirmer par l'utilisateur, voir PROJECT_STATE Q9)
- **Contexte** : génération de 3 messages courts, attendue en quelques secondes, à fort volume.
- **Décision** : `claude-opus-5-5`, `output_config.effort: "low"` (tâche courte, sensible à la
  latence), sortie JSON contrainte par schéma (`output_config.format`), repli serveur activé en
  cas de refus des garde-fous (`fallbacks: "default"`, bêta `server-side-fallback-2026-07-01`).
  Délai 25 s, 1 nouvelle tentative SDK. Le texte utilisateur est délimité et traité comme une
  donnée ; aucun contenu utilisateur dans les journaux.
- **Coût estimé** (tarif 4 $ / 20 $ par million de jetons entrée/sortie) : ~600 jetons en
  entrée et ~500 en sortie (réflexion comprise) ≈ **0,01 $ par génération**, à mesurer sur
  trafic réel. Gratuit à 5/jour ≈ 0,05 $/jour/utilisateur actif ; Premium plafonné à 100/jour.
- **Alternatives** : Claude Haiku 5.5 (0,10 $ / 0,50 $, environ 40 fois moins cher, qualité
  d'écriture inférieure) — choix financier laissé à l'utilisateur ; le modèle est une constante
  dans `supabase/functions/generate/index.ts`.
- **Impact** : financier (réversible en une ligne).

## ADR-013 — Dépendances du socle

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `flutter_riverpod` 2.6 (version résolue par le SDK installé ; pas de
  génération de code tant que les providers restent simples), `go_router`, `supabase_flutter`,
  `flutter_secure_storage` (session dans Keychain/Keystore, remplace le stockage par défaut en
  préférences), `shared_preferences` (drapeau local de confirmation d'âge, non sensible),
  `flutter_localizations` + `intl`. `freezed` sera ajouté avec le premier modèle (Inc-1).
- **Alternatives écartées** : `google_fonts` (télécharge les polices à l'exécution) → polices
  Poppins et Inter embarquées (licence OFL, fichiers de licence joints dans `assets/fonts/`).
- **Impact** : technique (réversible).

## ADR-012 — Thème sombre unique

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : le gabarit du rôle UI/UX prévoit clair + sombre ; le kit de marque ne définit
  qu'une identité néon sur fond sombre.
- **Décision** : un seul thème (sombre) en V1.
- **Conséquences** : un thème clair demanderait une déclinaison du kit.
- **Impact** : design (réversible).

## ADR-011 — Environnements par fichier de configuration, sans flavors natifs

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décision** : `--dart-define-from-file=config/dev.json` (Supabase local) ou
  `config/prod.json` (cloud). Pas de flavors Android/iOS tant qu'un seul identifiant
  d'application suffit.
- **Alternatives écartées** : flavors dev/staging/prod (configuration native lourde, sans
  besoin actuel).
- **Impact** : technique (réversible).

## ADR-010 — Identité visuelle : kit de marque néon

- **Date** : 2026-11-18
- **Statut** : Accepté (demande utilisateur)
- **Contexte** : `Kit di brand Flirt Coach in stile neon.png` (racine du projet) fait foi pour
  toute l'interface.
- **Décision** : nom **Flirt Coach**, sous-titre « Coach de drague et messages ». Couleurs :
  primaire `#FF4D79` (actions/CTA), secondaire `#9B5CFF` (accents, icônes), fond principal
  `#1A1033`, fond clair `#FFD6E6` (cartes, sections), surface `#F8F8FC`. Typos : **Poppins**
  Bold/SemiBold (titres, boutons), **Inter** Regular/Medium (textes). Thème sombre néon avec
  dégradé rose→violet, boutons pilule, logo bulle + cœur. Les 3 écrans du kit (accueil,
  « Générer un message », « Résultats ») servent de maquettes de référence.
- **Conséquences** : tokens centralisés dans le thème Flutter ; polices embarquées dans l'app
  (pas de téléchargement à l'exécution). Le kit est une image : logo et icône devront être
  fournis en fichiers sources (SVG/PNG haute définition) ou redessinés.
- **Écarts kit ↔ INTAKE à trancher** : le kit montre « Coach de profil » (voir ADR-007) et le
  style « Drôle » déverrouillé alors que l'INTAKE §2.3 le classe en avancé/Premium.
- **Impact** : design (réversible).

## ADR-009 — Base de données de développement : Supabase local sous Docker

- **Date** : 2026-11-18
- **Statut** : Accepté (demande utilisateur)
- **Contexte** : tout le développement doit s'appuyer sur une base tournant dans Docker.
- **Décision** : pile Supabase locale (`supabase start` : Postgres, Auth, Storage, Edge
  Functions dans des conteneurs Docker). Schéma, RLS et données de test versionnés dans
  `supabase/migrations` et `supabase/seed.sql`. Aucun projet Supabase cloud avant la phase de
  publication ; les mêmes migrations y seront alors appliquées.
- **Alternatives écartées** : projet cloud dès le début (contraire à la demande) ; Postgres nu
  dans Docker (perd Auth, RLS liée à l'auth et Edge Functions, donc s'écarte de la production).
- **Conséquences** : Docker Desktop doit être installé et démarré (absent du poste au
  2026-11-18). L'émulateur Android joint la base via `10.0.2.2`.
- **Impact** : technique (réversible).

## ADR-008 — Publicité : AdMob, récompense validée côté serveur

- **Date** : 2026-11-18
- **Statut** : Accepté — mis en œuvre en Inc-6 (voir ADR-018)
- **Décideur** : Claude (rôle : project-director)
- **Contexte** : INTAKE §3.3 — bannière discrète + vidéo récompensée (+2 crédits), jamais pour
  les Premium, catégories « adulte » et « rencontre » exclues.
- **Décision** : `google_mobile_ads` (AdMob). Crédits de récompense accordés uniquement par le
  rappel serveur (SSV) vers une Edge Function, plafonnés à 5 vidéos/jour. Consentement RGPD
  (UMP) et ATT iOS avant toute pub. Catégories sensibles bloquées dans la console AdMob.
- **Alternatives écartées** : créditer côté client (fraude triviale) ; autres régies (moins de
  remplissage, intégration Flutter moins mûre).
- **Conséquences** : compte AdMob à créer (tâche manuelle) ; le plafond 5/jour est une hypothèse.
- **Impact** : technique + métier faible (réversible).

## ADR-007 — « Coach de profil » hors périmètre V1

- **Date** : 2026-11-18
- **Statut** : Accepté (à confirmer par l'utilisateur)
- **Contexte** : cité aux §3.1 et §5 de l'INTAKE, mais ni décrit au §2 ni listé au §9, qui
  précise que la V1 comprend « exclusivement » les fonctionnalités énumérées.
- **Décision** : ne pas le livrer en V1 et ne pas l'afficher dans le paywall.
- **Alternatives écartées** : l'inventer sans spécification (exigence non décrite).
- **Conséquences** : à spécifier pour une V1.1 si souhaité.
- **Remise en question** : le kit de marque l'affiche (icône « Coach de profil », « Améliore
  ton profil » sur l'accueil). Question Q7 posée à l'utilisateur.
- **Impact** : fonctionnel (réversible).

## ADR-006 — Captures d'écran jamais stockées

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : INTAKE §7.3 ; les captures contiennent les données d'un tiers non consentant.
- **Décision** : l'image est envoyée à l'Edge Function, transmise à l'IA, puis jetée. Aucun
  dépôt dans Supabase Storage, aucun log du contenu. L'historique ne conserve que les réponses
  générées.
- **Alternatives écartées** : stockage temporaire avec purge (surface de risque inutile).
- **Conséquences** : impossible de « ré-ouvrir » une capture depuis l'historique.
- **Impact** : légal / sécurité.

## ADR-005 — Crédits : ledger serveur, 1 crédit = 1 génération

- **Date** : 2026-11-18
- **Statut** : Accepté (hypothèse H1 à confirmer)
- **Contexte** : INTAKE contradictoire (« 3 à 5 générations/jour » vs « 5 crédits/jour » ;
  « 1 crédit = 1 message » alors qu'une génération renvoie 3 propositions).
- **Décision** : 1 crédit = 1 génération (3 propositions) ; capture = 2 crédits. Gratuit :
  solde quotidien remis à 5, non cumulable. Crédits achetés ou récompensés : sans expiration,
  consommés après les crédits du jour. Tout mouvement passe par une Edge Function / fonction
  SQL `security definer` ; le client n'a qu'un accès lecture (RLS).
- **Alternatives écartées** : compteur côté client (falsifiable) ; 1 crédit par proposition
  (3 crédits pour une réponse : gratuit inutilisable).
- **Conséquences** : pas de génération hors-ligne ; solde toujours fiable.
- **Impact** : métier + sécurité.

## ADR-004 — Achats intégrés : RevenueCat

- **Date** : 2026-11-18
- **Statut** : Accepté (option par défaut validée par l'utilisateur le 2026-11-18)
- **Contexte** : 3 abonnements + 3 consommables sur deux stores, avec validation serveur,
  renouvellements, remboursements, offre promotionnelle annuelle.
- **Décision proposée** : `purchases_flutter` (RevenueCat) + webhook vers une Edge Function qui
  met à jour `entitlements` et `credit_ledger`.
- **Alternatives écartées** : `in_app_purchase` + validation maison des reçus Apple/Google
  (plusieurs semaines de travail, source classique de bugs de facturation).
- **Conséquences** : dépendance à un tiers ; gratuit sous un seuil de revenus puis commission
  (barème à vérifier sur leur site au moment de la création du compte).
- **Impact** : financier (réversible avec effort).

## ADR-003 — IA appelée uniquement depuis une Edge Function

- **Date** : 2026-11-18
- **Statut** : Accepté (fournisseur par défaut validé par l'utilisateur le 2026-11-18)
- **Contexte** : aucun secret dans le binaire ; modération et quotas doivent être inviolables.
- **Décision** : l'app n'appelle jamais l'IA directement. Une Edge Function authentifie,
  vérifie le quota, débite, construit le prompt (règles éthiques §1.4 et §7.2), appelle le
  modèle, valide la sortie structurée, enregistre l'historique. Fournisseur proposé : API
  Claude (texte + vision), modèle rapide choisi en phase 3.
- **Alternatives écartées** : appel direct depuis l'app (clé exposée, quotas contournables).
- **Conséquences** : coût à l'usage ; fournisseur interchangeable derrière la fonction.
- **Impact** : sécurité + financier.

## ADR-002 — Authentification anonyme, rattachement e-mail optionnel

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : le parcours §4 démarre directement sur « Colle son dernier message » ; mais
  crédits, Premium et historique exigent une identité serveur.
- **Décision** : session anonyme Supabase au premier lancement ; rattachement d'un e-mail
  proposé (non imposé) pour retrouver son compte sur un autre appareil. Jetons en stockage
  sécurisé. Suppression de compte in-app.
- **Alternatives écartées** : inscription obligatoire (friction avant la première valeur) ;
  connexions sociales (imposent « Sign in with Apple », non demandé).
- **Conséquences** : un utilisateur gratuit qui désinstalle sans e-mail perd ses crédits
  achetés ; les abonnements restent restaurables via le store.
- **Impact** : métier faible, technique.

## ADR-001 — Gestion d'état : Riverpod

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Décideur** : Claude (rôle : mobile-architect / state-management-engineer)
- **Contexte** : Besoin d'une gestion d'état Flutter testable, sûre et scalable.
- **Décision** : Utiliser **Riverpod** (stack imposée par CLAUDE.md).
- **Alternatives écartées** : Bloc (plus verbeux), Provider seul, setState, GetX.
- **Conséquences** : État découplé de `BuildContext`, providers testables.
- **Impact** : technique (réversible avec effort).

---

## ADR-000 — Modèle d'enregistrement

- **Date** : 2026-11-18
- **Statut** : Accepté
- **Contexte** : Établit le format des décisions. À copier pour chaque nouvelle entrée.
- **Décision** : Utiliser ce gabarit pour toute décision ayant un impact sur l'architecture,
  les dépendances, la sécurité, le coût ou le comportement produit.
- **Conséquences** : Traçabilité complète ; l'utilisateur peut revenir sur tout choix.

---

<!-- Copier ce bloc pour chaque nouvelle décision :

## ADR-NNN — <titre court>

- **Date** :
- **Statut** : Proposé / Accepté / Remplacé par ADR-XXX
- **Décideur** : Claude (rôle : <ex. mobile-architect>)
- **Contexte** :
- **Décision** :
- **Alternatives écartées** :
- **Conséquences** :
- **Impact** : technique / financier / métier / sécurité (et niveau)

-->
