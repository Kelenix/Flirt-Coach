import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/copyable_text_card.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../credits/application/wallet_controller.dart';
import '../../report/presentation/report_sheet.dart';
import '../application/generation_controllers.dart';
import '../domain/generation_result.dart';

/// Les 3 propositions (kit « Résultats »), à copier ou à régénérer.
class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  /// Emojis des cartes, comme sur la maquette du kit.
  static const _emojis = ['😉', '💕', '🚀'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final generation = ref.watch(generationControllerProvider);
    final regenerationCost =
        ref.read(generationControllerProvider.notifier).lastRequest?.cost ?? 1;
    final isPremium = ref.watch(walletProvider).valueOrNull?.isPremium ?? false;
    // Pendant une régénération, on garde les propositions précédentes affichées.
    final (generationId, proposals) = switch (generation.valueOrNull) {
      GeneratedProposals(:final id, :final proposals) => (id, proposals),
      _ => (null, const <String>[]),
    };

    return Scaffold(
      appBar: AppBar(),
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            Text(
              l10n.resultsTitle,
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.resultsSubtitle,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.onDarkMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final (index, proposal) in proposals.indexed)
              CopyableTextCard(
                emoji: _emojis[index % _emojis.length],
                title: l10n.proposalLabel(index + 1),
                text: proposal,
                onReport: generationId == null
                    ? null
                    : () => reportProposal(
                        context,
                        ref,
                        generationId: generationId,
                        text: proposal,
                      ),
              ),
            Text(
              l10n.aiDisclaimer,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.onDarkMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          bottom: [
            FeedbackMessage(switch (generation) {
              AsyncError(:final error) => failureMessage(l10n, error),
              AsyncData(value: RefusedGeneration(:final reason)) =>
                reason.isEmpty ? l10n.refusedDefault : reason,
              _ => null,
            }),
            PrimaryButton(
              label: isPremium
                  ? l10n.regenerate
                  : l10n.regenerateWithCost(regenerationCost),
              icon: AppIcons.refresh,
              isLoading: generation.isLoading,
              onPressed: ref
                  .read(generationControllerProvider.notifier)
                  .regenerate,
            ),
          ],
        ),
      ),
    );
  }
}
