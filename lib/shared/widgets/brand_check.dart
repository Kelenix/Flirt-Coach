import 'package:flutter/material.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_tokens.dart';

/// Coche du kit : carré arrondi rose avec une coche blanche ; vide si [isChecked]
/// est faux (case à cocher de l'écran d'accueil).
class BrandCheckBox extends StatelessWidget {
  const BrandCheckBox({super.key, this.isChecked = true});

  final bool isChecked;

  static const _size = 26.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: isChecked ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: isChecked ? AppColors.primary : AppColors.surfaceTint,
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(AppIcons.check, size: 18, color: AppColors.onDark)
          : null,
    );
  }
}

/// Ligne « ✓ texte » de l'écran d'accueil et du paywall.
class BrandCheckItem extends StatelessWidget {
  const BrandCheckItem(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        children: [
          const ExcludeSemantics(child: BrandCheckBox()),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
