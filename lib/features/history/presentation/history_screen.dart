import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/premium_locked_notice.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../credits/application/wallet_controller.dart';
import '../../generation/domain/situation.dart';
import '../../generation/presentation/labels.dart';
import '../application/history_controller.dart';
import '../domain/history_entry.dart';
import '../../../shared/widgets/snack.dart';

/// Historique Premium (INTAKE §2.7) : générations passées, texte seulement,
/// suppression individuelle. Verrouillé pour les utilisateurs gratuits.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final walletState = ref.watch(walletProvider);
    final wallet = walletState.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: GradientBackground(
        child: switch (wallet) {
          // Portefeuille illisible (hors-ligne) : message et « Réessayer ».
          null when walletState.hasError => _RetryView(
            error: walletState.error!,
            onRetry: () => ref.invalidate(walletProvider),
          ),
          null => const Center(child: CircularProgressIndicator()),
          _ when !wallet.isPremium => ScrollWithBottomAction(
            content: [PremiumLockedNotice(body: l10n.historyLockedBody)],
            bottom: [
              PrimaryButton(
                label: l10n.upgradeButton,
                icon: AppIcons.premium,
                onPressed: () => context.push(AppRoutes.paywall),
              ),
            ],
          ),
          _ => const _HistoryList(),
        },
      ),
    );
  }
}

class _HistoryList extends ConsumerStatefulWidget {
  const _HistoryList();

  @override
  ConsumerState<_HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<_HistoryList> {
  bool _isLoadingMore = false;

  void _showError(Object error) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showMessage(failureMessage(l10n, error));
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    try {
      await ref.read(historyControllerProvider.notifier).loadMore();
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _delete(HistoryEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.historyDeleteTitle),
        content: Text(l10n.historyDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.historyDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(historyControllerProvider.notifier).delete(entry.id);
      messenger.showMessage(l10n.historyDeleted);
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyControllerProvider);

    return switch (history) {
      AsyncData(:final value) when value.entries.isEmpty => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            l10n.historyEmpty,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      AsyncData(:final value) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: value.entries.length + (value.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == value.entries.length) {
            return _isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : SecondaryButton(
                    label: l10n.historyShowMore,
                    onPressed: _loadMore,
                  );
          }
          final entry = value.entries[index];
          return _HistoryCard(entry, onDelete: () => _delete(entry));
        },
      ),
      AsyncError(:final error) => _RetryView(
        error: error,
        onRetry: () => ref.invalidate(historyControllerProvider),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

/// Erreur de chargement avec « Réessayer ».
class _RetryView extends StatelessWidget {
  const _RetryView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedbackMessage(failureMessage(l10n, error)),
          SecondaryButton(
            label: l10n.retry,
            icon: AppIcons.refresh,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Carte claire : type et date, message saisi, réponses copiables.
class _HistoryCard extends StatelessWidget {
  const _HistoryCard(this.entry, {required this.onDelete});

  final HistoryEntry entry;
  final VoidCallback onDelete;

  static String kindLabel(AppLocalizations l10n, String kind) => switch (kind) {
    'screenshot' => l10n.menuScreenshot,
    'respect_check' => l10n.respectTitle,
    'conversation_analysis' => l10n.menuAnalysis,
    _ =>
      [
            for (final situation in Situation.values)
              if (situation.apiName == kind) situation.label(l10n),
          ].firstOrNull ??
          kind,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final date = DateFormat.yMMMd(
      l10n.localeName,
    ).add_Hm().format(entry.createdAt);
    final input = entry.input;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kindLabel(l10n, entry.kind),
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.onLight,
                      ),
                    ),
                    Text(
                      date,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.onLightMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(AppIcons.delete, size: 20),
                color: AppColors.onLightMuted,
                tooltip: l10n.historyDelete,
              ),
            ],
          ),
          if (input != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                l10n.historyInput(input),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onLightMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          for (final result in entry.results) _ResultLine(result),
        ],
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine(this.text);

  final String text;

  Future<void> _copy(BuildContext context) async {
    final message = AppLocalizations.of(context).copied;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.onLight),
            ),
          ),
          IconButton(
            onPressed: () => _copy(context),
            icon: const Icon(AppIcons.copy, size: 20),
            color: AppColors.onLight,
            tooltip: AppLocalizations.of(context).copy,
          ),
        ],
      ),
    );
  }
}
