# Référence de l'API serveur

Contrats entre l'app et le serveur Supabase. Base : `https://<ref>.supabase.co`.
API interne : elle n'est pas destinée à des tiers et peut évoluer avec l'app.

- **Edge Functions** : `POST /functions/v1/<nom>`, corps JSON.
- **Appels SQL (RPC)** : `POST /rest/v1/rpc/<fonction>`, en-têtes `apikey` + `Authorization`.

Les fonctions appelées par l'app exigent `Authorization: Bearer <jeton de session>` (session
anonyme Supabase) ; le SDK Supabase l'ajoute automatiquement.

## Parcours commun des fonctions IA

1. Méthode `POST` et jeton vérifiés → sinon `400 invalid_request` (autre méthode) ou
   `401 unauthorized`.
2. Corps validé → sinon `400 invalid_request`.
3. Âge confirmé → sinon `403 age_not_confirmed`.
4. Premium si requis → sinon `403 premium_required`.
5. Quota et débit sous verrou → `429 rate_limited` (10/min), `429 daily_limit` (100/jour),
   `402 insufficient_credits`.
6. Appel du modèle → en cas d'échec, remboursement et `503 ai_unavailable`.
7. Refus du coach → `200` avec `{"refused": true, "reason": "…", "wallet": {…}}`, crédits
   remboursés. `reason` est l'explication du coach ; l'app l'affiche, ou son message de refus
   par défaut s'il est vide.

### Portefeuille (renvoyé par chaque réponse réussie)

```json
{ "daily_credits": 4, "bonus_credits": 0, "is_premium": false, "ad_rewards_left": 5 }
```

### Erreurs

Corps : `{"error": "<code>"}`.

| HTTP | Code | Signification | Message affiché par l'app |
|------|------|---------------|---------------------------|
| 400 | `invalid_request` | corps invalide (champ manquant, trop long, mauvais type d'image) | erreur inattendue |
| 401 | `unauthorized` | jeton absent ou invalide | erreur inattendue |
| 402 | `insufficient_credits` | crédits insuffisants | « Tu as utilisé tes crédits du jour… » + vidéo / Premium |
| 403 | `age_not_confirmed` | âge non déclaré | — (l'app l'impose avant) |
| 403 | `premium_required` | fonction ou style réservé à Premium | « Débloque les styles avancés avec Premium. » et bouton « Passer Premium » |
| 422 | `unusable_input` | capture sans conversation lisible (remboursée) | « Impossible de lire une conversation… » |
| 429 | `rate_limited` | plus de 10 appels dans la minute | « Tu vas un peu vite… » |
| 429 | `daily_limit` | 100 appels dans la journée (UTC) | « Tu as atteint la limite de générations pour aujourd'hui… » |
| 503 | `ai_unavailable` | modèle indisponible (remboursé) | « Le coach est momentanément indisponible… » |

## `generate` — 3 réponses

| Champ | Type | Règle |
|-------|------|-------|
| `situation` | texte | `reply`, `opener`, `flirt`, `follow_up`, `pre_date`, `apology`, `soft_breakup` |
| `style` | texte | `classic` (gratuit) ou `funny`, `romantic`, `mysterious`, `direct`, `elegant`, `playful_bold` (Premium) |
| `message` | texte | obligatoire **si et seulement si** `situation = reply` ; ≤ 2000 caractères |
| `context` | texte | facultatif ; ≤ 1000 caractères |

Coût : 1 crédit (inclus en Premium).

```json
{ "refused": false, "id": "uuid", "proposals": ["…", "…", "…"], "wallet": { } }
```

## `screenshot-reply` — 3 réponses à partir d'une capture

| Champ | Type | Règle |
|-------|------|-------|
| `image` | base64 | PNG, JPEG, WebP ou GIF (type lu dans les octets) ; ≤ 3,5 Mo décodés |
| `style` | texte | comme `generate` |
| `context` | texte | facultatif ; ≤ 1000 caractères |

Coût : 2 crédits (inclus en Premium). Réponse identique à `generate`. L'image n'est ni stockée
ni journalisée.

## `respect-check` — Mode Respect

| Champ | Type | Règle |
|-------|------|-------|
| `message` | texte | obligatoire ; ≤ 2000 caractères |
| `context` | texte | facultatif ; ≤ 1000 caractères |

Coût : 1 crédit (inclus en Premium).

```json
{
  "refused": false, "id": "uuid", "is_respectful": false,
  "issues": [{ "category": "insistent", "explanation": "…" }],
  "alternative": "…", "wallet": { }
}
```

`category` : `insistent`, `sexualized`, `manipulative`. `alternative` vaut `null` si le message
est respectueux. Les explications sont en français ; l'alternative est dans la langue du message.

## `conversation-analysis` — analyse (Premium)

| Champ | Type | Règle |
|-------|------|-------|
| `conversation` | texte | ≤ 4000 caractères — **ou** |
| `image` | base64 | capture, mêmes règles que `screenshot-reply` |
| `context` | texte | facultatif ; ≤ 1000 caractères |

Exactement un de `conversation` ou `image`. Inclus dans Premium (compte dans le quota du jour).

```json
{
  "refused": false, "id": "uuid", "momentum": "progressing",
  "summary": "…", "next_step": "…", "suggested_message": "…",
  "date_suggestion": "…", "wallet": { }
}
```

`momentum` : `progressing`, `stalling`, `declining`. `date_suggestion` vaut `null` si le contexte
ne s'y prête pas, et toujours `null` quand la conversation recule.

## `delete-account` — suppression du compte

Corps vide. Supprime l'utilisateur et, en cascade, toutes ses données ; efface aussi le client
RevenueCat si `REVENUECAT_SECRET_API_KEY` est défini. N'annule pas un abonnement en cours (géré
par le store).

