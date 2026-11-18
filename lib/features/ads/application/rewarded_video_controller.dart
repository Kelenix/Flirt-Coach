import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../../core/errors/failure.dart';
import '../../auth/data/supabase_auth_repository.dart';
import '../../credits/application/wallet_controller.dart';
import '../../credits/data/supabase_wallet_repository.dart';
import '../data/ads_service.dart';

enum RewardOutcome {
  credited,

  /// Vidéo vue, mais le rappel d'AdMob n'est pas encore arrivé au serveur.
  pending,
  interrupted,
  unavailable,
}

final rewardedVideoControllerProvider =
    AsyncNotifierProvider.autoDispose<RewardedVideoController, RewardOutcome?>(
      RewardedVideoController.new,
    );

class RewardedVideoController extends AutoDisposeAsyncNotifier<RewardOutcome?> {
  @override
  RewardOutcome? build() => null;

  Future<void> watch() async {
    state = const AsyncLoading();
    state = await keepAliveWhile(
      ref,
      () => AsyncValue.guard(() async {
        final userId = ref.read(authRepositoryProvider).userId;
        if (userId == null) throw const UnexpectedFailure();
        final before = await ref.read(walletRepositoryProvider).fetch();

        final result = await ref
            .read(adsServiceProvider)
            .showRewardedVideo(userId);
        switch (result) {
          case RewardedVideoResult.unavailable:
            return RewardOutcome.unavailable;
          case RewardedVideoResult.interrupted:
            return RewardOutcome.interrupted;
          case RewardedVideoResult.watched:
            final (_, credited) = await awaitServerConfirmation(
              ref,
              (wallet) => wallet.bonusCredits > before.bonusCredits,
            );
            return credited ? RewardOutcome.credited : RewardOutcome.pending;
        }
      }),
    );
  }
}
