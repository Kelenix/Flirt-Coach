import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../../core/storage/preferences.dart';
import '../../credits/application/wallet_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../data/account_repository.dart';

final accountControllerProvider =
    AsyncNotifierProvider.autoDispose<AccountController, void>(
      AccountController.new,
    );

class AccountController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  /// Supprime le compte, efface les préférences locales et revient au premier
  /// lancement (accueil 18+). Rien n'est effacé localement si le serveur échoue.
  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    final result = await keepAliveWhile(
      ref,
      () => AsyncValue.guard(() async {
        await ref.read(accountRepositoryProvider).deleteAccount();
        await ref.read(sharedPreferencesProvider).clear();
      }),
    );
    state = result;
    if (result.hasError) return;
    ref.invalidate(walletProvider);
    ref.read(accessGateProvider.notifier).close();
  }
}
