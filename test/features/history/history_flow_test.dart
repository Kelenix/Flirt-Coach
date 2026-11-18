import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/history/domain/history_entry.dart';
import 'package:flirt_coach/features/history/presentation/history_screen.dart';
import 'package:flirt_coach/features/purchases/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  const premium = Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true);

  /// [count] entrées, une par minute, la plus récente d'abord.
  List<HistoryEntry> entries(int count) => [
    for (var i = 1; i <= count; i++)
      HistoryEntry(
        id: 'gen-$i',
        kind: i.isOdd ? 'reply' : 'respect_check',
        createdAt: DateTime(2026, 11, 18, 12).subtract(Duration(minutes: i)),
        input: 'Message $i',
        results: ['Réponse $i'],
      ),
  ];

  Future<FakeBackend> openHistory(
    WidgetTester tester, {
    Wallet wallet = premium,
    List<HistoryEntry> history = const [],
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final backend = FakeBackend(wallet: wallet)..history = history;
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    await openFromMenu(tester, 'Historique');
    return backend;
  }

  testWidgets('gratuit : verrouillé, mène au paywall', (tester) async {
    await openHistory(
      tester,
      wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: false),
      history: entries(2),
    );

    expect(find.byType(HistoryScreen), findsOneWidget);
    expect(find.text('Réservé à Premium'), findsOneWidget);
    expect(find.text('Réponse 1'), findsNothing);

    await tester.tap(filledButton('Passer Premium'));
    await tester.pumpAndSettle();
    expect(find.byType(PaywallScreen), findsOneWidget);
  });

  testWidgets('Premium sans génération : message d\'accueil', (tester) async {
    await openHistory(tester);

    expect(find.text('Tes messages générés apparaîtront ici.'), findsOneWidget);
  });

  testWidgets('Premium : entrées avec type, message saisi et réponse', (
    tester,
  ) async {
    await openHistory(tester, history: entries(2));

    expect(find.text('Répondre à un message'), findsOneWidget);
    expect(find.text('Mode Respect'), findsOneWidget);
    expect(find.text('« Message 1 »'), findsOneWidget);
    expect(find.text('Réponse 1'), findsOneWidget);
    expect(find.text('Afficher plus'), findsNothing);
  });

  testWidgets('pagination : 20 entrées, puis « Afficher plus »', (
    tester,
  ) async {
    await openHistory(tester, history: entries(25));

    await tester.scrollUntilVisible(find.text('Afficher plus'), 500);
    expect(find.text('Réponse 21'), findsNothing);

    await tester.tap(find.text('Afficher plus'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Réponse 25'), 500);

    expect(find.text('Réponse 25'), findsOneWidget);
    expect(find.text('Afficher plus'), findsNothing);
  });

  testWidgets('suppression : confirmée, l\'entrée disparaît', (tester) async {
    final backend = await openHistory(tester, history: entries(2));

    await tester.tap(find.byTooltip('Supprimer').first);
    await tester.pumpAndSettle();
    expect(find.text('Supprimer cette entrée ?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(backend.deletedHistory, ['gen-1']);
    expect(find.text('Réponse 1'), findsNothing);
    expect(find.text('Réponse 2'), findsOneWidget);
  });

  testWidgets('suppression annulée : rien ne change', (tester) async {
    final backend = await openHistory(tester, history: entries(1));

    await tester.tap(find.byTooltip('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(backend.deletedHistory, isEmpty);
    expect(find.text('Réponse 1'), findsOneWidget);
  });

  testWidgets('erreur réseau : message et Réessayer', (tester) async {
    final backend = FakeBackend(wallet: premium)
      ..historyError = const NetworkFailure();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    await openFromMenu(tester, 'Historique');

    expect(find.textContaining('Pas de connexion'), findsOneWidget);

    backend
      ..historyError = null
      ..history = entries(1);
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('Réponse 1'), findsOneWidget);
  });
}
