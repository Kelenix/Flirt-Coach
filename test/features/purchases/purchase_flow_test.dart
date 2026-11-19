import 'package:flirt_coach/core/theme/app_icons.dart';
import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/purchases/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final continueButton = filledButton('Continuer');
  final now = DateTime(2026, 11, 18, 12);

  Future<FakeBackend> open(
    WidgetTester tester, {
    Wallet wallet = const Wallet(
      dailyCredits: 5,
      bonusCredits: 0,
      isPremium: false,
    ),
    Map<String, Object> preferences = const {},
    FakeBackend? backend,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final server = backend ?? FakeBackend(wallet: wallet);
    await tester.pumpWidget(
      await buildSignedInApp(server, preferences: preferences, now: now),
    );
    await tester.pumpAndSettle();
    return server;
  }

  /// Fait défiler le paywall jusqu'à [finder] (la liste ne construit que le visible).
  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openPaywall(WidgetTester tester) async {
    await tester.tap(find.text('Drôle'));
    await tester.pumpAndSettle();
  }

  testWidgets('style verrouillé → paywall : 3 offres, mentions, packs', (
    tester,
  ) async {
    await open(tester);
    await openPaywall(tester);

    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.text('Passe à Premium'), findsOneWidget);
    expect(find.text('6,99 € / semaine'), findsOneWidget);
    expect(find.text('12,99 € / mois'), findsOneWidget);
    expect(find.text('49,99 € / an'), findsOneWidget);
    expect(find.text('Le plus choisi'), findsOneWidget);
    await reveal(tester, find.textContaining('renouvelé automatiquement'));
    expect(find.text('Meilleur prix'), findsOneWidget);
    await reveal(tester, find.text('20 crédits'));
    expect(find.text('2,99 €'), findsOneWidget);
  });

  testWidgets('abonnement hebdo : Premium activé, retour, styles débloqués', (
    tester,
  ) async {
    final backend = await open(tester);
    await openPaywall(tester);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(backend.boughtProducts, ['flirtcoach_premium_weekly']);
    expect(find.text('Bienvenue dans Premium !'), findsOneWidget);
    expect(find.byType(GenerateScreen), findsOneWidget);
    expect(find.byType(PaywallScreen), findsNothing);
    expect(find.byIcon(AppIcons.lock), findsNothing);
    expect(find.text('Premium'), findsOneWidget);
  });

  testWidgets('choix de l\'annuel puis achat', (tester) async {
    final backend = await open(tester);
    await openPaywall(tester);
    await reveal(tester, find.text('Annuel'));
    await tester.tap(find.text('Annuel'));
    await tester.pump();
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(backend.boughtProducts, ['flirtcoach_premium_annual']);
  });

  testWidgets('pack de crédits : crédits ajoutés, on reste sur le paywall', (
    tester,
  ) async {
    await open(tester);
    await openPaywall(tester);
    await reveal(tester, find.text('20 crédits'));
    await tester.tap(find.text('20 crédits'));
    await tester.pumpAndSettle();

    expect(find.text('Tes crédits ont été ajoutés.'), findsOneWidget);
    expect(find.byType(PaywallScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('25 crédits'), findsOneWidget);
  });

  testWidgets('achat annulé : rien ne se passe', (tester) async {
    final backend = await open(tester);
    backend.cancelPurchase = true;
    await openPaywall(tester);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(backend.wallet.isPremium, isFalse);
  });

  testWidgets('webhook en retard : message d\'attente honnête', (tester) async {
    final backend = await open(tester);
    backend.webhookDelivered = false;
    await openPaywall(tester);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('arrivent dans quelques instants'),
      findsOneWidget,
    );
    expect(find.byType(PaywallScreen), findsOneWidget);
  });

  testWidgets('achats indisponibles : explication, pas d\'offre', (
    tester,
  ) async {
    final backend = await open(tester);
    backend.purchaseError = const PurchasesUnavailableFailure();
    await openPaywall(tester);

    expect(
      find.text('Les achats ne sont pas disponibles pour le moment.'),
      findsOneWidget,
    );
    expect(continueButton, findsNothing);
  });

  testWidgets('restauration : abonnement retrouvé, puis aucun', (tester) async {
    final backend = await open(tester);
    await openPaywall(tester);
    await reveal(tester, find.text('Restaurer mes achats'));
    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Aucun abonnement actif'), findsOneWidget);

    backend.hasStoreSubscription = true;
    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Premium est actif'), findsOneWidget);
    expect(find.byType(GenerateScreen), findsOneWidget);
  });

  testWidgets(
    'nouveau téléphone : abonnement retrouvé, Premium attendu du serveur',
    (tester) async {
      final backend = await open(tester);
      backend
        ..hasStoreSubscription = true
        ..webhookDelivered = false;
      await openPaywall(tester);
      await reveal(tester, find.text('Restaurer mes achats'));
      await tester.tap(find.text('Restaurer mes achats'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Abonnement retrouvé : Premium s\'active dans quelques instants.',
        ),
        findsOneWidget,
      );
      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(backend.wallet.isPremium, isFalse);
    },
  );

  testWidgets('plus de crédit : bouton vers le paywall', (tester) async {
    await open(
      tester,
      wallet: const Wallet(dailyCredits: 0, bonusCredits: 0, isPremium: false),
    );
    await tester.tap(find.text('Passer Premium'));
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
  });

  testWidgets('la pastille de crédits ouvre le paywall', (tester) async {
    await open(tester);
    await tester.tap(find.text('5 crédits'));
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
  });

  group('offre annuelle à J+3', () {
    String daysAgo(int days) =>
        now.subtract(Duration(days: days)).toIso8601String();

    testWidgets('première utilisation : pas d\'offre', (tester) async {
      await open(tester);
      expect(find.byType(PaywallScreen), findsNothing);
    });

    testWidgets('2 jours après : pas encore', (tester) async {
      await open(tester, preferences: {'first_seen_at': daysAgo(2)});
      expect(find.byType(PaywallScreen), findsNothing);
    });

    testWidgets(
      '3 jours après : offre annuelle mise en avant, une seule fois',
      (tester) async {
        await open(tester, preferences: {'first_seen_at': daysAgo(3)});

        expect(find.byType(PaywallScreen), findsOneWidget);
        expect(
          find.text('Offre spéciale : Premium à l\'année'),
          findsOneWidget,
        );
        await reveal(tester, find.text('Offre spéciale'));
        expect(find.text('29,99 € pour commencer'), findsOneWidget);

        await tester.tap(continueButton);
        await tester.pumpAndSettle();
        expect(find.byType(GenerateScreen), findsOneWidget);
      },
    );

    testWidgets('déjà montrée : plus jamais', (tester) async {
      await open(
        tester,
        preferences: {'first_seen_at': daysAgo(10), 'annual_offer_shown': true},
      );
      expect(find.byType(PaywallScreen), findsNothing);
    });

    testWidgets('abonné Premium : jamais d\'offre', (tester) async {
      await open(
        tester,
        wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true),
        preferences: {'first_seen_at': daysAgo(10)},
      );
      expect(find.byType(PaywallScreen), findsNothing);
    });
  });
}
