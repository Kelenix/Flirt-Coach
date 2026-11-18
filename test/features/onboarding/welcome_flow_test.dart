import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/onboarding/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  /// Téléphone courant (1080 × 2400 px) : l'accueil du kit tient sur un écran.
  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
  }

  FilledButton startButton(WidgetTester tester) =>
      tester.widget(filledButton('Commencer'));

  testWidgets('premier lancement : accueil 18+, bouton désactivé', (
    tester,
  ) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('J\'ai 18 ans ou plus'), findsOneWidget);
    expect(
      find.textContaining('Aucun résultat n\'est garanti'),
      findsOneWidget,
    );
    expect(startButton(tester).onPressed, isNull);
  });

  testWidgets('case cochée puis Commencer : arrivée sur l\'accueil', (
    tester,
  ) async {
    usePhoneViewport(tester);
    final auth = FakeAuthRepository();
    await tester.pumpWidget(await buildTestApp(auth));
    await tester.pumpAndSettle();

    await tester.tap(find.text("J'ai 18 ans ou plus"));
    await tester.pump();
    expect(startButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(auth.isAgeConfirmed, isTrue);
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsNothing);
  });

  testWidgets('sans réseau : message d\'erreur, on peut réessayer', (
    tester,
  ) async {
    usePhoneViewport(tester);
    final auth = FakeAuthRepository(error: const NetworkFailure());
    await tester.pumpWidget(await buildTestApp(auth));
    await tester.pumpAndSettle();

    await tester.tap(find.text("J'ai 18 ans ou plus"));
    await tester.pump();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Pas de connexion'), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsOneWidget);

    auth.error = null;
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.byType(GenerateScreen), findsOneWidget);
  });

  testWidgets('lancements suivants : accueil direct, sans redemander l\'âge', (
    tester,
  ) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(
      await buildTestApp(
        FakeAuthRepository(hasSession: true),
        isAgeConfirmed: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsNothing);
  });

  testWidgets('petit écran et grande police : aucun débordement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
