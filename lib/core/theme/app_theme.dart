import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_tokens.dart';

/// Barres système transparentes : le fond de l'app va jusqu'aux bords de
/// l'écran (pas de bande sombre sous la barre de navigation).
const systemBarsStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: false,
);

abstract final class AppTheme {
  static const _buttonHeight = 56.0;
  static const _disabledOpacity = 0.4;

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onDark,
      surface: AppColors.background,
      onSurface: AppColors.onDark,
      surfaceContainer: AppColors.card,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.body,
      textTheme: _textTheme,
      // Transitions : fondu + léger glissement (Material 3) sur Android, sur le fond de
      // la marque pour éviter tout flash clair ; glissement natif sur iOS.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(
            backgroundColor: AppColors.background,
          ),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: const StadiumBorder(),
          textStyle: _buttonText,
          disabledBackgroundColor: AppColors.primary.withValues(
            alpha: _disabledOpacity,
          ),
          disabledForegroundColor: AppColors.onDark.withValues(
            alpha: _disabledOpacity,
          ),
        ),
      ),
      // « Passer Premium » du kit : fond clair, contour violet, texte foncé.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: const StadiumBorder(),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onLight,
          side: const BorderSide(color: AppColors.secondary, width: 1.5),
          textStyle: _buttonText,
        ),
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: systemBarsStyle,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        foregroundColor: AppColors.onDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme.titleLarge,
      ),
      iconTheme: const IconThemeData(color: AppColors.onDark),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.surfaceTint,
          minimumSize: const Size(48, 48),
          textStyle: _buttonText,
        ),
      ),
      inputDecorationTheme: _inputDecoration,
      // DropdownMenu n'hérite pas du thème global des champs : on lui redonne
      // le même fond clair, sinon son texte sombre est invisible.
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: _inputDecoration,
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.card),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.panel,
        titleTextStyle: _textTheme.titleLarge,
        contentTextStyle: _textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.card,
        contentTextStyle: _textTheme.bodyMedium,
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.surfaceTint, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
      ),
    );
  }

  static final _inputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: _textTheme.bodyLarge?.copyWith(color: AppColors.onLightMuted),
    contentPadding: const EdgeInsets.all(AppSpacing.md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderSide: const BorderSide(color: AppColors.secondary, width: 2),
    ),
  );

  static final _textTheme = TextTheme(
    headlineMedium: _heading(28, FontWeight.w700),
    titleLarge: _heading(20, FontWeight.w600),
    labelLarge: _heading(16, FontWeight.w600),
    bodyLarge: _body(16, FontWeight.w400),
    bodyMedium: _body(14, FontWeight.w400),
    labelMedium: _body(12, FontWeight.w500),
  );

  /// Libellés de boutons en gras : texte blanc sur rose lisible (contraste WCAG
  /// « gros texte », 3:1), sans toucher aux couleurs du kit.
  static final _buttonText = _heading(16, FontWeight.w700);

  static TextStyle _heading(double size, FontWeight weight) => TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: size,
    fontWeight: weight,
  );

  // Inter est une police variable : la graisse passe aussi par l'axe `wght`.
  static TextStyle _body(double size, FontWeight weight) => TextStyle(
    fontFamily: AppFonts.body,
    fontSize: size,
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );
}
