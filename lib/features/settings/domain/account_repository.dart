/// Compte de l'utilisateur. Les erreurs sont des `Failure`.
abstract interface class AccountRepository {
  /// Supprime définitivement le compte et ses données côté serveur (US-05),
  /// puis ferme la session locale.
  Future<void> deleteAccount();
}
