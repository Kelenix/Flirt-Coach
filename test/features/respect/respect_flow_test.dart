import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/respect/domain/respect_check.dart';
import 'package:flirt_coach/features/respect/presentation/respect_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final messageField = find.byKey(RespectScreen.messageFieldKey);
  final contextField = find.byKey(RespectScreen.contextFieldKey);
  final checkButton = filledButton('Vérifier mon message');

  Future<FakeBackend> openRespectScreen(
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
    await openRespectFromMenu(tester);
    return backend;
  }

  Future<void> submit(WidgetTester tester, String message) async {
    await tester.enterText(messageField, message);
    await tester.pump();
    await tester.tap(checkButton);
    await tester.pumpAndSettle();
  }

  testWidgets('accessible depuis l\'accueil, bouton bloqué sans message', (
    tester,
  ) async {
    await openRespectScreen(tester);

    expect(find.byType(RespectScreen), findsOneWidget);
    expect(find.textContaining('trop insistant'), findsOneWidget);
    expect(tester.widget<FilledButton>(checkButton).onPressed, isNull);
  });

  testWidgets('message respectueux : verdict positif, crédit décompté', (
    tester,
  ) async {
    final backend = await openRespectScreen(tester);
    await tester.enterText(contextField, ' Premier rendez-vous hier ');
    await submit(tester, ' On remet ça samedi ? ');

    expect(backend.respectRequests.single, (
      message: 'On remet ça samedi ?',
      context: 'Premier rendez-vous hier',
    ));
    expect(find.textContaining('Ton message est respectueux'), findsOneWidget);
    expect(find.text('Version plus respectueuse'), findsNothing);
    expect(find.text('4 crédits'), findsOneWidget);
  });

  testWidgets(
    'message à revoir : problèmes expliqués et alternative copiable',
    (tester) async {
      final backend = await openRespectScreen(tester)
        ..respectIssues = const [
          RespectIssue(
            category: RespectIssueCategory.insistent,
            explanation: 'Tu exiges une réponse immédiate.',
          ),
          RespectIssue(
            category: RespectIssueCategory.manipulative,
            explanation: 'Tu la culpabilises.',
          ),
        ]
        ..respectAlternative = 'Pas de pression, réponds quand tu veux.';
      await submit(tester, 'Réponds-moi maintenant !');

      expect(find.text('À revoir avant d\'envoyer'), findsOneWidget);
      expect(find.text('Trop insistant'), findsOneWidget);
      expect(find.text('Manipulateur'), findsOneWidget);
      expect(find.text('Tu la culpabilises.'), findsOneWidget);
      expect(find.text('Version plus respectueuse'), findsOneWidget);
      expect(
        find.text('Pas de pression, réponds quand tu veux.'),
        findsOneWidget,
      );
      expect(find.byTooltip('Copier'), findsOneWidget);
      expect(backend.wallet.dailyCredits, 4);
    },
  );

  testWidgets('plus de crédit : message clair, vérification bloquée', (
    tester,
  ) async {
    await openRespectScreen(
      tester,
      wallet: const Wallet(dailyCredits: 0, bonusCredits: 0, isPremium: false),
    );
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();

    expect(
      find.textContaining('Tu as utilisé tes crédits du jour'),
      findsOneWidget,
    );
    expect(checkButton, findsNothing);
    expect(find.text('Passer Premium'), findsOneWidget);
  });

  testWidgets('Premium sans crédit : vérification possible', (tester) async {
    final backend = await openRespectScreen(
      tester,
      wallet: const Wallet(dailyCredits: 0, bonusCredits: 0, isPremium: true),
    );
    await submit(tester, 'Coucou');

    expect(backend.respectRequests, hasLength(1));
  });

  testWidgets('IA indisponible : erreur, puis nouvelle tentative', (
    tester,
  ) async {
    final backend = await openRespectScreen(tester)
      ..error = const AiUnavailableFailure();
    await submit(tester, 'Coucou');

    expect(find.textContaining('momentanément indisponible'), findsOneWidget);

    backend.error = null;
    await tester.tap(checkButton);
    await tester.pumpAndSettle();
    expect(find.textContaining('Ton message est respectueux'), findsOneWidget);
  });

  testWidgets('petit écran et grande police : aucun débordement', (
    tester,
  ) async {
    final backend = await openRespectScreen(tester)
      ..respectIssues = const [
        RespectIssue(
          category: RespectIssueCategory.sexualized,
          explanation: 'Trop direct pour un premier message.',
        ),
      ]
      ..respectAlternative = 'Une version plus douce.';
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      messageField,
      100,
      scrollable: find.byType(Scrollable).first,
    );

    await submit(tester, 'Coucou');

    expect(backend.respectRequests, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
