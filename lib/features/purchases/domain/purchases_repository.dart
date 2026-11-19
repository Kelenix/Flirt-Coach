import 'catalog.dart';

/// Achats intégrés (abonnements et packs de crédits). Les erreurs sont des `Failure`.
///
/// Les droits ne sont jamais accordés par l'app : le store prévient le serveur
/// (webhook RevenueCat), qui met à jour Premium et les crédits.
abstract interface class PurchasesRepository {
  /// Offres disponibles, avec les prix du store.
  Future<Catalog> fetchCatalog();

  /// Lance l'achat ; `false` si l'utilisateur annule.
  Future<bool> buy(String productId);

  /// Restaure les achats faits avec le même compte store ; `true` si le store y voit
  /// un abonnement Premium actif.
  Future<bool> restore();
}
