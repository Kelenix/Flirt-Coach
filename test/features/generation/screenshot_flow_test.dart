import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/generation/domain/situation.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/generation/presentation/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final messageField = find.byKey(GenerateScreen.messageFieldKey);
  final importButton = find.byTooltip('Importer une capture d\'écran');
  final generateButton = filledButton('Générer 3 réponses');

  Future<FakeBackend> openWithScreenshot(
    WidgetTester tester, {
    Wallet wallet = const Wallet(
      dailyCredits: 5,
      bonusCredits: 0,
      isPremium: false,
    ),
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final backend = FakeBackend(wallet: wallet);
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    await tester.tap(importButton);
    await tester.pumpAndSettle();
    return backend;
  }

  testWidgets('capture choisie : aperçu, coût affiché, champ message masqué', (
    tester,
  ) async {
    await openWithScreenshot(tester);

    expect(find.text('Capture d\'écran sélectionnée'), findsOneWidget);
    expect(find.textContaining('2 crédits'), findsOneWidget);
    expect(find.textContaining('jamais conservée'), findsOneWidget);
    expect(messageField, findsNothing);
    expect(tester.widget<FilledButton>(generateButton).onPressed, isNotNull);
  });

  testWidgets('génération depuis une capture : 2 crédits, propositions', (
    tester,
  ) async {
    final backend = await openWithScreenshot(tester);
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    final request = backend.requests.single;
    expect(request.screenshot, tinyPng);
    expect(request.message, isNull);
    expect(request.situation, Situation.reply);
    expect(find.byType(ResultsScreen), findsOneWidget);
    expect(backend.wallet.dailyCredits, 3);
    expect(find.text('Régénérer (2 crédits)'), findsOneWidget);
  });

  testWidgets('retirer la capture fait revenir le champ message', (
    tester,
  ) async {
    await openWithScreenshot(tester);
    await tester.tap(find.byTooltip('Retirer la capture'));
    await tester.pumpAndSettle();

    expect(messageField, findsOneWidget);
    expect(find.text('Capture d\'écran sélectionnée'), findsNothing);
    expect(tester.widget<FilledButton>(generateButton).onPressed, isNull);
  });

  testWidgets('un seul crédit : la capture (2 crédits) est bloquée', (
    tester,
  ) async {
    await openWithScreenshot(
      tester,
      wallet: const Wallet(dailyCredits: 1, bonusCredits: 0, isPremium: false),
    );

    expect(
      find.textContaining('Tu as utilisé tes crédits du jour'),
      findsOneWidget,
    );
    expect(generateButton, findsNothing);
    expect(find.text('Passer Premium'), findsOneWidget);
  });

  testWidgets('Premium : capture incluse même sans crédit', (tester) async {
    final backend = await openWithScreenshot(
      tester,
      wallet: const Wallet(dailyCredits: 0, bonusCredits: 0, isPremium: true),
    );
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(backend.requests, hasLength(1));
  });

  testWidgets('capture illisible : explication, on reste sur l\'écran', (
    tester,
  ) async {
    final backend = await openWithScreenshot(tester)
      ..error = const UnreadableScreenshotFailure();
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Impossible de lire'), findsOneWidget);
    expect(find.byType(ResultsScreen), findsNothing);
    expect(backend.wallet.dailyCredits, 5);
  });

  testWidgets('sélection annulée : rien ne change', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final backend = FakeBackend()..pickedScreenshot = null;
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();

    await tester.tap(importButton);
    await tester.pumpAndSettle();

    expect(messageField, findsOneWidget);
    expect(find.text('Capture d\'écran sélectionnée'), findsNothing);
  });

  testWidgets('autre situation : la capture n\'est pas utilisée', (
    tester,
  ) async {
    final backend = await openWithScreenshot(tester);
    await tester.tap(find.text('Répondre à un message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flirter').last);
    await tester.pumpAndSettle();

    expect(find.text('Capture d\'écran sélectionnée'), findsNothing);
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(backend.requests.single.screenshot, isNull);
    expect(backend.requests.single.situation, Situation.flirt);
  });
}
