import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

/// Recommandations d'accessibilité Android / iOS sur les écrans principaux :
/// cibles tactiles (48 dp / 44 pt), libellés des boutons, contraste du texte.
void main() {
  Future<void> expectAccessible(WidgetTester tester) async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  Future<FakeBackend> open(WidgetTester tester, {bool signedIn = true}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final backend = FakeBackend(
      wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: false),
    );
    await tester.pumpWidget(
      signedIn
          ? await buildSignedInApp(backend)
          : await buildTestApp(FakeAuthRepository()),
    );
    await tester.pumpAndSettle();
    return backend;
  }

  testWidgets('accueil 18+', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester, signedIn: false);
    await expectAccessible(tester);
    handle.dispose();
  });

  testWidgets('Générer', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    await expectAccessible(tester);
    handle.dispose();
  });

  for (final entry in [
    'Mode Respect',
    'Analyse',
    'Banque',
    'Historique',
    'Réglages',
  ]) {
    testWidgets('menu → $entry', (tester) async {
      final handle = tester.ensureSemantics();
      await open(tester);
      await openFromMenu(tester, entry);
      await expectAccessible(tester);
      handle.dispose();
    });
  }
}
