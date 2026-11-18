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
import '../../ads/presentation/ad_widgets.dart';
import '../../credits/application/wallet_controller.dart';
import '../../credits/presentation/credits_badge.dart';
import '../application/respect_controller.dart';
import '../domain/respect_check.dart';

/// Mode Respect (INTAKE §2.6) : vérifier un message avant de l'envoyer.
class RespectScreen extends ConsumerStatefulWidget {
  const RespectScreen({super.key});

  static const messageFieldKey = ValueKey('respect-message-field');
  static const contextFieldKey = ValueKey('respect-context-field');

  @override
  ConsumerState<RespectScreen> createState() => _RespectScreenState();
}

class _RespectScreenState extends ConsumerState<RespectScreen> {
  static const _messageMinLines = 4;
  static const _contextMinLines = 2;
  static const _maxMessageLength = 2000;
  static const _maxContextLength = 1000;
  static const _checkCost = 1;

  final _message = TextEditingController();
  final _context = TextEditingController();

  @override
  void initState() {
    super.initState();
    _message.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _message.dispose();
    _context.dispose();
    super.dispose();
  }

  void _check() {
    FocusScope.of(context).unfocus();
    final contextText = _context.text.trim();
    ref
        .read(respectControllerProvider.notifier)
        .check(
          message: _message.text.trim(),
          context: contextText.isEmpty ? null : contextText,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final fieldStyle = textTheme.bodyLarge?.copyWith(color: AppColors.onLight);
    final check = ref.watch(respectControllerProvider);
    final wallet = ref.watch(walletProvider).valueOrNull;
    final isOutOfCredits = wallet != null && !wallet.canAfford(_checkCost);
    final canSubmit = _message.text.trim().isNotEmpty && !isOutOfCredits;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.respectTitle),
        actions: const [
          Flexible(child: CreditsBadge()),
          SizedBox(width: AppSpacing.md),
        ],
      ),
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            Text(l10n.respectIntro, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            FieldLabel(l10n.respectMessageLabel),
            TextField(
              key: RespectScreen.messageFieldKey,
              controller: _message,
              minLines: _messageMinLines,
              maxLines: null,
              maxLength: _maxMessageLength,
              buildCounter: hiddenCounter,
              textCapitalization: TextCapitalization.sentences,
              style: fieldStyle,
              decoration: InputDecoration(hintText: l10n.respectMessageHint),
            ),
            const SizedBox(height: AppSpacing.md),
            FieldLabel(l10n.contextLabel),
            TextField(
              key: RespectScreen.contextFieldKey,
              controller: _context,
              minLines: _contextMinLines,
              maxLines: null,
              maxLength: _maxContextLength,
              buildCounter: hiddenCounter,
              textCapitalization: TextCapitalization.sentences,
              style: fieldStyle,
              decoration: InputDecoration(hintText: l10n.respectContextHint),
            ),
            if (check case AsyncData(value: final RespectVerdict verdict))
              _VerdictView(verdict),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.aiDisclaimer,
              style: textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
          bottom: [
            FeedbackMessage(switch (check) {
              _ when isOutOfCredits => l10n.errorInsufficientCredits,
              AsyncError(:final error) => failureMessage(l10n, error),
              AsyncData(value: RespectRefused(:final reason)) =>
                reason.isEmpty ? l10n.respectRefusedDefault : reason,
              _ => null,
            }),
            if (isOutOfCredits) const EarnCreditsActions(),
            // Sans crédit, les actions ci-dessus remplacent le bouton grisé.
            if (!isOutOfCredits)
              PrimaryButton(
                label: l10n.respectCheckButton,
                icon: AppIcons.respect,
                isLoading: check.isLoading,
                onPressed: canSubmit ? _check : null,
              ),
            const AdBannerSlot(),
          ],
        ),
      ),
    );
  }
}

class _VerdictView extends StatelessWidget {
  const _VerdictView(this.verdict);

  final RespectVerdict verdict;

  String _categoryLabel(AppLocalizations l10n, RespectIssueCategory category) =>
      switch (category) {
        RespectIssueCategory.insistent => l10n.respectIssueInsistent,
        RespectIssueCategory.sexualized => l10n.respectIssueSexualized,
        RespectIssueCategory.manipulative => l10n.respectIssueManipulative,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (verdict.isRespectful) {
      return _VerdictHeader(
        icon: AppIcons.respect,
        color: AppColors.secondary,
        text: l10n.respectVerdictOk,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VerdictHeader(
          icon: AppIcons.alert,
          color: AppColors.primary,
          text: l10n.respectVerdictReview,
        ),
        for (final issue in verdict.issues)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _categoryLabel(l10n, issue.category),
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(issue.explanation, style: textTheme.bodyMedium),
              ],
            ),
          ),
        if (verdict.alternative case final alternative?)
          CopyableTextCard(
            title: l10n.respectAlternativeTitle,
            text: alternative,
          ),
      ],
    );
  }
}

class _VerdictHeader extends StatelessWidget {
  const _VerdictHeader({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Semantics(
        liveRegion: true,
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(icon, color: color)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}
