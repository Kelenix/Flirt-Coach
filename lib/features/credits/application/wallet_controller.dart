import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/supabase_wallet_repository.dart';
import '../domain/wallet.dart';

/// Crédits affichés. Relus au démarrage, puis mis à jour par chaque appel IA.
final walletProvider = AsyncNotifierProvider<WalletController, Wallet>(
  WalletController.new,
);

class WalletController extends AsyncNotifier<Wallet> {
  @override
  Future<Wallet> build() => ref.watch(walletRepositoryProvider).fetch();

  void replace(Wallet wallet) => state = AsyncData(wallet);
}

/// Intervalle entre deux relectures du portefeuille en attendant le serveur.
final serverConfirmationDelayProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 1),
);

/// Relit le portefeuille jusqu'à ce que [isConfirmed] soit vrai (achat ou récompense
/// pris en compte par le serveur). Renvoie le dernier portefeuille lu et s'il confirme.
Future<(Wallet, bool)> awaitServerConfirmation(
  Ref ref,
  bool Function(Wallet wallet) isConfirmed, {
  int attempts = 6,
}) async {
  final delay = ref.read(serverConfirmationDelayProvider);
  late Wallet wallet;
  for (var attempt = 0; attempt < attempts; attempt++) {
    if (attempt > 0) await Future<void>.delayed(delay);
    wallet = await ref.read(walletRepositoryProvider).fetch();
    ref.read(walletProvider.notifier).replace(wallet);
    if (isConfirmed(wallet)) return (wallet, true);
  }
  return (wallet, false);
}
