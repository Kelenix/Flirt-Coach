import 'respect_check.dart';

/// Vérification d'un message avant envoi. Les erreurs sont des `Failure`.
abstract interface class RespectRepository {
  /// 1 crédit pour un utilisateur gratuit, inclus dans Premium.
  Future<RespectCheck> check({required String message, String? context});
}
