import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Symbole de la marque (bulle + cœur + étincelles), tiré du logo fourni.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_symbol.png',
      width: size,
      height: size,
      semanticLabel: AppLocalizations.of(context).appName,
    );
  }
}

/// Mot-symbole « Flirt Coach » pour fond sombre (« Flirt » blanc, « Coach » rose).
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.width = 240});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_wordmark_dark.png',
      width: width,
      semanticLabel: AppLocalizations.of(context).appName,
    );
  }
}
