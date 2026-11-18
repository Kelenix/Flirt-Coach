import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/brand_check.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/brand_wave.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../legal/presentation/legal_screen.dart';
import '../application/onboarding_controller.dart';

/// Premier écran (kit de marque) : logo, promesse, confirmation d'âge (18+) et
/// avertissement IA.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  static const _logoSize = 128.0;
  static const _wordmarkWidth = 260.0;
  static const _subtitleWidth = 180.0;

  bool _isAdult = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final onboarding = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            const SizedBox(height: AppSpacing.md),
            const Center(child: BrandLogo(size: _logoSize)),
            const SizedBox(height: AppSpacing.sm),
            const Center(child: BrandWordmark(width: _wordmarkWidth)),
            const SizedBox(height: AppSpacing.md),
            // Sous-titre sur deux lignes, comme sur le kit.
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _subtitleWidth),
                child: Text(
                  l10n.appSubtitle,
                  style: textTheme.titleLarge?.copyWith(
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const BrandWave(),
            BrandCheckItem(l10n.welcomeBenefitWords),
            BrandCheckItem(l10n.welcomeBenefitRespect),
            BrandCheckItem(l10n.welcomeBenefitConfidence),
            const SizedBox(height: AppSpacing.lg),
            _AgeConfirmation(
              isChecked: _isAdult,
              onChanged: onboarding.isLoading
                  ? null
                  : () => setState(() => _isAdult = !_isAdult),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.aiDisclaimer,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.onDarkMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const LegalLinks(),
          ],
          bottom: [
            if (onboarding.hasError)
              FeedbackMessage(failureMessage(l10n, onboarding.error!)),
            PrimaryButton(
              label: l10n.start,
              isLoading: onboarding.isLoading,
              onPressed: _isAdult
                  ? ref.read(onboardingControllerProvider.notifier).start
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Case « J'ai 18 ans ou plus », au style des coches du kit.
class _AgeConfirmation extends StatelessWidget {
  const _AgeConfirmation({required this.isChecked, required this.onChanged});

  final bool isChecked;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).ageConfirmation;
    return Semantics(
      checked: isChecked,
      enabled: onChanged != null,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isChecked ? AppColors.primary : AppColors.glass,
            ),
          ),
          child: Row(
            children: [
              BrandCheckBox(isChecked: isChecked),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
