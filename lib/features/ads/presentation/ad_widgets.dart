import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../credits/application/wallet_controller.dart';
import '../application/rewarded_video_controller.dart';
import '../data/ads_service.dart';
import '../../../shared/widgets/snack.dart';

/// Bannière discrète en bas d'écran, pour les utilisateurs gratuits uniquement
/// (jamais pour Premium, jamais avant le consentement).
class AdBannerSlot extends ConsumerWidget {
  const AdBannerSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider).valueOrNull;
    // Le consentement n'est demandé qu'une fois l'utilisateur connu comme gratuit.
    if (wallet == null || wallet.isPremium) return const SizedBox.shrink();
    final isReady = ref.watch(adsReadyProvider).valueOrNull ?? false;
    if (!isReady) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: ref.read(adsServiceProvider).banner(),
    );
  }
}

/// Plus de crédits : vidéo récompensée (+2 crédits) si encore possible aujourd'hui,
/// et accès au paywall (INTAKE §4, étape 5).
class EarnCreditsActions extends ConsumerWidget {
  const EarnCreditsActions({super.key, this.offerRewardedVideo = true});

  /// `false` quand c'est un droit Premium qui manque, pas des crédits.
  final bool offerRewardedVideo;

  String? _outcomeMessage(AppLocalizations l10n, RewardOutcome outcome) =>
      switch (outcome) {
        RewardOutcome.credited => l10n.rewardCredited,
        RewardOutcome.pending => l10n.rewardPending,
        RewardOutcome.interrupted => l10n.rewardInterrupted,
        RewardOutcome.unavailable => l10n.rewardUnavailable,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wallet = ref.watch(walletProvider).valueOrNull;
    final reward = ref.watch(rewardedVideoControllerProvider);
    ref.listen(rewardedVideoControllerProvider, (previous, next) {
      final outcome = next.valueOrNull;
      final message = switch (next) {
        AsyncError() => l10n.rewardUnavailable,
        _ when outcome != null => _outcomeMessage(l10n, outcome),
        _ => null,
      };
      if (message == null || next.isLoading) return;
      ScaffoldMessenger.of(context).showMessage(message);
    });
    final canWatch = offerRewardedVideo && (wallet?.adRewardsLeft ?? 0) > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canWatch) ...[
          TonalButton(
            label: l10n.watchAdForCredits,
            icon: AppIcons.play,
            isLoading: reward.isLoading,
            onPressed: ref.read(rewardedVideoControllerProvider.notifier).watch,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        SecondaryButton(
          label: l10n.upgradeButton,
          icon: AppIcons.premium,
          onPressed: () => context.push(AppRoutes.paywall),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
