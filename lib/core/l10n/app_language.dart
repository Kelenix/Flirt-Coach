import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Langue de l'interface : la première langue préférée de l'appareil que l'app
/// propose ; à défaut, la première de [AppLocalizations.supportedLocales]
/// (l'anglais, ADR-034). Règle unique pour l'interface et pour le serveur.
Locale resolveAppLocale(List<Locale>? preferred) =>
    basicLocaleListResolution(preferred, AppLocalizations.supportedLocales);

/// Code de la langue affichée (« fr », « en »), envoyé au serveur pour qu'il
/// rédige dans la même langue les textes adressés à l'utilisateur.
String currentLanguageCode() => resolveAppLocale(
  WidgetsBinding.instance.platformDispatcher.locales,
).languageCode;
