import 'dart:typed_data';

import 'conversation_analysis.dart';

/// Analyse de conversation, réservée à Premium. Les erreurs sont des `Failure`.
abstract interface class AnalysisRepository {
  /// Exactement un de [conversation] (texte collé) ou [screenshot].
  Future<ConversationAnalysis> analyze({
    String? conversation,
    Uint8List? screenshot,
    String? context,
  });
}
