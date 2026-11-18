import 'dart:async';

import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/generation/presentation/results_screen.dart';
import 'package:flirt_coach/features/onboarding/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Tests de non-régression des défauts trouvés par la revue de la phase 5.
void main() {
  const free = Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: false);
  const premium = Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true);
  final messageField = find.byKey(GenerateScreen.messageFieldKey);
  final generate = filledButton('Générer 3 réponses');

  Future<FakeBackend> open(WidgetTester tester, {Wallet wallet = free}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final backend = FakeBackend(wallet: wallet);
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    return backend;
  }

  testWidgets('C1 — une erreur après un succès ne rouvre pas les anciennes '
      'propositions', (tester) async {
    final backend = await open(tester);
    await tester.enterText(messageField, 'Premier message');
    await tester.pump();
    await tester.tap(generate);
    await tester.pumpAndSettle();
    expect(find.byType(ResultsScreen), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    backend.error = const AiUnavailableFailure();
    await tester.enterText(messageField, 'Autre conversation');
    await tester.pump();
    await tester.tap(generate);
    await tester.pumpAndSettle();

    expect(find.byType(ResultsScreen), findsNothing);
    expect(find.textContaining('momentanément indisponible'), findsOneWidget);
  });

  testWidgets('C2 — après suppression du compte, le nouveau compte voit son '
      'propre portefeuille', (tester) async {
    final backend = await open(tester, wallet: premium);
    expect(find.text('Premium'), findsOneWidget);

    await openFromMenu(tester, 'Réglages');
    await tester.tap(find.text('Supprimer mon compte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer définitivement'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);

    backend.wallet = free;
    await tester.tap(find.text("J'ai 18 ans ou plus"));
    await tester.pump();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('5 crédits'), findsOneWidget);
    expect(find.text('Premium'), findsNothing);
  });

  testWidgets('C3 — retour dans l\'app : portefeuille relu', (tester) async {
    final backend = await open(tester);
    expect(find.text('5 crédits'), findsOneWidget);

    backend.wallet = free.copyWith(bonusCredits: 20);
    // Mise en arrière-plan puis retour, dans l'ordre réel des états Android.
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pumpAndSettle();

    expect(find.text('25 crédits'), findsOneWidget);
  });

  testWidgets('C4 — deux achats identiques sont confirmés deux fois', (
    tester,
  ) async {
    final backend = await open(tester);
    await tester.tap(find.text('Drôle'));
    await tester.pumpAndSettle();
    final pack = find.text('20 crédits');
    await tester.scrollUntilVisible(
      pack,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(pack);
    await tester.pumpAndSettle();

    await tester.tap(pack);
    await tester.pumpAndSettle();
    expect(find.text('Tes crédits ont été ajoutés.'), findsOneWidget);
    // Le message disparaît, puis second achat identique.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Tes crédits ont été ajoutés.'), findsNothing);

    await tester.tap(pack);
    await tester.pumpAndSettle();
    expect(find.text('Tes crédits ont été ajoutés.'), findsOneWidget);
    expect(backend.boughtProducts, hasLength(2));
  });

  testWidgets('C6 — une capture importée depuis le menu bascule sur '
      '« Répondre »', (tester) async {
    await open(tester);
    await tester.tap(find.text('Répondre à un message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Démarrer une conversation').last);
    await tester.pumpAndSettle();
    expect(find.text('Capture d\'écran sélectionnée'), findsNothing);

    await openFromMenu(tester, 'Capture d\'écran');

    expect(find.text('Capture d\'écran sélectionnée'), findsOneWidget);
    expect(find.text('Répondre à un message'), findsOneWidget);
  });

  testWidgets('C8 — aucun consentement publicitaire demandé à un Premium', (
    tester,
  ) async {
    final premiumBackend = await open(tester, wallet: premium);
    expect(premiumBackend.prepareCalls, 0);
  });

  testWidgets('C8 — le consentement est préparé pour un gratuit', (
    tester,
  ) async {
    final freeBackend = await open(tester);
    expect(freeBackend.prepareCalls, greaterThan(0));
  });

  testWidgets('C10 — un double tap ne lance qu\'une génération', (
    tester,
  ) async {
    final backend = await open(tester);
    // Serveur lent : le second tap arrive pendant que le premier appel attend.
    final slowServer = Completer<void>();
    backend.generationGate = slowServer.future;
    await tester.enterText(messageField, 'Salut !');
    await tester.pump();
    await tester.tap(generate);
    await tester.tap(generate);
    slowServer.complete();
    await tester.pumpAndSettle();

    expect(backend.requests, hasLength(1));
  });
}