| HTTP | Corps |
|------|-------|
| 200 | `{"deleted": true}` |
| 401 | `{"error": "unauthorized"}` |
| 405 | `{"error": "method"}` (autre méthode que `POST`) |
| 500 | `{"error": "delete_failed"}` |

## `revenuecat-webhook` — événements d'achat (appelé par RevenueCat)

En-tête obligatoire : `Authorization: Bearer <REVENUECAT_WEBHOOK_SECRET>` (comparaison en temps
constant). Corps : format d'événement RevenueCat.

| Événement | Effet |
|-----------|-------|
| `NON_RENEWING_PURCHASE` d'un pack | crédite 20, 50 ou 100 crédits (une fois par transaction) |
| `CANCELLATION` (`CUSTOMER_SUPPORT`) d'un pack | reprend les crédits restants, au plus le montant du pack |
| `INITIAL_PURCHASE`, `RENEWAL`, `UNCANCELLATION`, `PRODUCT_CHANGE`, `SUBSCRIPTION_EXTENDED`, … | Premium actif jusqu'à l'échéance |
| `EXPIRATION` | Premium retiré |
| `TRANSFER` | abonnement restauré sur une nouvelle installation : Premium déplacé des anciens comptes vers le nouveau |
| `CANCELLATION` (`CUSTOMER_SUPPORT`) d'un abonnement | remboursement : Premium retiré immédiatement |
| simple résiliation, `TEST`, produit inconnu | ignoré |
| environnement `SANDBOX` | ignoré, sauf `REVENUECAT_ALLOW_SANDBOX=true` |

| Réponse | Sens |
|---------|------|
| `200 {"status": "credited"}` | pack crédité |
| `200 {"status": "duplicate"}` | transaction déjà traitée |
| `200 {"status": "revoked", "amount": n}` | crédits repris après remboursement (`n` peut valoir 0) |
| `200 {"status": "premium_on"}`, `200 {"status": "premium_off"}` | Premium activé ou retiré |
| `200 {"status": "premium_transferred"}` | Premium déplacé vers le nouveau compte (`TRANSFER`) |
| `200 {"status": "nothing_to_transfer"}` | `TRANSFER` reçu, mais aucun abonnement actif connu pour les anciens comptes |
| `200 {"status": "ignored", "reason": "…"}` | événement sans effet ; motif : `test`, `sandbox`, `unknown_user` (identifiant qui n'est pas un UUID), `no_product`, `unknown_product`, `pack_<TYPE>` ou le type d'événement |
| `200 {"status": "unknown_user"}` | compte supprimé entre-temps |
| `400 {"error": "malformed_event"}` | corps illisible |
| `401 {"error": "unauthorized"}` | secret absent ou différent |
| `405 {"error": "method"}` | autre méthode que `POST` |
| `500` | erreur interne : RevenueCat renverra l'événement |

Le motif d'un `ignored` n'est pas écrit dans les journaux Supabase : il se lit dans RevenueCat →
Webhooks, dans le détail de chaque envoi.

## `admob-ssv` — récompense vidéo (appelé par Google)

`GET` avec les paramètres de rappel AdMob (`ad_unit`, `key_id`, `transaction_id`, `user_id`,
`signature`, …). Vérifie la signature ECDSA avec les clés publiques de Google et que `ad_unit`
figure dans `ADMOB_AD_UNIT_IDS`.

| HTTP | Corps |
|------|-------|
| 200 | `status` : `credited`, `duplicate`, `daily_limit`, `premium` ou `unknown_user` |
| 400 | `error` : `params`, `signature`, `user_id` ou `key_id` |
| 403 | `error` : `bad_signature` ou `ad_unit` |
| 405 | `error` : `method` (autre méthode que `GET`) |
| 500 | erreur interne : AdMob réessaiera |

Les journaux Supabase ne montrent que le code HTTP : un 403 ne distingue pas une signature
invalide d'un bloc non autorisé.

## Appels SQL (RPC) utilisés par l'app

| Fonction | Corps | Réponse |
|----------|-------|---------|
| `confirm_age` | `{}` | 204 |
| `get_wallet` | `{}` | `[{"daily_credits", "bonus_credits", "is_premium", "ad_rewards_left"}]` |
| `delete_generation` | `{"p_id": "uuid"}` | 204 (sans effet si l'entrée n'est pas à l'appelant) |
| `report_generation` | `{"p_generation": "uuid", "p_text": "…", "p_reason": "offensive"}` | 204 ; `400 not_found` si le texte ne vient pas de cette génération ; `400 report_limit` au-delà de 20 par 24 h glissantes |

Lectures directes (sous RLS) : `message_bank` (banque), `generations` (historique Premium,
pagination par `created_at` puis `id`).
