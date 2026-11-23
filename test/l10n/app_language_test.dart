import 'package:flirt_coach/core/l10n/app_language.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/legal/presentation/legal_screen.dart';
import 'package:flirt_coach/features/message_bank/presentation/message_bank_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Langue de l'interface choisie d'après l'appareil (ADR-034).
void main() {
  group('langue retenue pour l\'appareil', () {
    test('langue proposée : retenue, quelle que soit la région', () {
      expect(resolveAppLocale(const [Locale('fr', 'CA')]).languageCode, 'fr');
      expect(resolveAppLocale(const [Locale('en', 'GB')]).languageCode, 'en');
    });

    test('allemand : retenu en Allemagne, en Autriche et en Suisse', () {
      for (final country in ['DE', 'AT', 'CH']) {
        expect(resolveAppLocale([Locale('de', country)]).languageCode, 'de');
      }
    });

    test('première langue préférée que l\'app propose', () {
      expect(
        resolveAppLocale(const [Locale('it'), Locale('fr')]).languageCode,
        'fr',
      );
    });

    test('langue non proposée : anglais', () {
      expect(resolveAppLocale(const [Locale('it', 'IT')]).languageCode, 'en');
      expect(resolveAppLocale(const []).languageCode, 'en');
    });
  });

  /// Téléphone courant ; l'appareil simulé parle [locales].
  void useDevice(WidgetTester tester, List<Locale> locales) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.localesTestValue = locales;
  }

  testWidgets('appareil en anglais : accueil en anglais', (tester) async {
    useDevice(tester, const [Locale('en', 'US')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('I am 18 or older'), findsOneWidget);
    expect(find.textContaining('No results are guaranteed'), findsOneWidget);

    await tester.tap(find.text('I am 18 or older'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.text('Generate 3 replies'), findsOneWidget);
  });

  testWidgets('appareil dans une langue non proposée : anglais', (
    tester,
  ) async {
    useDevice(tester, const [Locale('it', 'IT')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('I am 18 or older'), findsOneWidget);
  });

  testWidgets('appareil en allemand : accueil en allemand', (tester) async {
    useDevice(tester, const [Locale('de', 'DE')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Ich bin 18 Jahre oder älter'), findsOneWidget);
    await tester.tap(find.text('Ich bin 18 Jahre oder älter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Los geht's"));
    await tester.pumpAndSettle();
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.text('3 Antworten erstellen'), findsOneWidget);
  });

  // Les textes allemands sont les plus longs : chaque écran du menu doit
  // s'afficher sans débordement (un débordement fait échouer le test).
  for (final entry in [
    'Respekt-Modus',
    'Analyse',
    'Sammlung',
    'Verlauf',
    'Premium',
    'Einstellungen',
  ]) {
    testWidgets('allemand : menu → $entry sans débordement', (tester) async {
      useDevice(tester, const [Locale('de', 'DE')]);
      await tester.pumpWidget(await buildSignedInApp(FakeBackend()));
      await tester.pumpAndSettle();

      await openFromMenu(tester, entry, menuTooltip: 'Menü');

      expect(find.byType(GenerateScreen), findsNothing);
      await tester.tap(find.byTooltip('Zurück'));
      await tester.pumpAndSettle();
      expect(find.byType(GenerateScreen), findsOneWidget);
    });
  }

  testWidgets('textes légaux affichés dans la langue de l\'interface', (
    tester,
  ) async {
    useDevice(tester, const [Locale('en', 'US')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terms'));
    await tester.pumpAndSettle();

    expect(find.byType(LegalScreen), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
    expect(find.text('Minimum age'), findsOneWidget);
  });

  testWidgets('banque de messages demandée dans la langue de l\'interface', (
    tester,
  ) async {
    useDevice(tester, const [Locale('en', 'US')]);
    final backend = FakeBackend();
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();

    await openFromMenu(tester, 'Library');

    expect(find.byType(MessageBankScreen), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Opener'), findsOneWidget);
    expect(backend.bankLanguages, ['en']);
  });

  testWidgets('banque de messages en français sur un appareil français', (
    tester,
  ) async {
    useDevice(tester, const [Locale('fr', 'FR')]);
    final backend = FakeBackend();
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();

    await openFromMenu(tester, 'Banque');

    expect(backend.bankLanguages, ['fr']);
  });
}
