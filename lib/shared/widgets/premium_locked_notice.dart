import 'package:flutter/material.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Encadré « Réservé à Premium » d'une fonctionnalité verrouillée pour les
/// utilisateurs gratuits ; l'écran place le bouton « Passer Premium » en bas.
class PremiumLockedNotice extends StatelessWidget {
  const PremiumLockedNotice({super.key, required this.body});

  /// Ce que la fonctionnalité apporte.
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        children: [
          const Icon(AppIcons.lock, size: 40, color: AppColors.gold),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context).premiumLockedTitle,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
