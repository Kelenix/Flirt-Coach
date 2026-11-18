/// Situations de génération (INTAKE §2.1). Seule [reply] part d'un message reçu.
enum Situation {
  reply('reply', requiresMessage: true),
  opener('opener'),
  flirt('flirt'),
  followUp('follow_up'),
  preDate('pre_date'),
  apology('apology'),
  softBreakup('soft_breakup');

  const Situation(this.apiName, {this.requiresMessage = false});

  /// Valeur échangée avec le serveur (`generation_kind` en base).
  final String apiName;
  final bool requiresMessage;
}
