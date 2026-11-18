import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../credits/application/wallet_controller.dart';
import '../../credits/data/supabase_wallet_repository.dart';
import '../../credits/domain/wallet.dart';
import '../data/revenuecat_purchases_repository.dart';
import '../domain/catalog.dart';

final catalogProvider = FutureProvider.autoDispose<Catalog>(
  (ref) => ref.watch(purchasesRepositoryProvider).fetchCatalog(),
);

enum PurchaseOutcome {
  premiumActivated,
  creditsAdded,

  /// Le store a validé, mais le serveur n'a pas encore reçu le webhook.
  pending,
  restored,
  nothingToRestore,
}

final purchaseControllerProvider =
    AsyncNotifierProvider.autoDispose<PurchaseController, PurchaseOutcome?>(
      PurchaseController.new,
    );

class PurchaseController extends AutoDisposeAsyncNotifier<PurchaseOutcome?>
    with GuardedAction {
  @override
  PurchaseOutcome? build() => null;

  /// Achète un abonnement ou un pack. État `null` si l'utilisateur annule.
  Future<void> buy(String productId) async {
    await runGuarded(() async {
      final before = await ref.read(walletRepositoryProvider).fetch();
      final bought = await ref.read(purchasesRepositoryProvider).buy(productId);
      if (!bought) return null;
      return _awaitServerConfirmation(before);
    });
  }

  Future<void> restore() async {
    await runGuarded(() async {
      await ref.read(purchasesRepositoryProvider).restore();
      final wallet = await _refreshWallet();
      return wallet.isPremium
          ? PurchaseOutcome.restored
          : PurchaseOutcome.nothingToRestore;
    });
  }

  /// Les droits viennent du serveur (webhook) : on relit le portefeuille jusqu'à
  /// voir l'achat, sans jamais l'accorder côté app.
  Future<PurchaseOutcome> _awaitServerConfirmation(Wallet before) async {
    final (wallet, confirmed) = await awaitServerConfirmation(
      ref,
      (wallet) =>
          (wallet.isPremium && !before.isPremium) ||
          wallet.bonusCredits > before.bonusCredits,
    );
    if (!confirmed) return PurchaseOutcome.pending;
    return wallet.isPremium && !before.isPremium
        ? PurchaseOutcome.premiumActivated
        : PurchaseOutcome.creditsAdded;
  }

  Future<Wallet> _refreshWallet() async {
    final wallet = await ref.read(walletRepositoryProvider).fetch();
    ref.read(walletProvider.notifier).replace(wallet);
    return wallet;
  }
}
