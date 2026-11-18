import 'dart:convert';
import 'dart:typed_data';

import 'package:flirt_coach/app.dart';
import 'package:flirt_coach/features/ads/data/ads_service.dart';
import 'package:flirt_coach/features/analysis/data/supabase_analysis_repository.dart';
import 'package:flirt_coach/features/analysis/domain/analysis_repository.dart';
import 'package:flirt_coach/features/analysis/domain/conversation_analysis.dart';
import 'package:flirt_coach/features/auth/data/supabase_auth_repository.dart';
import 'package:flirt_coach/features/auth/domain/auth_repository.dart';
import 'package:flirt_coach/features/credits/data/supabase_wallet_repository.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/credits/domain/wallet_repository.dart';
import 'package:flirt_coach/features/generation/data/screenshot_picker.dart';
import 'package:flirt_coach/features/history/data/supabase_history_repository.dart';
import 'package:flirt_coach/features/report/data/report_repository.dart';
import 'package:flirt_coach/features/report/domain/report.dart';
import 'package:flirt_coach/features/settings/data/account_repository.dart';
import 'package:flirt_coach/features/settings/domain/account_repository.dart';
import 'package:flirt_coach/features/history/domain/history_entry.dart';
import 'package:flirt_coach/features/message_bank/data/supabase_message_bank_repository.dart';
import 'package:flirt_coach/features/message_bank/domain/bank_message.dart';
import 'package:flirt_coach/features/generation/data/supabase_generation_repository.dart';
import 'package:flirt_coach/features/generation/domain/generation_repository.dart';
import 'package:flirt_coach/features/generation/domain/generation_request.dart';
import 'package:flirt_coach/features/generation/domain/generation_result.dart';
import 'package:flirt_coach/core/storage/preferences.dart';
import 'package:flirt_coach/features/purchases/application/annual_offer.dart';
import 'package:flirt_coach/features/credits/application/wallet_controller.dart';
import 'package:flirt_coach/features/purchases/data/revenuecat_purchases_repository.dart';
import 'package:flirt_coach/features/purchases/domain/catalog.dart';
import 'package:flirt_coach/features/purchases/domain/purchases_repository.dart';
import 'package:flirt_coach/features/respect/data/supabase_respect_repository.dart';
import 'package:flirt_coach/features/respect/domain/respect_check.dart';
import 'package:flirt_coach/features/respect/domain/respect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.hasSession = false, this.error});

  @override
  bool hasSession;

  /// Si défini, les appels réseau échouent avec cette erreur.
  Object? error;

  bool isAgeConfirmed = false;

  @override
  String? get userId => hasSession ? 'test-user-id' : null;

  @override
  Future<void> signInAnonymously() async {
    if (error case final error?) throw error;
    hasSession = true;
  }

  @override
  Future<void> confirmAge() async {
    if (error case final error?) throw error;
    isAgeConfirmed = true;
  }
}

