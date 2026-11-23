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

    test(
      'espagnol : retenu en Espagne, en Amérique latine et aux États-Unis',
      () {
        for (final country in ['ES', 'MX', 'AR', 'CO', 'US']) {
          expect(resolveAppLocale([Locale('es', country)]).languageCode, 'es');
        }
      },
    );

    test('portugais : retenu au Brésil, au Portugal et en Afrique', () {
      for (final country in ['BR', 'PT', 'AO', 'MZ']) {
        expect(resolveAppLocale([Locale('pt', country)]).languageCode, 'pt');
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

  testWidgets('appareil en espagnol : accueil en espagnol', (tester) async {
    useDevice(tester, const [Locale('es', 'MX')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Tengo 18 años o más'), findsOneWidget);
    await tester.tap(find.text('Tengo 18 años o más'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comenzar'));
    await tester.pumpAndSettle();
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.text('Generar 3 respuestas'), findsOneWidget);
  });

  testWidgets('appareil en portugais : accueil en portugais', (tester) async {
    useDevice(tester, const [Locale('pt', 'BR')]);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Tenho 18 anos ou mais'), findsOneWidget);
    await tester.tap(find.text('Tenho 18 anos ou mais'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.text('Gerar 3 respostas'), findsOneWidget);
  });

  // Les textes allemands, espagnols et portugais sont les plus longs : chaque
  // écran du menu doit s'afficher sans débordement (un débordement fait échouer
  // le test).
  const longLanguages = [
    (
      locale: Locale('de', 'DE'),
      menu: 'Menü',
      back: 'Zurück',
      entries: [
        'Respekt-Modus',
        'Analyse',
        'Sammlung',
        'Verlauf',
        'Premium',
        'Einstellungen',
      ],
    ),
    (
      locale: Locale('es', 'ES'),
      menu: 'Menú',
      back: 'Atrás',
      entries: [
        'Modo Respeto',
        'Análisis',
        'Biblioteca',
        'Historial',
        'Premium',
        'Configuración',
      ],
    ),
    (
      locale: Locale('pt', 'BR'),
      menu: 'Menu',
      back: 'Voltar',
      entries: [
        'Modo Respeito',
        'Análise',
        'Biblioteca',
        'Histórico',
        'Premium',
        'Configurações',
      ],
    ),
  ];
  for (final language in longLanguages) {
    for (final entry in language.entries) {
      testWidgets(
        '${language.locale.languageCode} : menu → $entry sans débordement',
        (tester) async {
          useDevice(tester, [language.locale]);
          await tester.pumpWidget(await buildSignedInApp(FakeBackend()));
          await tester.pumpAndSettle();

          await openFromMenu(tester, entry, menuTooltip: language.menu);

          expect(find.byType(GenerateScreen), findsNothing);
          await tester.tap(find.byTooltip(language.back));
          await tester.pumpAndSettle();
          expect(find.byType(GenerateScreen), findsOneWidget);
        },
      );
    }
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
