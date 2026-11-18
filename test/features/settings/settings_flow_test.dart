import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/core/storage/preferences.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/legal/presentation/legal_screen.dart';
import 'package:flirt_coach/features/onboarding/presentation/welcome_screen.dart';
import 'package:flirt_coach/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
  }

  Future<FakeBackend> openSettings(
    WidgetTester tester, {
    FakeBackend? backend,
  }) async {
    usePhoneViewport(tester);
    final server = backend ?? FakeBackend();
    await tester.pumpWidget(await buildSignedInApp(server));
    await tester.pumpAndSettle();
    await openFromMenu(tester, 'Réglages');
    return server;
  }

  Future<void> confirmDeletion(WidgetTester tester) async {
    await tester.tap(find.text('Supprimer mon compte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer définitivement'));
    await tester.pumpAndSettle();
  }

  testWidgets('réglages : sections et liens', (tester) async {
    await openSettings(tester);

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Premium et crédits'), findsOneWidget);
    expect(find.text('Politique de confidentialité'), findsOneWidget);
    expect(find.text('Conditions d\'utilisation'), findsOneWidget);
    expect(find.text('Supprimer mon compte'), findsOneWidget);
    // Gratuit et sans consentement publicitaire requis : liens masqués.
    expect(find.text('Gérer mon abonnement'), findsNothing);
    expect(find.text('Préférences publicitaires'), findsNothing);
  });

  testWidgets('Premium : lien de gestion de l\'abonnement', (tester) async {
    await openSettings(
      tester,
      backend: FakeBackend(
        wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true),
      ),
    );

    expect(find.text('Gérer mon abonnement'), findsOneWidget);
  });

  testWidgets('préférences publicitaires : rouvre le formulaire', (
    tester,
  ) async {
    final backend = await openSettings(
      tester,
      backend: FakeBackend()..adPrivacyRequired = true,
    );

    await tester.tap(find.text('Préférences publicitaires'));
    await tester.pumpAndSettle();

    expect(backend.privacyOptionsShown, 1);
  });

  testWidgets('politique de confidentialité : texte affiché', (tester) async {
    await openSettings(tester);
    await tester.tap(find.text('Politique de confidentialité'));
    await tester.pumpAndSettle();

    expect(find.byType(LegalScreen), findsOneWidget);
    expect(find.text('Qui sommes-nous'), findsOneWidget);
    // Éditeur et contact non configurés dans les tests.
    expect(
      find.textContaining('(à compléter avant publication)'),
      findsWidgets,
    );
  });

  testWidgets('suppression annulée : rien ne change', (tester) async {
    final backend = await openSettings(tester);
    await tester.tap(find.text('Supprimer mon compte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(backend.accountDeleted, isFalse);
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets(
    'suppression confirmée : retour à l\'accueil 18+, préférences effacées',
    (tester) async {
      final backend = await openSettings(tester);
      await confirmDeletion(tester);

      expect(backend.accountDeleted, isTrue);
      expect(find.byType(WelcomeScreen), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(WelcomeScreen)),
      );
      expect(container.read(sharedPreferencesProvider).getKeys(), isEmpty);
    },
  );

  testWidgets('suppression en échec : message, compte conservé', (
    tester,
  ) async {
    final backend = await openSettings(
      tester,
      backend: FakeBackend()..accountError = const NetworkFailure(),
    );
    await confirmDeletion(tester);

    expect(find.textContaining('Pas de connexion'), findsOneWidget);
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(backend.accountDeleted, isFalse);
  });

  testWidgets('accueil 18+ : conditions lisibles avant de confirmer l\'âge', (
    tester,
  ) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Conditions'));
    await tester.pumpAndSettle();

    expect(find.byType(LegalScreen), findsOneWidget);
    expect(find.text('Âge minimum'), findsOneWidget);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
