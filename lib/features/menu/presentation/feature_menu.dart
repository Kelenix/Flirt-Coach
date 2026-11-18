import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';

/// Menu des fonctionnalités, présenté comme le panneau « Icônes (UI) » du kit.
/// Seules les fonctionnalités disponibles y figurent.
Future<void> showFeatureMenu(
  BuildContext context, {
  required VoidCallback onScreenshot,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.panel,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.pill)),
    ),
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      void close() => Navigator.of(sheetContext).pop();
      void open(String route) {
        close();
        context.push(route);
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Wrap(
            runSpacing: AppSpacing.md,
            children: [
              _FeatureTile(
                icon: AppIcons.generate,
                label: l10n.menuGenerate,
                onTap: close,
              ),
              _FeatureTile(
                icon: AppIcons.screenshot,
                label: l10n.menuScreenshot,
                onTap: () {
                  close();
                  onScreenshot();
                },
              ),
              _FeatureTile(
                icon: AppIcons.respect,
                label: l10n.respectTitle,
                onTap: () => open(AppRoutes.respect),
              ),
              _FeatureTile(
                icon: AppIcons.analysis,
                label: l10n.menuAnalysis,
                onTap: () => open(AppRoutes.analysis),
              ),
              _FeatureTile(
                icon: AppIcons.messageBank,
                label: l10n.menuBank,
                onTap: () => open(AppRoutes.bank),
              ),
              _FeatureTile(
                icon: AppIcons.history,
                label: l10n.menuHistory,
                onTap: () => open(AppRoutes.history),
              ),
              _FeatureTile(
                icon: AppIcons.premium,
                label: l10n.premium,
                onTap: () => open(AppRoutes.paywall),
              ),
              _FeatureTile(
                icon: AppIcons.credits,
                label: l10n.menuCredits,
                onTap: () => open(AppRoutes.paywall),
              ),
              _FeatureTile(
                icon: AppIcons.settings,
                label: l10n.menuSettings,
                onTap: () => open(AppRoutes.settings),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: AppColors.onDark),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
