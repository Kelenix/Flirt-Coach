import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/copyable_text_card.dart';
import '../../../shared/widgets/form_widgets.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../application/message_bank_provider.dart';
import '../domain/bank_message.dart';

/// Banque de messages (INTAKE §2.5) : un onglet par catégorie, copie en un geste.
/// Gratuite et sans crédit ; consultable hors-ligne après un premier chargement.
class MessageBankScreen extends ConsumerWidget {
  const MessageBankScreen({super.key});

  static String categoryLabel(AppLocalizations l10n, BankCategory category) =>
      switch (category) {
        BankCategory.opener => l10n.bankCategoryOpener,
        BankCategory.followUp => l10n.bankCategoryFollowUp,
        BankCategory.date => l10n.bankCategoryDate,
        BankCategory.apology => l10n.bankCategoryApology,
        BankCategory.softBreakup => l10n.bankCategorySoftBreakup,
      };

  static String _emoji(BankCategory category) => switch (category) {
    BankCategory.opener => '👋',
    BankCategory.followUp => '💬',
    BankCategory.date => '☕',
    BankCategory.apology => '🙏',
    BankCategory.softBreakup => '🕊️',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final bankOfLanguage = messageBankProvider(
      Localizations.localeOf(context).languageCode,
    );
    final bank = ref.watch(bankOfLanguage);

    return DefaultTabController(
      length: BankCategory.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.bankTitle),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.onDark,
            unselectedLabelColor: AppColors.onDarkMuted,
            labelStyle: textTheme.labelLarge,
            dividerColor: Colors.transparent,
            tabs: [
              for (final category in BankCategory.values)
                Tab(text: categoryLabel(l10n, category)),
            ],
          ),
        ),
        body: GradientBackground(
          child: switch (bank) {
            AsyncData(:final value) => TabBarView(
              children: [
                for (final category in BankCategory.values)
                  ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      Text(l10n.bankIntro, style: textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.md),
                      for (final (index, body)
                          in (value[category] ?? const <String>[]).indexed)
                        CopyableTextCard(
                          emoji: _emoji(category),
                          title: l10n.bankMessageLabel(index + 1),
                          text: body,
                        ),
                    ],
                  ),
              ],
            ),
            AsyncError(:final error) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedbackMessage(failureMessage(l10n, error)),
                  SecondaryButton(
                    label: l10n.retry,
                    icon: AppIcons.refresh,
                    onPressed: () => ref.invalidate(bankOfLanguage),
                  ),
                ],
              ),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}
