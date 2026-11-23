/// Catégories de la banque de messages (INTAKE §2.5), dans l'ordre d'affichage.
enum BankCategory {
  opener('opener'),
  followUp('follow_up'),
  date('date'),
  apology('apology'),
  softBreakup('soft_breakup');

  const BankCategory(this.apiName);

  final String apiName;

  static BankCategory? fromApi(String value) {
    for (final category in values) {
      if (category.apiName == value) return category;
    }
    return null;
  }
}

/// Message prêt à copier de la banque.
final class BankMessage {
  const BankMessage({required this.category, required this.body});

  final BankCategory category;
  final String body;
}

/// Banque de messages, statique et sans crédit. Les erreurs sont des `Failure`.
abstract interface class MessageBankRepository {
  /// Toute la banque dans la langue [languageCode] (« fr », « en »), triée ;
  /// la dernière copie locale de cette langue si le réseau manque.
  Future<List<BankMessage>> fetchAll(String languageCode);
}
