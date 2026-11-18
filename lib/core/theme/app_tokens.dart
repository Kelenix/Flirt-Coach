import 'package:flutter/painting.dart';

/// Tokens du kit de marque néon (docs/design/design-system.md).
abstract final class AppColors {
  // Palette officielle du kit.
  static const primary = Color(0xFFFF4D79);
  static const secondary = Color(0xFF9B5CFF);
  static const background = Color(0xFF1A1033);
  static const surfaceTint = Color(0xFFFFD6E6);
  static const surface = Color(0xFFF8F8FC);

  // Dérivés relevés sur les écrans du kit.
  static const backgroundGlow = Color(0xFF3A1650);
  static const card = Color(0xFF2A1D4A);

  /// Panneau « Icônes (UI) » du kit.
  static const panel = Color(0xFF3D1E5E);
  static const lavender = Color(0xFFEDE3F6);
  static const primaryDeep = Color(0xFFF2386A);
  static const secondaryDeep = Color(0xFF6A2FB3);
  static const gold = Color(0xFFF6C343);
  static const onDark = Color(0xFFFFFFFF);
  static const onDarkMuted = Color(0xFFD9CCEB);
  static const onLight = Color(0xFF1A1033);
  static const onLightMuted = Color(0xFF7A6B92);
  static const error = Color(0xFFFF6B6B);

  /// Translucide clair posé sur le fond sombre (puces, pastilles).
  static const glass = Color(0x1AFFFFFF);

  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  /// Bouton principal : rose lumineux (« Générer des réponses », « Commencer »).
  static const primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF5C86), primaryDeep],
  );

  /// Puce de style sélectionnée.
  static const selectedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDeep],
  );
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppRadius {
  static const card = 16.0;
  static const chip = 14.0;
  static const pill = 28.0;
}

abstract final class AppFonts {
  static const heading = 'Poppins';
  static const body = 'Inter';
}
