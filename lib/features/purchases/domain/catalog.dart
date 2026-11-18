import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog.freezed.dart';

enum PlanPeriod { weekly, monthly, annual }

/// Abonnement Premium tel que vendu par le store (prix localisé par le store).
@freezed
abstract class PremiumPlan with _$PremiumPlan {
  const factory PremiumPlan({
    required String productId,
    required PlanPeriod period,
    required String priceLabel,

    /// Prix de lancement ou promotionnel configuré dans le store, s'il existe.
    String? introPriceLabel,
  }) = _PremiumPlan;
}

@freezed
abstract class CreditPack with _$CreditPack {
  const factory CreditPack({
    required String productId,
    required int credits,
    required String priceLabel,
  }) = _CreditPack;
}

@freezed
abstract class Catalog with _$Catalog {
  const factory Catalog({
    required List<PremiumPlan> plans,
    required List<CreditPack> packs,
  }) = _Catalog;
}
