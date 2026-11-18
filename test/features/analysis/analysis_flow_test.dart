import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/analysis/domain/conversation_analysis.dart';
import 'package:flirt_coach/features/analysis/presentation/analysis_screen.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/purchases/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  const premium = Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true);
  final conversationField = find.byKey(AnalysisScreen.conversationFieldKey);
  final contextField = find.byKey(AnalysisScreen.contextFieldKey);
  final analyzeButton = filledButton('Analyser la conversation');

  Future<FakeBackend> openAnalysis(
    WidgetTester tester, {
    Wallet wallet = premium,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final backend = FakeBackend(wallet: wallet);
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    await openAnalysisFromMenu(tester);
    return backend;
  }

  Future<void> analyze(WidgetTester tester) async {
    await tester.tap(analyzeButton);
    await tester.pumpAndSettle();
  }

  testWidgets('gratuit : écran verrouillé qui mène au paywall', (tester) async {
    final backend = await openAnalysis(
      tester,
      wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: false),
    );

    expect(find.text('Réservé à Premium'), findsOneWidget);
    expect(conversationField, findsNothing);

    await tester.tap(filledButton('Passer Premium'));
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(backend.analysisRequests, isEmpty);
  });

  testWidgets('Premium : bouton bloqué tant que la conversation est vide', (
    tester,
  ) async {
    await openAnalysis(tester);

    expect(find.byType(AnalysisScreen), findsOneWidget);
    expect(tester.widget<FilledButton>(analyzeButton).onPressed, isNull);
  });

  testWidgets('texte collé : analyse, prochaine étape et rendez-vous', (
    tester,
  ) async {
    final backend = await openAnalysis(tester);
    await tester.enterText(conversationField, ' Moi : salut\nElle : hey ');
    await tester.enterText(contextField, ' Rencontrés hier ');
    await tester.pump();
    await analyze(tester);

    expect(backend.analysisRequests.single, (
      conversation: 'Moi : salut\nElle : hey',
      screenshot: null,
      context: 'Rencontrés hier',
    ));
    expect(find.text('La conversation progresse'), findsOneWidget);
    expect(find.text('Propose-lui de vous voir.'), findsOneWidget);
    expect(find.text('On se voit cette semaine ?'), findsOneWidget);
    expect(find.text('Proposer un rendez-vous'), findsOneWidget);
    // Inclus dans Premium : aucun crédit décompté.
    expect(backend.wallet, premium);
  });

  testWidgets('conversation qui recule : pas de proposition de rendez-vous', (
    tester,
  ) async {
    final backend = await openAnalysis(tester)
      ..analysisMomentum = Momentum.declining
      ..analysisDate = null;
    await tester.enterText(conversationField, 'Elle : ok.');
    await tester.pump();
    await analyze(tester);

    expect(backend.analysisRequests, hasLength(1));
    expect(find.text('La conversation recule'), findsOneWidget);
    expect(find.text('Proposer un rendez-vous'), findsNothing);
  });

  testWidgets('capture d\'écran : envoyée à la place du texte', (tester) async {
    final backend = await openAnalysis(tester);
    await tester.tap(find.byTooltip('Importer une capture d\'écran'));
    await tester.pumpAndSettle();

    expect(conversationField, findsNothing);
    await analyze(tester);

    final request = backend.analysisRequests.single;
    expect(request.conversation, isNull);
    expect(request.screenshot, tinyPng);
  });

  testWidgets('erreur ou refus : message affiché, on peut réessayer', (
    tester,
  ) async {
    final backend = await openAnalysis(tester)
      ..error = const AiUnavailableFailure();
    await tester.enterText(conversationField, 'Elle : hey');
    await tester.pump();
    await analyze(tester);

    expect(find.textContaining('momentanément indisponible'), findsOneWidget);
    expect(find.text('La conversation progresse'), findsNothing);

    backend
      ..error = null
      ..refusal = '';
    await analyze(tester);
    expect(
      find.text('Je ne peux pas analyser cette conversation.'),
      findsOneWidget,
    );
  });
}
