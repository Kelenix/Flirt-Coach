import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Fond des écrans du kit : violet profond qui s'éclaircit vers le bas, halo rose.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  static const _haloOpacity = 0.28;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.backgroundGlow],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, 1.25),
            radius: 1.0,
            colors: [
              AppColors.primary.withValues(alpha: _haloOpacity),
              AppColors.primary.withValues(alpha: 0),
            ],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