/// Simule le serveur : portefeuille partagé, 1 crédit par appel IA réussi,
/// et le store + webhook pour les achats.
class FakeBackend
    implements
        WalletRepository,
        GenerationRepository,
        RespectRepository,
        AnalysisRepository,
        MessageBankRepository,
        HistoryRepository,
        ReportRepository,
        AccountRepository,
        PurchasesRepository,
        AdsService {
  FakeBackend({
    this.wallet = const Wallet(
      dailyCredits: 5,
      bonusCredits: 0,
      isPremium: false,
    ),
  });

  Wallet wallet;

  /// Si défini, le prochain appel IA échoue avec cette erreur.
  Object? error;

  /// Si défini, le prochain appel IA est refusé avec cette raison.
  String? refusal;

  /// Verdict renvoyé par le mode Respect (par défaut : message respectueux).
  List<RespectIssue> respectIssues = const [];
  String? respectAlternative;

  /// Image renvoyée par le sélecteur de photos (`null` : l'utilisateur annule).
  Uint8List? pickedScreenshot = tinyPng;

  /// Achats : erreur à lever, annulation par l'utilisateur, webhook reçu ou non.
  Object? purchaseError;
  bool cancelPurchase = false;
  bool webhookDelivered = true;

  /// Restauration : abonnement retrouvé sur le compte store.
  bool hasStoreSubscription = false;

  final boughtProducts = <String>[];

  /// Publicités : consentement obtenu, résultat de la vidéo, rappel AdMob reçu.
  bool adsReady = false;

  /// Si défini, chaque génération attend ce signal (serveur lent).
  Future<void>? generationGate;

  /// Nombre de demandes de consentement / préparation des publicités.
  int prepareCalls = 0;
  RewardedVideoResult videoResult = RewardedVideoResult.watched;
  bool rewardDelivered = true;
  String? rewardedUserId;

  final requests = <GenerationRequest>[];
  final respectRequests = <({String message, String? context})>[];

  /// Signalements reçus ; suppression du compte ; choix publicitaires.
  final reports = <({String generationId, String text, ReportReason reason})>[];
  bool accountDeleted = false;
  Object? accountError;
  bool adPrivacyRequired = false;
  int privacyOptionsShown = 0;

  /// Historique (le plus récent d'abord) et identifiants supprimés.
  List<HistoryEntry> history = const [];
  final deletedHistory = <String>[];
  Object? historyError;

  /// Banque de messages : une erreur à lever, sinon 2 messages par catégorie.
  Object? bankError;

  final analysisRequests =
      <({String? conversation, Uint8List? screenshot, String? context})>[];

  /// Analyse renvoyée (par défaut : conversation qui progresse, avec rendez-vous).
  Momentum analysisMomentum = Momentum.progressing;
  String? analysisDate = 'Un café samedi ?';

  @override
  Future<Wallet> fetch() async => wallet;

  void _spendCredits([int cost = 1]) {
    if (wallet.isPremium) return;
    wallet = wallet.copyWith(dailyCredits: wallet.dailyCredits - cost);
  }

  @override
  Future<GenerationResult> generate(GenerationRequest request) async {
    requests.add(request);
    if (generationGate case final gate?) await gate;
    if (error case final error?) throw error;
    if (refusal case final reason?) {
      return GenerationResult.refused(reason: reason, wallet: wallet);
    }
    _spendCredits(request.cost);
    final round = requests.length;
    return GenerationResult.proposals(
      id: 'gen-$round',
      proposals: [for (var i = 1; i <= 3; i++) 'Proposition $round.$i'],
      wallet: wallet,
    );
  }

  @override
  Future<RespectCheck> check({required String message, String? context}) async {
    respectRequests.add((message: message, context: context));
    if (error case final error?) throw error;
    if (refusal case final reason?) {
      return RespectCheck.refused(reason: reason, wallet: wallet);
    }
    _spendCredits();
    return RespectCheck.verdict(
      isRespectful: respectIssues.isEmpty,
      issues: respectIssues,
      alternative: respectAlternative,
      wallet: wallet,
    );
  }

  @override
  Future<ConversationAnalysis> analyze({
    String? conversation,
    Uint8List? screenshot,
    String? context,
  }) async {
    analysisRequests.add((
      conversation: conversation,
      screenshot: screenshot,
      context: context,
    ));
    if (error case final error?) throw error;
    if (refusal case final reason?) {
      return ConversationAnalysis.refused(reason: reason, wallet: wallet);
    }
    return ConversationAnalysis.result(
      momentum: analysisMomentum,
      summary: 'Vous échangez avec plaisir.',
      nextStep: 'Propose-lui de vous voir.',
      suggestedMessage: 'On se voit cette semaine ?',
      dateSuggestion: analysisDate,
      wallet: wallet,
    );
  }

  @override
  Future<List<BankMessage>> fetchAll() async {
    if (bankError case final error?) throw error;
    return [
      for (final category in BankCategory.values)
        for (var i = 1; i <= 2; i++)
          BankMessage(category: category, body: '${category.apiName} $i'),
    ];
  }

  @override
  Future<List<HistoryEntry>> fetchPage({
    HistoryEntry? after,
    required int limit,
  }) async {
    if (historyError case final error?) throw error;
    final start = after == null
        ? 0
        : history.indexWhere((entry) => entry.id == after.id) + 1;
    return history.skip(start).take(limit).toList();
  }

  @override
  Future<void> delete(String id) async {
    if (historyError case final error?) throw error;
    deletedHistory.add(id);
    history = [
      for (final entry in history)
        if (entry.id != id) entry,
    ];
  }

  @override
  Future<void> report({
    required String generationId,
    required String text,
    required ReportReason reason,
  }) async {
    if (error case final error?) throw error;
    reports.add((generationId: generationId, text: text, reason: reason));
  }

  @override
  Future<void> deleteAccount() async {
    if (accountError case final error?) throw error;
    accountDeleted = true;
  }

  @override
  Future<bool> privacyOptionsRequired() async => adPrivacyRequired;

  @override
  Future<void> showPrivacyOptions() async => privacyOptionsShown++;

  static const catalog = Catalog(
    plans: [
      PremiumPlan(
        productId: 'flirtcoach_premium_weekly',
        period: PlanPeriod.weekly,
        priceLabel: '6,99 €',
      ),
      PremiumPlan(
        productId: 'flirtcoach_premium_monthly',
        period: PlanPeriod.monthly,
        priceLabel: '12,99 €',
      ),
      PremiumPlan(
        productId: 'flirtcoach_premium_annual',
        period: PlanPeriod.annual,
        priceLabel: '49,99 €',
        introPriceLabel: '29,99 €',
      ),
    ],
    packs: [
      CreditPack(
        productId: 'flirtcoach_credits_20',
        credits: 20,
        priceLabel: '2,99 €',
      ),
      CreditPack(
        productId: 'flirtcoach_credits_50',
        credits: 50,
        priceLabel: '5,99 €',
      ),
    ],
  );

  @override
  Future<Catalog> fetchCatalog() async {
    if (purchaseError case final error?) throw error;
    return catalog;
  }

  @override
  Future<bool> buy(String productId) async {
    if (purchaseError case final error?) throw error;
    if (cancelPurchase) return false;
    boughtProducts.add(productId);
    if (!webhookDelivered) return true;
    wallet = productId.startsWith('flirtcoach_premium')
        ? wallet.copyWith(isPremium: true)
        : wallet.copyWith(
            bonusCredits:
                wallet.bonusCredits + int.parse(productId.split('_').last),
          );
    return true;
  }

  @override
  Future<void> restore() async {
    if (hasStoreSubscription) wallet = wallet.copyWith(isPremium: true);
  }

  @override
  Future<bool> prepare() async {
    prepareCalls++;
    return adsReady;
  }

  @override
  Widget banner() => const SizedBox(key: Key('fake-banner'), height: 50);

  @override
  Future<RewardedVideoResult> showRewardedVideo(String userId) async {
    rewardedUserId = userId;
    if (videoResult == RewardedVideoResult.watched && rewardDelivered) {
      wallet = wallet.copyWith(
        bonusCredits: wallet.bonusCredits + 2,
        adRewardsLeft: wallet.adRewardsLeft - 1,
      );
    }
    return videoResult;
  }
}

