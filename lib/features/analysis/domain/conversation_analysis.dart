import 'package:freezed_annotation/freezed_annotation.dart';

import '../../credits/domain/wallet.dart';

part 'conversation_analysis.freezed.dart';

/// Dynamique de la conversation (INTAKE §2.4).
enum Momentum {
  progressing('progressing'),
  stalling('stalling'),
  declining('declining');

  const Momentum(this.apiName);

  final String apiName;

  /// Valeur inconnue (serveur plus récent) : « stagne », la lecture la plus neutre.
  static Momentum fromApi(String? value) => values.firstWhere(
    (momentum) => momentum.apiName == value,
    orElse: () => Momentum.stalling,
  );
}

@freezed
sealed class ConversationAnalysis with _$ConversationAnalysis {
  /// Analyse complète ; [dateSuggestion] n'existe que si le contexte s'y prête.
  const factory ConversationAnalysis.result({
    required Momentum momentum,
    required String summary,
    required String nextStep,
    required String suggestedMessage,
    required String? dateSuggestion,
    required Wallet wallet,
  }) = AnalysisResult;

  /// Le coach a refusé d'analyser.
  const factory ConversationAnalysis.refused({
    required String reason,
    required Wallet wallet,
  }) = AnalysisRefused;
}
