import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Bouton principal du kit : pilule en dégradé rose avec halo, icône facultative (✨).
/// Non cliquable pendant le chargement.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  static const _spinnerSize = 22.0;
  static const _disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final icon = this.icon;
    final child = isLoading
        ? SizedBox.square(
            dimension: _spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.onDark,
              semanticsLabel: label,
            ),
          )
        : Text(label, textAlign: TextAlign.center);

    final style = FilledButton.styleFrom(
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: AppColors.onDark,
      disabledForegroundColor: AppColors.onDark,
      shadowColor: Colors.transparent,
    );

    return Opacity(
      opacity: isEnabled || isLoading ? 1 : _disabledOpacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            if (isEnabled)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: icon == null || isLoading
            ? FilledButton(
                onPressed: isEnabled ? onPressed : null,
                style: style,
                child: child,
              )
            : FilledButton.icon(
                onPressed: isEnabled ? onPressed : null,
                style: style,
                icon: Icon(icon, size: 22),
                label: child,
              ),
      ),
    );
  }
}
