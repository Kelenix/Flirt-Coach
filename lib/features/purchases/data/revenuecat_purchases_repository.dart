import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/errors/failure.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/catalog.dart';
import '../domain/purchases_repository.dart';

/// Produits vendus. Le nombre de crédits est rappelé ici pour l'affichage ; le serveur
/// (webhook) a sa propre table et fait foi.
abstract final class StoreProducts {
  static const plans = {
    'flirtcoach_premium_weekly': PlanPeriod.weekly,
    'flirtcoach_premium_monthly': PlanPeriod.monthly,
    'flirtcoach_premium_annual': PlanPeriod.annual,
  };

  static const packs = {
    'flirtcoach_credits_20': 20,
    'flirtcoach_credits_50': 50,
    'flirtcoach_credits_100': 100,
  };

  /// Google Play nomme les abonnements « produit:formule ».
  static String baseId(String storeId) => storeId.split(':').first;
}

final purchasesRepositoryProvider = Provider<PurchasesRepository>(
  (ref) => RevenueCatPurchasesRepository(ref.watch(supabaseClientProvider)),
);

class RevenueCatPurchasesRepository implements PurchasesRepository {
  RevenueCatPurchasesRepository(this._supabase);

  final SupabaseClient _supabase;
  String? _configuredUserId;
  final _packages = <String, Package>{};

  String get _apiKey =>
      Platform.isIOS ? Env.revenueCatIosKey : Env.revenueCatAndroidKey;

  /// L'utilisateur RevenueCat est l'utilisateur Supabase : le webhook le retrouve ainsi.
  Future<void> _ensureConfigured() async {
    final userId = _supabase.auth.currentUser?.id;
    if (_apiKey.isEmpty || userId == null) {
      throw const PurchasesUnavailableFailure();
    }
    if (_configuredUserId == null) {
      await Purchases.configure(
        PurchasesConfiguration(_apiKey)..appUserID = userId,
      );
    } else if (_configuredUserId != userId) {
      await Purchases.logIn(userId);
    }
    _configuredUserId = userId;
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      await _ensureConfigured();
      return await action();
    } on Failure {
      rethrow;
    } on PlatformException catch (error) {
      throw switch (PurchasesErrorHelper.getErrorCode(error)) {
        PurchasesErrorCode.networkError => const NetworkFailure(),
        PurchasesErrorCode.configurationError ||
        PurchasesErrorCode.storeProblemError ||
        PurchasesErrorCode.purchaseNotAllowedError ||
        PurchasesErrorCode.productNotAvailableForPurchaseError =>
          const PurchasesUnavailableFailure(),
        _ => const PurchaseFailedFailure(),
      };
    }
  }

  @override
  Future<Catalog> fetchCatalog() => _guard(() async {
    final offering = (await Purchases.getOfferings()).current;
    if (offering == null) throw const PurchasesUnavailableFailure();

    final plans = <PremiumPlan>[];
    final packs = <CreditPack>[];
    _packages.clear();
    for (final package in offering.availablePackages) {
      final product = package.storeProduct;
      final id = StoreProducts.baseId(product.identifier);
      _packages[id] = package;
      if (StoreProducts.plans[id] case final period?) {
        plans.add(
          PremiumPlan(
            productId: id,
            period: period,
            priceLabel: product.priceString,
            introPriceLabel: product.introductoryPrice?.priceString,
          ),
        );
      } else if (StoreProducts.packs[id] case final credits?) {
        packs.add(
          CreditPack(
            productId: id,
            credits: credits,
            priceLabel: product.priceString,
          ),
        );
      }
    }
    plans.sort((a, b) => a.period.index.compareTo(b.period.index));
    packs.sort((a, b) => a.credits.compareTo(b.credits));
    return Catalog(plans: plans, packs: packs);
  });

  @override
  Future<bool> buy(String productId) => _guard(() async {
    final package = _packages[productId];
    if (package == null) throw const PurchasesUnavailableFailure();
    try {
      await Purchases.purchase(PurchaseParams.package(package));
      return true;
    } on PlatformException catch (error) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      if (code == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  });

  @override
  Future<bool> restore() => _guard(() async {
    final info = await Purchases.restorePurchases();
    return info.activeSubscriptions
        .map(StoreProducts.baseId)
        .any(StoreProducts.plans.containsKey);
  });
}
