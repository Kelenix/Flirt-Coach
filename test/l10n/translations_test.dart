import 'dart:convert';
import 'dart:io';

import 'package:flirt_coach/features/legal/presentation/legal_screen.dart';
import 'package:flirt_coach/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Toute langue proposée par l'app est complète : interface, textes embarqués
/// et déclarations Android / iOS (ADR-034). Ajouter une langue sans tout
/// traduire fait échouer ces tests.
void main() {
  Map<String, dynamic> readArb(String languageCode) =>
      jsonDecode(File('lib/l10n/app_$languageCode.arb').readAsStringSync())
          as Map<String, dynamic>;

  final template = readArb('fr');
  final messageKeys = template.keys.where((key) => !key.startsWith('@'));
  final languageCodes = [
    for (final locale in AppLocalizations.supportedLocales) locale.languageCode,
  ];

  test('le français (source), l\'anglais et l\'allemand sont proposés', () {
    expect(languageCodes, containsAll(['fr', 'en', 'de']));
  });

  for (final languageCode in languageCodes) {
    test('$languageCode : chaque texte de l\'interface est traduit', () {
      final arb = readArb(languageCode);
      final translated = arb.keys.where((key) => !key.startsWith('@'));
      expect(translated.toSet(), messageKeys.toSet());
      for (final key in messageKeys) {
        final value = arb[key] as String;
        expect(value.trim(), isNotEmpty, reason: key);
        final placeholders =
            (template['@$key'] as Map<String, dynamic>?)?['placeholders']
                as Map<String, dynamic>? ??
            const {};
        for (final name in placeholders.keys) {
          expect(value, contains('{$name'), reason: '$key : {$name}');
        }
      }
    });

    test('$languageCode : aide et textes légaux embarqués', () {
      final tokens = RegExp(r'\{\{\w+\}\}');
      for (final document in LegalDocument.values) {
        final file = File(document.asset(languageCode));
        expect(file.existsSync(), isTrue, reason: file.path);
        final text = file.readAsStringSync();
        expect(text.trim(), isNotEmpty, reason: file.path);
        // Mêmes champs à compléter (éditeur, contact) que la version source.
        final source = File(document.asset('fr')).readAsStringSync();
        expect(
          tokens.allMatches(text).map((match) => match[0]).toSet(),
          tokens.allMatches(source).map((match) => match[0]).toSet(),
          reason: file.path,
        );
      }
    });
  }

  test('Android 13+ : langues proposées dans les paramètres de l\'app', () {
    final config = File(
      'android/app/src/main/res/xml/locales_config.xml',
    ).readAsStringSync();
    final declared = RegExp(
      r'android:name="(\w+)"',
    ).allMatches(config).map((match) => match[1]);
    expect(declared.toSet(), languageCodes.toSet());
  });

  test('iOS : langues déclarées et textes d\'autorisation traduits', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final localizations = RegExp(
      r'<key>CFBundleLocalizations</key>\s*<array>(.*?)</array>',
      dotAll: true,
    ).firstMatch(plist)![1]!;
    final declared = RegExp(
      r'<string>(\w+)</string>',
    ).allMatches(localizations).map((match) => match[1]);
    expect(declared.toSet(), languageCodes.toSet());

    for (final languageCode in languageCodes) {
      final strings = File(
        'ios/Runner/$languageCode.lproj/InfoPlist.strings',
      ).readAsStringSync();
      expect(strings, contains('"NSPhotoLibraryUsageDescription"'));
      expect(strings, contains('"NSUserTrackingUsageDescription"'));
    }
  });
}
