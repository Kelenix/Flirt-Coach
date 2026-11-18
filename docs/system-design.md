# Conception détaillée — Flirt Coach

> Phase 3 — System Design. Le domaine ne connaît pas Supabase : il ne voit que ces contrats.

## Erreurs typées

`Failure` (classe scellée) : `NetworkFailure` · `InsufficientCreditsFailure` ·
`PremiumRequiredFailure` · `ModerationFailure` (demande refusée) · `DailyLimitFailure` ·
`UnreadableImageFailure` · `UnexpectedFailure`. Chaque écran traduit un `Failure` en message
utilisateur ; aucun message technique brut n'est affiché.

## Contrats des repositories

```dart
abstract interface class AuthRepository {
  bool get hasSession;
  Future<void> signInAnonymously();          // sans effet si une session existe
  Future<void> confirmAge();                 // RPC confirm_age()
  Future<void> linkEmail(String email);      // Inc-10
  Future<void> deleteAccount();              // Inc-10, Edge Function
}

abstract interface class GenerationRepository {            // Inc-1 → Inc-4, Inc-7
  Future<GenerationResult> generate(GenerationRequest request);
  Future<GenerationResult> replyToScreenshot(Uint8List image, MessageStyle style);
  Future<RespectVerdict> checkRespect(String draft);
  Future<ConversationAnalysis> analyze(String conversation);
}

abstract interface class WalletRepository {                // Inc-1, Inc-5, Inc-6
  Future<Wallet> fetch();      // crédits du jour, crédits bonus, isPremium
}

abstract interface class HistoryRepository {               // Inc-9
  Future<List<Generation>> page({DateTime? before, int limit = 20});
  Future<void> delete(String id);
}

abstract interface class MessageBankRepository {           // Inc-8
  Future<List<BankMessage>> byCategory(BankCategory category);
}

abstract interface class ReportRepository {                // Inc-10
  Future<void> report({required String proposal, required ReportReason reason, String? generationId});
}
```

Entités freezed : `GenerationRequest(situation, style, receivedMessage?, context?)`,
`GenerationResult(id, proposals[3], wallet)`, `Wallet(daily, bonus, isPremium)`.

## Flux critique 1 — premier lancement

```mermaid
sequenceDiagram
  participant U as Utilisateur
  participant App
  participant Auth as Supabase Auth
  participant DB as Postgres
  U->>App: coche « 18 ans ou plus », Commencer
  App->>Auth: signInAnonymously()
  Auth->>DB: insert auth.users → trigger crée profiles
  App->>DB: rpc confirm_age()
  App->>App: mémorise la confirmation, route « / »
  Note over App: échec réseau → message + Réessayer, rien n'est mémorisé
```

## Flux critique 2 — génération

```mermaid
sequenceDiagram
  participant App
  participant EF as Edge Function generate
  participant DB as Postgres
  participant IA
  App->>EF: POST {situation, style, texte} + JWT
  EF->>EF: valide l'entrée (longueur, énumérations)
  EF->>DB: profil confirmé ? premium ? style autorisé ?
  EF->>DB: consume_credits(coût) — atomique, échoue si solde insuffisant
  EF->>IA: prompt système (règles éthiques) + texte utilisateur isolé
  IA-->>EF: JSON {refused, proposals[3]}
  alt réponse valide
    EF->>DB: insert generations
    EF-->>App: 200 {proposals, wallet}
  else refus, erreur IA ou délai dépassé
    EF->>DB: refund_credits(coût)
    EF-->>App: 422 moderation / 502 erreur
  end
```

Le débit précède l'appel IA (sinon deux requêtes simultanées dépensent le même crédit) et
est remboursé en cas d'échec. Premium : pas de débit, mais compteur journalier (plafond 100).

## Résilience

| Sujet | Règle |
|-------|-------|
| Délai | 30 s côté app pour une génération ; 25 s côté fonction vers l'IA |
| Nouvelle tentative | aucune automatique sur une génération (éviter un double débit) ; l'utilisateur relance |
| Idempotence | achats et récompenses identifiés par l'identifiant de transaction (contrainte `unique`) |
| Pagination | historique par curseur (`created_at`), 20 par page |
| Realtime | non utilisé ; le portefeuille est renvoyé par chaque réponse et relu à l'ouverture |

## Sécurité du prompt

Le texte collé et le contenu d'une capture sont transmis comme données délimitées, jamais
concaténés aux consignes. Le modèle n'a aucun outil. La sortie doit respecter un schéma JSON
strict ; toute sortie non conforme est traitée comme une erreur (remboursement).
