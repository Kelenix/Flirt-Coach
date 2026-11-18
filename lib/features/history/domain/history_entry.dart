/// Entrée de l'historique Premium (INTAKE §2.7) : texte seulement, jamais d'image.
final class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.kind,
    required this.createdAt,
    required this.input,
    required this.results,
  });

  final String id;

  /// `generation_kind` en base : une situation, `screenshot`, `respect_check`
  /// ou `conversation_analysis`.
  final String kind;
  final DateTime createdAt;

  /// Message saisi par l'utilisateur, s'il y en a un.
  final String? input;

  /// Textes prêts à copier : propositions, alternative respectueuse, message conseillé.
  final List<String> results;
}

/// Historique Premium. Les erreurs sont des `Failure`.
abstract interface class HistoryRepository {
  /// Entrées les plus récentes d'abord, situées après [after] (dernière entrée
  /// de la page précédente) si fourni.
  Future<List<HistoryEntry>> fetchPage({
    HistoryEntry? after,
    required int limit,
  });

  /// Efface le contenu de l'entrée ; elle disparaît de l'historique.
  Future<void> delete(String id);
}
