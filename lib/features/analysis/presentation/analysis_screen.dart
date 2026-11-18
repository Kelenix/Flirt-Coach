import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../shared/widgets/copyable_text_card.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/premium_locked_notice.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/screenshot_preview.dart';
import '../../credits/application/wallet_controller.dart';
import '../../credits/presentation/credits_badge.dart';
import '../../generation/data/screenshot_picker.dart';
import '../application/analysis_controller.dart';
import '../domain/conversation_analysis.dart';

/// Analyse de conversation (INTAKE §2.4), réservée à Premium : où en est
/// l'échange, prochaine étape, rendez-vous si le contexte s'y prête.
class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  static const conversationFieldKey = ValueKey('analysis-conversation-field');
  static const contextFieldKey = ValueKey('analysis-context-field');

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  static const _conversationMinLines = 6;
  static const _contextMinLines = 2;
  // Limites de l'Edge Function `conversation-analysis`.
  static const _maxConversationLength = 4000;
  static const _maxContextLength = 1000;

  final _conversation = TextEditingController();
  final _context = TextEditingController();
  Uint8List? _screenshot;

  @override
  void initState() {
    super.initState();
    _conversation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _conversation.dispose();
    _context.dispose();
    super.dispose();
  }

  Future<void> _pickScreenshot() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await ref.read(screenshotPickerProvider)();
      if (bytes != null && mounted) setState(() => _screenshot = bytes);
    } catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failureMessage(l10n, error))));
    }
  }

  void _analyze() {
    FocusScope.of(context).unfocus();
    final contextText = _context.text.trim();
    ref
        .read(analysisControllerProvider.notifier)
        .analyze(
          conversation: _screenshot == null ? _conversation.text.trim() : null,
          screenshot: _screenshot,
          context: contextText.isEmpty ? null : contextText,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final fieldStyle = textTheme.bodyLarge?.copyWith(color: AppColors.onLight);
    final analysis = ref.watch(analysisControllerProvider);
    final wallet = ref.watch(walletProvider).valueOrNull;
    final isLocked = wallet != null && !wallet.isPremium;
    final canSubmit =
        _screenshot != null || _conversation.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuAnalysis),
        actions: const [
          Flexible(child: CreditsBadge()),
          SizedBox(width: AppSpacing.md),
        ],
      ),
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            Text(l10n.analysisIntro, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            if (isLocked)
              PremiumLockedNotice(body: l10n.analysisLockedBody)
            else ...[
              FieldLabel(l10n.analysisConversationLabel),
              if (_screenshot case final screenshot?)
                ScreenshotPreview(
                  bytes: screenshot,
                  info: l10n.analysisScreenshotInfo,
                  onRemove: () => setState(() => _screenshot = null),
                )
              else
                // Champ du kit : icône « image » en bas à droite pour importer une capture.
                Stack(
                  children: [
                    TextField(
                      key: AnalysisScreen.conversationFieldKey,
                      controller: _conversation,
                      minLines: _conversationMinLines,
                      maxLines: null,
                      maxLength: _maxConversationLength,
                      buildCounter: hiddenCounter,
                      textCapitalization: TextCapitalization.sentences,
                      style: fieldStyle,
                      decoration: InputDecoration(
                        hintText: l10n.analysisConversationHint,
                        contentPadding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.xl + AppSpacing.md,
                          AppSpacing.md,
                        ),
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.xs,
                      bottom: AppSpacing.xs,
                      child: IconButton(
                        onPressed: _pickScreenshot,
                        icon: const Icon(AppIcons.screenshot),
                        color: AppColors.onLight,
                        tooltip: l10n.importScreenshot,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              FieldLabel(l10n.contextLabel),
              TextField(
                key: AnalysisScreen.contextFieldKey,
                controller: _context,
                minLines: _contextMinLines,
                maxLines: null,
                maxLength: _maxContextLength,
                buildCounter: hiddenCounter,
                textCapitalization: TextCapitalization.sentences,
                style: fieldStyle,
                decoration: InputDecoration(hintText: l10n.analysisContextHint),
              ),
              if (analysis.valueOrNull case final AnalysisResult result)
                _ResultView(result),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.aiDisclaimer,
              style: textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
          bottom: [
            if (isLocked)
              PrimaryButton(
                label: l10n.upgradeButton,
                icon: AppIcons.premium,
                onPressed: () => context.push(AppRoutes.paywall),
              )
            else ...[
              FeedbackMessage(switch (analysis) {
                AsyncError(:final error) => failureMessage(l10n, error),
                AsyncData(value: AnalysisRefused(:final reason)) =>
                  reason.isEmpty ? l10n.analysisRefusedDefault : reason,
                _ => null,
              }),
              PrimaryButton(
                label: l10n.analysisButton,
                icon: AppIcons.analysis,
                isLoading: analysis.isLoading,
                onPressed: canSubmit ? _analyze : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView(this.result);

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final (icon, color, label) = switch (result.momentum) {
      Momentum.progressing => (
        AppIcons.circleCheck,
        AppColors.secondary,
        l10n.analysisMomentumProgressing,
      ),
      Momentum.stalling => (
        AppIcons.circle,
        AppColors.gold,
        l10n.analysisMomentumStalling,
      ),
      Momentum.declining => (
        AppIcons.alert,
        AppColors.primary,
        l10n.analysisMomentumDeclining,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          liveRegion: true,
          child: Row(
            children: [
              ExcludeSemantics(child: Icon(icon, color: color)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: textTheme.titleLarge)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(result.summary, style: textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.analysisNextStepTitle,
          style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(result.nextStep, style: textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        CopyableTextCard(
          title: l10n.analysisSuggestedMessageTitle,
          text: result.suggestedMessage,
        ),
        if (result.dateSuggestion case final date?)
          CopyableTextCard(title: l10n.analysisDateTitle, text: date),
      ],
    );
  }
}
