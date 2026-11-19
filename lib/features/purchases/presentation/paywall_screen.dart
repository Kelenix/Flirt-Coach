import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/brand_check.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../credits/application/wallet_controller.dart';
import '../application/purchase_controller.dart';
import '../domain/catalog.dart';
import '../../legal/presentation/legal_screen.dart';
import '../../../shared/widgets/snack.dart';

/// Paywall (INTAKE §3.1, §4) : abonnements Premium et packs de crédits.
/// [annualOffer] : variante proposée à J+3, annuel mis en avant.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.annualOffer = false});

  final bool annualOffer;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  static const _logoSize = 64.0;

  late PlanPeriod _selected = widget.annualOffer
      ? PlanPeriod.annual
      : PlanPeriod.weekly;

  String _outcomeMessage(AppLocalizations l10n, PurchaseOutcome outcome) =>
      switch (outcome) {
        PurchaseOutcome.premiumActivated => l10n.purchasePremiumActivated,
        PurchaseOutcome.creditsAdded => l10n.purchaseCreditsAdded,
        PurchaseOutcome.pending => l10n.purchasePending,
        PurchaseOutcome.restored => l10n.purchaseRestored,
        PurchaseOutcome.restorePending => l10n.purchaseRestorePending,
        PurchaseOutcome.nothingToRestore => l10n.purchaseNothingToRestore,
      };

  void _onOutcome(AsyncValue<PurchaseOutcome?>? previous, AsyncValue next) {
    // Seulement à la fin d'un achat : deux achats identiques sont confirmés deux fois.
    if (previous?.isLoading != true || next is! AsyncData) return;
    final outcome = next.value;
    if (outcome is! PurchaseOutcome) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showMessage(_outcomeMessage(l10n, outcome));
    if (outcome == PurchaseOutcome.premiumActivated ||
        outcome == PurchaseOutcome.restored) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final catalog = ref.watch(catalogProvider);
    final purchase = ref.watch(purchaseControllerProvider);
    final isPremium = ref.watch(walletProvider).valueOrNull?.isPremium ?? false;
    final controller = ref.read(purchaseControllerProvider.notifier);
    ref.listen(purchaseControllerProvider, _onOutcome);

    final plans = catalog.valueOrNull?.plans ?? const <PremiumPlan>[];
    final selectedPlan = plans.where((plan) => plan.period == _selected);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitle)),
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            const Center(child: BrandLogo(size: _logoSize)),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.annualOffer
                  ? l10n.annualOfferHeadline
                  : l10n.paywallHeadline,
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final benefit in [
              l10n.paywallBenefitMessages,
              l10n.paywallBenefitStyles,
              l10n.paywallBenefitScreenshot,
              l10n.paywallBenefitAnalysis,
              l10n.paywallBenefitNoAds,
            ])
              BrandCheckItem(benefit),
            const SizedBox(height: AppSpacing.lg),
            if (isPremium)
              Text(
                l10n.paywallAlreadyPremium,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              )
            else
              ...switch (catalog) {
                AsyncData(:final value) => [
                  for (final plan in value.plans)
                    _PlanTile(
                      plan: plan,
                      isSelected: plan.period == _selected,
                      isAnnualOffer: widget.annualOffer,
                      onTap: () => setState(() => _selected = plan.period),
                    ),
                  Text(
                    l10n.paywallRenewalNotice,
                    style: textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (value.packs.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(l10n.paywallPacksTitle, style: textTheme.titleLarge),
                    Text(
                      l10n.paywallPacksSubtitle,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final pack in value.packs)
                      _PackTile(
                        pack: pack,
                        onTap: purchase.isLoading
                            ? null
                            : () => controller.buy(pack.productId),
                      ),
                  ],
                ],
                AsyncError(:final error) => [
                  FeedbackMessage(failureMessage(l10n, error)),
                ],
                _ => [const Center(child: CircularProgressIndicator())],
              },
            Center(
              child: TextButton(
                onPressed: purchase.isLoading ? null : controller.restore,
                child: Text(l10n.paywallRestore),
              ),
            ),
            const LegalLinks(),
          ],
          bottom: [
            if (purchase case AsyncError(:final error))
              FeedbackMessage(failureMessage(l10n, error)),
            if (!isPremium && selectedPlan.isNotEmpty)
              PrimaryButton(
                label: l10n.paywallContinue,
                icon: AppIcons.premium,
                isLoading: purchase.isLoading,
                onPressed: () => controller.buy(selectedPlan.first.productId),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.isSelected,
    required this.isAnnualOffer,
    required this.onTap,
  });

  final PremiumPlan plan;
  final bool isSelected;
  final bool isAnnualOffer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final (name, price) = switch (plan.period) {
      PlanPeriod.weekly => (l10n.planWeekly, l10n.planPerWeek(plan.priceLabel)),
      PlanPeriod.monthly => (
        l10n.planMonthly,
        l10n.planPerMonth(plan.priceLabel),
      ),
      PlanPeriod.annual => (l10n.planAnnual, l10n.planPerYear(plan.priceLabel)),
    };
    final badge = switch (plan.period) {
      PlanPeriod.weekly when !isAnnualOffer => l10n.planBadgePopular,
      PlanPeriod.annual when isAnnualOffer => l10n.planBadgeSpecialOffer,
      PlanPeriod.annual => l10n.planBadgeBestValue,
      _ => null,
    };
    final intro = plan.introPriceLabel;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        selected: isSelected,
        button: true,
        child: Material(
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.card,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    isSelected ? AppIcons.circleCheck : AppIcons.circle,
                    color: isSelected ? AppColors.primary : AppColors.onDark,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (badge != null)
                          Text(
                            badge,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        Text(name, style: textTheme.labelLarge),
                        Text(price, style: textTheme.bodyMedium),
                        if (intro != null)
                          Text(
                            l10n.planIntroPrice(intro),
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.surfaceTint,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PackTile extends StatelessWidget {
  const _PackTile({required this.pack, required this.onTap});

  final CreditPack pack;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          leading: const Icon(AppIcons.coins, color: AppColors.gold),
          title: Text(
            l10n.creditPackLabel(pack.credits),
            style: textTheme.labelLarge,
          ),
          trailing: Text(pack.priceLabel, style: textTheme.bodyLarge),
        ),
      ),
    );
  }
}
