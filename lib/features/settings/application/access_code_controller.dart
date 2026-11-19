import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../credits/application/wallet_controller.dart';
import '../data/account_repository.dart';

final accessCodeControllerProvider =
    AsyncNotifierProvider.autoDispose<AccessCodeController, DateTime?>(
      AccessCodeController.new,
    );

/// Code d'accès Premium (ADR-031) : l'état contient la fin de l'accès accordé.
class AccessCodeController extends AutoDisposeAsyncNotifier<DateTime?>
    with GuardedAction {
  @override
  DateTime? build() => null;

  Future<void> redeem(String code) async {
    await runGuarded(() async {
      final until = await ref
          .read(accountRepositoryProvider)
          .redeemAccessCode(code);
      // Premium est écrit côté serveur : le portefeuille est relu.
      ref.invalidate(walletProvider);
      return until;
    });
  }
}
