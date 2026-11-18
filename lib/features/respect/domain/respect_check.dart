import 'package:freezed_annotation/freezed_annotation.dart';

import '../../credits/domain/wallet.dart';

part 'respect_check.freezed.dart';

/// Les trois risques détectés par le mode Respect (INTAKE §2.6).
enum RespectIssueCategory {
  insistent('insistent'),
  sexualized('sexualized'),
  manipulative('manipulative');

  const RespectIssueCategory(this.apiName);

  final String apiName;

  static RespectIssueCategory? fromApi(String value) {
    for (final category in values) {
      if (category.apiName == value) return category;
    }
    return null;
  }
}

@freezed
abstract class RespectIssue with _$RespectIssue {
  const factory RespectIssue({
    required RespectIssueCategory category,
    required String explanation,
  }) = _RespectIssue;
}

@freezed
sealed class RespectCheck with _$RespectCheck {
  /// Verdict sur le message ; [alternative] n'existe que s'il est à revoir.
  const factory RespectCheck.verdict({
    required List<RespectIssue> issues,
    required String? alternative,
    required Wallet wallet,
  }) = RespectVerdict;

  /// Le coach a refusé d'analyser ; aucun crédit débité.
  const factory RespectCheck.refused({
    required String reason,
    required Wallet wallet,
  }) = RespectRefused;

  const RespectCheck._();
}

extension RespectVerdictReading on RespectVerdict {
  bool get isRespectful => issues.isEmpty;
}
