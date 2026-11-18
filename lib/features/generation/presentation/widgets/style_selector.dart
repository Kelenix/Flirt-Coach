import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/message_style.dart';
import '../labels.dart';

/// Styles en grille de deux colonnes (kit) : sélectionné en violet bordé de rose,
/// verrouillé avec un cadenas après le nom.
class StyleSelector extends StatelessWidget {
  const StyleSelector({
    super.key,
    required this.selected,
    required this.isPremium,
    required this.onSelected,
    required this.onLockedTap,
  });

  final MessageStyle selected;
  final bool isPremium;
  final ValueChanged<MessageStyle> onSelected;
  final VoidCallback onLockedTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final style in MessageStyle.values)
              SizedBox(
                width: tileWidth,
                child: _StyleTile(
                  label: style.label(l10n),
                  isSelected: style == selected,
                  isLocked: style.isPremium && !isPremium,
                  onTap: style.isPremium && !isPremium
                      ? onLockedTap
                      : () => onSelected(style),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.label,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  static const _height = 48.0;

  final String label;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: isLocked ? AppColors.onDarkMuted : AppColors.onDark,
    );
    return Semantics(
      button: true,
      selected: isSelected,
      label: isLocked ? l10n.lockedStyleLabel(label) : label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: _height,
        decoration: BoxDecoration(
          color: isSelected ? null : AppColors.glass,
          gradient: isSelected ? AppColors.selectedGradient : null,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLocked) ...[
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      AppIcons.lock,
                      size: 16,
                      color: AppColors.onDarkMuted,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
