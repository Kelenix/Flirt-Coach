import 'package:freezed_annotation/freezed_annotation.dart';

import '../../credits/domain/wallet.dart';

part 'generation_result.freezed.dart';

@freezed
sealed class GenerationResult with _$GenerationResult {
  /// Propositions prêtes à copier.
  const factory GenerationResult.proposals({
    required String id,
    required List<String> proposals,
    required Wallet wallet,
  }) = GeneratedProposals;

  /// Demande refusée par la modération ; aucun crédit débité.
  const factory GenerationResult.refused({
    required String reason,
    required Wallet wallet,
  }) = RefusedGeneration;
}
