/// Identité de l'utilisateur. Les erreurs sont des `Failure`.
abstract interface class AuthRepository {
  bool get hasSession;

  /// Identifiant de l'utilisateur connecté (`null` sans session).
  String? get userId;

  /// Crée un compte anonyme ; sans effet si une session existe déjà.
  Future<void> signInAnonymously();

  /// Enregistre côté serveur que l'utilisateur déclare avoir 18 ans ou plus.
  Future<void> confirmAge();
}
