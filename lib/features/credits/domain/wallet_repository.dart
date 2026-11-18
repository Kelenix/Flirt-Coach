import 'wallet.dart';

abstract interface class WalletRepository {
  /// Crédits et droits de l'utilisateur, calculés par le serveur.
  Future<Wallet> fetch();
}
