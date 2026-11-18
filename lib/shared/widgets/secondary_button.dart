import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// « Passer Premium » du kit : fond clair, contour violet, texte et icône foncés.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return icon == null
        ? OutlinedButton(onPressed: onPressed, child: Text(label))
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: AppColors.onLight, size: 22),
            label: Text(label),
          );
  }
}

/// « Regarder une pub (+2 crédits) » du kit : fond lavande, texte et icône foncés.
class TonalButton extends StatelessWidget {
  const TonalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  static const _height = 56.0;
  static const _spinnerSize = 22.0;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.lavender,
        foregroundColor: AppColors.onLight,
        disabledBackgroundColor: AppColors.lavender,
        disabledForegroundColor: AppColors.onLight,
        minimumSize: const Size.fromHeight(_height),
        shape: const StadiumBorder(),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      icon: isLoading
          ? const SizedBox.square(
              dimension: _spinnerSize,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.onLight,
              ),
            )
          : Icon(icon, size: 20),
      label: Text(label),
    );
  }
}
