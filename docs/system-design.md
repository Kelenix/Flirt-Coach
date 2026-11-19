# Flux principaux

Séquences des parcours critiques, telles qu'implémentées. Complète
[`architecture.md`](architecture.md) (structure) et [`api-reference.md`](api-reference.md) (contrats).

## 1. Premier lancement

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant Auth as Supabase Auth
  participant DB as Postgres
  U->>App: coche « J'ai 18 ans ou plus », Commencer
  App->>Auth: connexion anonyme
  Auth->>DB: nouvel utilisateur → profil + solde de 5 crédits (trigger)
  App->>DB: confirm_age()
  App->>App: confirmation mémorisée localement, portefeuille relu
  App-->>U: écran Générer
```

Les lancements suivants ouvrent directement l'écran Générer (session dans le Keychain/Keystore).
Sans réseau au premier lancement, rien n'est mémorisé et « Commencer » peut être relancé.

## 2. Génération (et Mode Respect, capture, analyse)

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant EF as Edge Function
  participant DB as Postgres
  participant AI as Claude
  U->>App: message + situation + style, Générer
  App->>EF: POST /generate (jeton)
  EF->>DB: âge, Premium, spend_credits (quotas + débit sous verrou)
  EF->>AI: consignes + données balisées, sortie JSON imposée
  alt réponses valides
    EF->>DB: génération enregistrée
    EF-->>App: 3 propositions + portefeuille
  else refus du coach / capture illisible / erreur
    EF->>DB: refund_credits
    EF-->>App: refus motivé ou code d'erreur
  end
  App-->>U: Résultats (ou message clair)
```

Un double tap est ignoré par l'app ; deux requêtes simultanées sont comptées une à une par le
verrou du portefeuille côté serveur.

## 3. Achat (abonnement ou pack)

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant Store as Google Play / App Store
  participant RC as RevenueCat
  participant EF as revenuecat-webhook
  participant DB as Postgres
  U->>App: choisit une offre
  App->>RC: achat (SDK)
  RC->>Store: paiement
  Store-->>RC: reçu validé
  RC->>EF: webhook (secret partagé)
  EF->>DB: set_premium() ou grant_credits() — idempotent
  loop jusqu'à confirmation (quelques secondes)
    App->>DB: get_wallet()
  end
  App-->>U: « Bienvenue dans Premium ! » / « Tes crédits ont été ajoutés. » / « Achat validé par le store… »
```

L'app n'accorde jamais un droit elle-même : elle attend que le serveur l'ait reçu. Un
remboursement passe par le même webhook (Premium retiré, crédits restants repris).

## 4. Vidéo récompensée

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant Ad as AdMob
  participant EF as admob-ssv
  participant DB as Postgres
  U->>App: « Regarder une pub (+2 crédits) »
  App->>Ad: affiche la vidéo (identifiant utilisateur joint)
  Ad->>EF: rappel signé (ECDSA) une fois la vidéo vue
  EF->>EF: signature + bloc d'annonces autorisé
  EF->>DB: claim_ad_reward() — 5 par jour, anti-rejeu
  App->>DB: get_wallet() jusqu'à voir les crédits
```

## 5. Suppression du compte

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant EF as delete-account
  participant RC as RevenueCat
  participant Auth as Supabase Auth
  U->>App: Réglages → Supprimer mon compte → confirmer
  App->>EF: POST /delete-account (jeton)
  EF->>RC: suppression du client (si clé configurée)
  EF->>Auth: suppression de l'utilisateur → cascade sur toutes les tables
  App->>App: session locale fermée, préférences effacées
  App-->>U: accueil 18+ (premier lancement)
```

Un abonnement en cours n'est pas résilié par cette opération (l'utilisateur en est informé
avant de confirmer) : il se gère dans le store.

## 6. Restauration sur un nouveau téléphone

```mermaid
sequenceDiagram
  actor U as Utilisateur
  participant App
  participant RC as RevenueCat
  participant EF as revenuecat-webhook
  participant DB as Postgres
  U->>App: nouvelle installation, « Restaurer mes achats »
  App->>RC: restauration (SDK)
  RC-->>App: abonnement actif retrouvé
  RC->>EF: TRANSFER (ancien compte → nouveau)
  EF->>DB: transfer_premium() — Premium déplacé
  loop jusqu'à confirmation (quelques secondes)
    App->>DB: get_wallet()
  end
  App-->>U: « Achats restaurés : Premium est actif. »
```

La nouvelle installation a un nouveau compte anonyme : l'abonnement la suit, l'ancien compte perd
Premium. Si le store ne trouve aucun abonnement actif, l'app répond tout de suite « Aucun
abonnement actif à restaurer pour ce compte store. » ; si le serveur tarde, elle l'indique
(« Abonnement retrouvé : Premium s'active dans quelques instants. »).
