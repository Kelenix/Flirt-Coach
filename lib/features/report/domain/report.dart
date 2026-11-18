/// Motifs de signalement (INTAKE §7.5), alignés sur `report_reason` en base.
enum ReportReason {
  offensive('offensive'),
  sexual('sexual'),
  harassment('harassment'),
  manipulative('manipulative'),
  other('other');

  const ReportReason(this.apiName);

  final String apiName;
}

/// Signalement d'une réponse générée. Les erreurs sont des `Failure`.
abstract interface class ReportRepository {
  Future<void> report({
    required String generationId,
    required String text,
    required ReportReason reason,
  });
}
