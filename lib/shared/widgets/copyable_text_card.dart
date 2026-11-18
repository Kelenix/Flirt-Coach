import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/snack.dart';

/// Carte claire du kit (« Réponse 1 ») : emoji + titre en gras, bouton « Copier »
/// en haut à droite (et « Signaler » si [onReport]), texte sélectionnable.
class CopyableTextCard extends StatelessWidget {
  const CopyableTextCard({
    super.key,
    required this.title,
    required this.text,
    this.emoji,
    this.onReport,
  });

  final String title;
  final String text;
  final String? emoji;

  /// Signalement d'un contenu généré (INTAKE §7.5).
  final VoidCallback? onReport;

  Future<void> _copy(BuildContext context) async {
    final message = AppLocalizations.of(context).copied;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final emoji = this.emoji;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null) ...[
                ExcludeSemantics(
                  child: Text(emoji, style: textTheme.titleLarge),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.onLight,
                  ),
                ),
              ),
              if (onReport case final report?)
                IconButton(
                  onPressed: report,
                  icon: const Icon(AppIcons.flag, size: 20),
                  color: AppColors.onLightMuted,
                  tooltip: AppLocalizations.of(context).report,
                ),
              IconButton(
                onPressed: () => _copy(context),
                icon: const Icon(AppIcons.copy, size: 20),
                color: AppColors.onLight,
                tooltip: AppLocalizations.of(context).copy,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: SelectableText(
              text,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.onLight),
            ),
          ),
        ],
      ),
    );
  }
}
