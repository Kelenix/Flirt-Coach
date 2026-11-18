import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/env.dart';
import '../../../core/errors/failure.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../ads/data/ads_service.dart';
import '../../credits/application/wallet_controller.dart';
import '../application/account_controller.dart';

/// Le lien « Préférences publicitaires » n'existe que si le consentement s'applique.
final adPrivacyOptionsProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(adsServiceProvider).privacyOptionsRequired(),
);

/// Réglages (INTAKE §7) : abonnement, confidentialité, aide, suppression du compte.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Page de gestion des abonnements du store (résiliation, changement d'offre).
  static final _subscriptionsUrl = Uri.parse(
    Platform.isIOS
        ? 'https://apps.apple.com/account/subscriptions'
        : 'https://play.google.com/store/account/subscriptions',
  );

  Future<void> _open(BuildContext context, Uri uri) async {
    final message = AppLocalizations.of(context).errorLinkUnavailable;
    final messenger = ScaffoldMessenger.of(context);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _confirmDeletion(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.deleteAccountConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(accountControllerProvider.notifier).deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isPremium = ref.watch(walletProvider).valueOrNull?.isPremium ?? false;
    final hasAdChoices =
        ref.watch(adPrivacyOptionsProvider).valueOrNull ?? false;
    final deletion = ref.watch(accountControllerProvider);

    ref.listen(accountControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failureMessage(l10n, error))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          children: [
            _Section(l10n.settingsSectionSubscription),
            _Item(
              icon: AppIcons.premium,
              label: l10n.settingsPremium,
              onTap: () => context.push(AppRoutes.paywall),
            ),
            if (isPremium)
              _Item(
                icon: AppIcons.external,
                label: l10n.settingsManageSubscription,
                onTap: () => _open(context, _subscriptionsUrl),
              ),
            _Section(l10n.settingsSectionPrivacy),
            _Item(
              icon: AppIcons.respect,
              label: l10n.legalPrivacy,
              onTap: () => context.push(AppRoutes.privacy),
            ),
            _Item(
              icon: AppIcons.messageBank,
              label: l10n.legalTerms,
              onTap: () => context.push(AppRoutes.terms),
            ),
            if (hasAdChoices)
              _Item(
                icon: AppIcons.settings,
                label: l10n.settingsAdPreferences,
                onTap: ref.read(adsServiceProvider).showPrivacyOptions,
              ),
            if (Env.supportEmail.isNotEmpty) ...[
              _Section(l10n.settingsSectionHelp),
              _Item(
                icon: AppIcons.generate,
                label: l10n.settingsContact,
                onTap: () => _open(
                  context,
                  Uri(
                    scheme: 'mailto',
                    path: Env.supportEmail,
                    query: 'subject=Flirt%20Coach',
                  ),
                ),
              ),
            ],
            _Section(l10n.settingsSectionAccount),
            _Item(
              icon: AppIcons.delete,
              label: l10n.settingsDeleteAccount,
              color: AppColors.error,
              isLoading: deletion.isLoading,
              onTap: deletion.isLoading
                  ? null
                  : () => _confirmDeletion(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.onDark,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(AppIcons.chevronRight, color: AppColors.onDarkMuted),
      onTap: onTap,
    );
  }
}
