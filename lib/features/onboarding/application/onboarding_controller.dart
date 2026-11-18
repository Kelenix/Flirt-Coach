import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../auth/data/supabase_auth_repository.dart';
import '../../credits/application/wallet_controller.dart';
import '../data/age_confirmation_store.dart';

/// `true` quand l'utilisateur a confirmé son âge et dispose d'une session.
final accessGateProvider = NotifierProvider<AccessGate, bool>(AccessGate.new);

class AccessGate extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(ageConfirmationStoreProvider).isConfirmed &&
      ref.watch(authRepositoryProvider).hasSession;

  void open() => state = true;

  /// Retour au premier lancement (après suppression du compte).
  void close() => state = false;
}

final onboardingControllerProvider =
    AsyncNotifierProvider.autoDispose<OnboardingController, void>(
      OnboardingController.new,
    );

class OnboardingController extends AutoDisposeAsyncNotifier<void>
    with GuardedAction {
  @override
  void build() {}

  /// Crée la session, enregistre la confirmation d'âge, puis ouvre l'accès.
  /// Rien n'est mémorisé si une étape échoue.
  Future<void> start() async {
    final started = await runGuarded(() async {
      final auth = ref.read(authRepositoryProvider);
      await auth.signInAnonymously();
      await auth.confirmAge();
      await ref.read(ageConfirmationStoreProvider).markConfirmed();
    });
    if (!started || state.hasError) return;
    // Nouvelle session (par ex. après suppression du compte) : portefeuille relu.
    ref.invalidate(walletProvider);
    ref.read(accessGateProvider.notifier).open();
  }
}
