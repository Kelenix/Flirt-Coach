import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/message_bank/presentation/message_bank_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<FakeBackend> openBank(
    WidgetTester tester, {
    FakeBackend? backend,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final server = backend ?? FakeBackend();
    await tester.pumpWidget(await buildSignedInApp(server));
    await tester.pumpAndSettle();
    await openFromMenu(tester, 'Banque');
    return server;
  }

  testWidgets('5 catégories, messages de la première affichés', (tester) async {
    await openBank(tester);

    expect(find.byType(MessageBankScreen), findsOneWidget);
    for (final label in [
      'Ouverture',
      'Relance',
      'Rendez-vous',
      'Excuses',
      'Rupture douce',
    ]) {
      expect(find.widgetWithText(Tab, label), findsOneWidget);
    }
    expect(find.text('opener 1'), findsOneWidget);
    expect(find.text('Message 2'), findsOneWidget);
  });

  testWidgets('changer d\'onglet affiche la catégorie choisie', (tester) async {
    await openBank(tester);
    // Onglets défilants : « Excuses » peut être hors de l'écran.
    await tester.ensureVisible(find.widgetWithText(Tab, 'Excuses'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Excuses'));
    await tester.pumpAndSettle();

    expect(find.text('apology 1'), findsOneWidget);
    expect(find.text('opener 1'), findsNothing);
  });

  testWidgets('copier : texte dans le presse-papiers, sans crédit', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final backend = await openBank(tester);
    await tester.tap(find.byTooltip('Copier').first);
    await tester.pumpAndSettle();

    expect(copied, 'opener 1');
    expect(find.textContaining('Copié !'), findsOneWidget);
    expect(
      backend.wallet,
      const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: false),
    );
  });

  testWidgets('erreur sans copie locale : message et Réessayer', (
    tester,
  ) async {
    final backend = FakeBackend()..bankError = const NetworkFailure();
    await openBank(tester, backend: backend);

    expect(find.textContaining('Pas de connexion'), findsOneWidget);

    backend.bankError = null;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('opener 1'), findsOneWidget);
  });
}
