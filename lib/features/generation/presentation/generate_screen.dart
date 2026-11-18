import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../core/theme/app_icons.dart';
import '../../menu/presentation/feature_menu.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/screenshot_preview.dart';
import '../../purchases/application/annual_offer.dart';
import '../../ads/presentation/ad_widgets.dart';
import '../../credits/application/wallet_controller.dart';
import '../../credits/domain/wallet.dart';
import '../application/generation_controllers.dart';
import '../data/screenshot_picker.dart';
import '../domain/generation_request.dart';
import '../domain/generation_result.dart';
import '../domain/message_style.dart';
import '../domain/situation.dart';
import 'labels.dart';
import '../../credits/presentation/credits_badge.dart';
import 'widgets/style_selector.dart';

/// Écran principal (INTAKE §4) : une situation, un message ou un contexte → 3 propositions.
class GenerateScreen extends ConsumerStatefulWidget {
  const GenerateScreen({super.key});

  static const messageFieldKey = ValueKey('message-field');
  static const contextFieldKey = ValueKey('context-field');

  @override
  ConsumerState<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends ConsumerState<GenerateScreen> {
  static const _messageMinLines = 4;
  static const _contextMinLines = 2;
  static const _maxMessageLength = 2000;
  static const _maxContextLength = 1000;

  final _message = TextEditingController();
  final _context = TextEditingController();
  Situation _situation = Situation.reply;
  MessageStyle _style = MessageStyle.classic;
  Uint8List? _screenshot;

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

  /// La capture remplace le message reçu, seulement pour « Répondre ».
  bool get _usesScreenshot => _situation.requiresMessage && _screenshot != null;

  bool get _hasRequiredInput =>
      !_situation.requiresMessage ||
      _usesScreenshot ||
      _message.text.trim().isNotEmpty;

  GenerationRequest _buildRequest() {
    final contextText = _context.text.trim();
    return GenerationRequest(
      situation: _situation,
      style: _style,
      message: _situation.requiresMessage && !_usesScreenshot
          ? _message.text.trim()
          : null,
      context: contextText.isEmpty ? null : contextText,
      screenshot: _usesScreenshot ? _screenshot : null,
    );
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    final hasProposals = await ref
        .read(generationControllerProvider.notifier)
        .generate(_buildRequest());
    if (hasProposals && mounted) context.push(AppRoutes.results);
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

  void _openPaywall() => context.push(AppRoutes.paywall);

  /// Offre annuelle J+3 : présentée une fois, dès que le portefeuille est connu.
  void _maybeShowAnnualOffer(
    AsyncValue<Wallet>? previous,
    AsyncValue<Wallet> next,
  ) {
    final wallet = next.valueOrNull;
    if (wallet == null || previous?.valueOrNull != null) return;
    final offer = ref.read(annualOfferProvider);
    if (!offer.shouldShow(wallet)) return;
    offer.markShown();
    context.push(AppRoutes.annualOffer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final fieldStyle = textTheme.bodyLarge?.copyWith(color: AppColors.onLight);
    final generation = ref.watch(generationControllerProvider);
    final wallet = ref.watch(walletProvider).valueOrNull;
    ref.listen(walletProvider, _maybeShowAnnualOffer);
    final isOutOfCredits =
        wallet != null && !wallet.canAfford(_buildRequest().cost);
    final canSubmit = _hasRequiredInput && !isOutOfCredits;
    final needsPremium = generation.error is PremiumRequiredFailure;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              showFeatureMenu(context, onScreenshot: _pickScreenshot),
          icon: const Icon(AppIcons.menu),
          tooltip: l10n.menuTitle,
        ),
        actions: const [
          Flexible(child: CreditsBadge()),
          SizedBox(width: AppSpacing.md),
        ],
      ),
      body: GradientBackground(
        child: ScrollWithBottomAction(
          content: [
            Text(
              l10n.generateTitle,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FieldLabel(l10n.situationLabel),
            DropdownMenu<Situation>(
              initialSelection: _situation,
              expandedInsets: EdgeInsets.zero,
              textStyle: fieldStyle,
              trailingIcon: const Icon(
                AppIcons.chevronDown,
                color: AppColors.onLight,
              ),
              selectedTrailingIcon: const Icon(
                AppIcons.chevronUp,
                color: AppColors.onLight,
              ),
              onSelected: (situation) {
                if (situation != null) {
                  setState(() => _situation = situation);
                }
              },
              dropdownMenuEntries: [
                for (final situation in Situation.values)
                  DropdownMenuEntry(
                    value: situation,
                    label: situation.label(l10n),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_usesScreenshot)
              ScreenshotPreview(
                bytes: _screenshot!,
                info: l10n.screenshotInfo,
                onRemove: () => setState(() => _screenshot = null),
              )
            else if (_situation.requiresMessage)
              // Champ du kit : icône « image » en bas à droite pour importer une capture.
              Stack(
                children: [
                  TextField(
                    key: GenerateScreen.messageFieldKey,
                    controller: _message,
                    minLines: _messageMinLines,
                    maxLines: null,
                    maxLength: _maxMessageLength,
                    buildCounter: hiddenCounter,
                    textCapitalization: TextCapitalization.sentences,
                    style: fieldStyle,
                    decoration: InputDecoration(
                      hintText: l10n.messageHint,
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
              key: GenerateScreen.contextFieldKey,
              controller: _context,
              minLines: _contextMinLines,
              maxLines: null,
              maxLength: _maxContextLength,
              buildCounter: hiddenCounter,
              textCapitalization: TextCapitalization.sentences,
              style: fieldStyle,
              decoration: InputDecoration(
                hintText: _situation.contextHint(l10n),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FieldLabel(l10n.chooseStyle),
            StyleSelector(
              selected: _style,
              isPremium: wallet?.isPremium ?? false,
              onSelected: (style) => setState(() => _style = style),
              onLockedTap: _openPaywall,
            ),
            const SizedBox(height: AppSpacing.lg),
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
              _ when isOutOfCredits => l10n.errorInsufficientCredits,
              AsyncError(:final error) => failureMessage(l10n, error),
              AsyncData(value: RefusedGeneration(:final reason)) =>
                reason.isEmpty ? l10n.refusedDefault : reason,
              _ => null,
            }),
            if (isOutOfCredits || needsPremium)
              EarnCreditsActions(offerRewardedVideo: isOutOfCredits),
            // Sans crédit, les actions ci-dessus remplacent le bouton grisé.
            if (!isOutOfCredits)
              PrimaryButton(
                label: l10n.generateButton,
                icon: AppIcons.sparkles,
                isLoading: generation.isLoading,
                onPressed: canSubmit ? _generate : null,
              ),
            const AdBannerSlot(),
          ],
        ),
      ),
    );
  }
}
