import 'package:flirt_coach/features/ads/data/ads_service.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/respect/presentation/respect_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final banner = find.byKey(const Key('fake-banner'));
  final watchButton = find.text('Regarder une pub (+2 crédits)');
  const outOfCredits = Wallet(
    dailyCredits: 0,
    bonusCredits: 0,
    isPremium: false,
    adRewardsLeft: 5,
  );

  Future<FakeBackend> open(
    WidgetTester tester, {
    Wallet wallet = const Wallet(
      dailyCredits: 5,
      bonusCredits: 0,
      isPremium: false,
      adRewardsLeft: 5,
    ),
    bool adsReady = true,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final backend = FakeBackend(wallet: wallet)..adsReady = adsReady;
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    return backend;
  }

  group('bannière', () {
    testWidgets('utilisateur gratuit, consentement obtenu : bannière en bas', (
      tester,
    ) async {
      await open(tester);
      expect(banner, findsOneWidget);
    });

    testWidgets('Premium : aucune publicité', (tester) async {
      await open(
        tester,
        wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true),
      );
      expect(banner, findsNothing);
    });

    testWidgets('consentement refusé ou indisponible : aucune publicité', (
      tester,
    ) async {
      await open(tester, adsReady: false);
      expect(banner, findsNothing);
    });
  });

  group('vidéo récompensée', () {
    testWidgets('crédits ajoutés par le serveur après la vidéo', (
      tester,
    ) async {
      final backend = await open(tester, wallet: outOfCredits);
      expect(
        find.textContaining('Tu as utilisé tes crédits du jour'),
        findsOneWidget,
      );

      await tester.tap(watchButton);
      await tester.pumpAndSettle();

      expect(backend.rewardedUserId, 'test-user-id');
      expect(find.text('+2 crédits ajoutés, merci !'), findsOneWidget);
      expect(find.text('2 crédits'), findsOneWidget);
      expect(
        find.textContaining('Tu as utilisé tes crédits du jour'),
        findsNothing,
      );
    });

    testWidgets('rappel AdMob en retard : message d\'attente honnête', (
      tester,
    ) async {
      final backend = await open(tester, wallet: outOfCredits)
        ..rewardDelivered = false;
      await tester.tap(watchButton);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('arrivent dans quelques instants'),
        findsOneWidget,
      );
      expect(backend.wallet.bonusCredits, 0);
    });

    testWidgets('vidéo interrompue : rien gagné, explication', (tester) async {
      final backend = await open(tester, wallet: outOfCredits)
        ..videoResult = RewardedVideoResult.interrupted;
      await tester.tap(watchButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('jusqu\'au bout'), findsOneWidget);
      expect(backend.wallet.bonusCredits, 0);
    });

    testWidgets('aucune vidéo disponible : message clair', (tester) async {
      final backend = await open(tester, wallet: outOfCredits);
      backend.videoResult = RewardedVideoResult.unavailable;
      await tester.tap(watchButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Aucune vidéo disponible'), findsOneWidget);
    });

    testWidgets('5 vidéos déjà vues aujourd\'hui : plus de bouton vidéo', (
      tester,
    ) async {
      await open(tester, wallet: outOfCredits.copyWith(adRewardsLeft: 0));
      expect(watchButton, findsNothing);
      expect(find.text('Passer Premium'), findsOneWidget);
    });

    testWidgets('mode Respect sans crédit : vidéo proposée aussi', (
      tester,
    ) async {
      await open(tester, wallet: outOfCredits);
      await openRespectFromMenu(tester);

      expect(find.byType(RespectScreen), findsOneWidget);
      expect(watchButton, findsOneWidget);
    });
  });
}