Future<List<Override>> testOverrides(
  AuthRepository auth, {
  bool isAgeConfirmed = false,
  FakeBackend? backend,
  Map<String, Object> preferences = const {},
  DateTime? now,
}) async {
  SharedPreferences.setMockInitialValues({
    if (isAgeConfirmed) 'age_confirmed': true,
    ...preferences,
  });
  final storage = await SharedPreferences.getInstance();
  final server = backend ?? FakeBackend();
  return [
    sharedPreferencesProvider.overrideWithValue(storage),
    authRepositoryProvider.overrideWithValue(auth),
    walletRepositoryProvider.overrideWithValue(server),
    generationRepositoryProvider.overrideWithValue(server),
    respectRepositoryProvider.overrideWithValue(server),
    analysisRepositoryProvider.overrideWithValue(server),
    messageBankRepositoryProvider.overrideWithValue(server),
    historyRepositoryProvider.overrideWithValue(server),
    reportRepositoryProvider.overrideWithValue(server),
    accountRepositoryProvider.overrideWithValue(server),
    purchasesRepositoryProvider.overrideWithValue(server),
    adsServiceProvider.overrideWithValue(server),
    serverConfirmationDelayProvider.overrideWithValue(Duration.zero),
    if (now != null) clockProvider.overrideWithValue(() => now),
    screenshotPickerProvider.overrideWithValue(
      () async => server.pickedScreenshot,
    ),
  ];
}

Future<Widget> buildTestApp(
  AuthRepository auth, {
  bool isAgeConfirmed = false,
  FakeBackend? backend,
  Map<String, Object> preferences = const {},
  DateTime? now,
}) async => ProviderScope(
  overrides: await testOverrides(
    auth,
    isAgeConfirmed: isAgeConfirmed,
    backend: backend,
    preferences: preferences,
    now: now,
  ),
  child: const FlirtCoachApp(),
);

/// Application ouverte directement sur l'écran Générer (âge confirmé, session).
Future<Widget> buildSignedInApp(
  FakeBackend backend, {
  Map<String, Object> preferences = const {},
  DateTime? now,
}) => buildTestApp(
  FakeAuthRepository(hasSession: true),
  isAgeConfirmed: true,
  backend: backend,
  preferences: preferences,
  now: now,
);

/// PNG valide de 1 × 1 pixel, pour simuler une capture d'écran.
final tinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/x8AAwMCAO+ip1sAAAAASUVORK5CYII=',
);

/// Bouton rempli portant [label] (les boutons du kit peuvent avoir une icône).
Finder filledButton(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((widget) => widget is FilledButton),
);

/// Ouvre le Mode Respect depuis le menu de l'écran Générer.
Future<void> openRespectFromMenu(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Mode Respect'));
  await tester.pumpAndSettle();
}

/// Ouvre une entrée du menu de l'écran Générer.
Future<void> openFromMenu(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

/// Ouvre l'analyse de conversation depuis le menu de l'écran Générer.
Future<void> openAnalysisFromMenu(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Analyse'));
  await tester.pumpAndSettle();
}
