import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../application/wallet_controller.dart';

/// Pastille du kit « 🪙 n crédits » (ou « 👑 Premium »). Ouvre le paywall.
class CreditsBadge extends ConsumerWidget {
  const CreditsBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider).valueOrNull;
    if (wallet == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      hint: l10n.upgradeButton,
      child: InkWell(
        onTap: () => context.push(AppRoutes.paywall),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        // Cible tactile d'au moins 48 dp, pastille visuelle inchangée.
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension,
          ),
          child: Center(
            widthFactor: 1,
            child: _badge(context, l10n, wallet.isPremium, wallet.credits),
          ),
        ),
      ),
    );
  }

  Widget _badge(
    BuildContext context,
    AppLocalizations l10n,
    bool isPremium,
    int credits,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPremium ? AppIcons.premium : AppIcons.coins,
              size: 18,
              color: AppColors.gold,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                isPremium ? l10n.premium : l10n.credits(credits),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
