/// Tons de message (INTAKE §2.3). Seul [classic] est gratuit ; la règle est
/// appliquée côté serveur, l'app ne fait qu'afficher le verrou.
enum MessageStyle {
  classic('classic', isPremium: false),
  funny('funny'),
  romantic('romantic'),
  mysterious('mysterious'),
  direct('direct'),
  elegant('elegant'),
  playfulBold('playful_bold');

  const MessageStyle(this.apiName, {this.isPremium = true});

  /// Valeur échangée avec le serveur (`message_style` en base).
  final String apiName;
  final bool isPremium;
}
