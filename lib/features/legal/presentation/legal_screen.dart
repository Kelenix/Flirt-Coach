import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/app_routes.dart';
import '../../../shared/widgets/gradient_background.dart';

/// Textes embarqués : documents légaux (US-06), consultables avant et après
/// l'accueil 18+, et aide de l'app (questions fréquentes). Un fichier par
/// langue de l'interface : `<base>_<code langue>.txt`.
enum LegalDocument {
  privacy('assets/legal/privacy', AppRoutes.privacy),
  terms('assets/legal/terms', AppRoutes.terms),
  help('assets/help/faq', AppRoutes.help);

  const LegalDocument(this._basePath, this.route);

  final String _basePath;
  final String route;

  /// Fichier du document dans la langue [languageCode] (« fr », « en »).
  String asset(String languageCode) => '${_basePath}_$languageCode.txt';

  String title(AppLocalizations l10n) => switch (this) {
    LegalDocument.privacy => l10n.legalPrivacy,
    LegalDocument.terms => l10n.legalTerms,
    LegalDocument.help => l10n.helpFaq,
  };
}

/// Texte légal : `# ` titre, `## ` section, `- ` puce, sinon paragraphe.
class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key, required this.document});

  final LegalDocument document;

  /// Éditeur et contact viennent de la configuration (`config/<env>.json`).
  static String fill(String text, AppLocalizations l10n) => text
      .replaceAll(
        '{{EDITEUR}}',
        Env.legalPublisher.isEmpty ? l10n.legalMissing : Env.legalPublisher,
      )
      .replaceAll(
        '{{CONTACT}}',
        Env.supportEmail.isEmpty ? l10n.legalMissing : Env.supportEmail,
      );

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  // Chargé une fois par langue, pas à chaque reconstruction de l'écran.
  late Future<String> _text;
  String? _languageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == _languageCode) return;
    _languageCode = languageCode;
    _text = rootBundle.loadString(widget.document.asset(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.document.title(l10n))),
      body: GradientBackground(
        child: FutureBuilder(
          future: _text,
          builder: (context, snapshot) => switch (snapshot) {
            AsyncSnapshot(hasError: true) => Center(
              child: Text(l10n.errorUnexpected, textAlign: TextAlign.center),
            ),
            AsyncSnapshot(:final data?) => ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final block in LegalScreen.fill(
                  data,
                  l10n,
                ).split(RegExp(r'\n\s*\n')))
                  if (block.trim().isNotEmpty) _LegalBlock(block.trim()),
              ],
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _LegalBlock extends StatelessWidget {
  const _LegalBlock(this.block);

  final String block;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (block.startsWith('# ')) {
      // Le titre est déjà dans la barre d'application.
      return const SizedBox.shrink();
    }
    if (block.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.sm,
        ),
        child: Text(
          block.substring(3),
          style: textTheme.titleMedium?.copyWith(color: AppColors.primary),
        ),
      );
    }
    final lines = block.split('\n');
    if (lines.every((line) => line.startsWith('- '))) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  '•  ${line.substring(2)}',
                  style: textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(block, style: textTheme.bodyMedium),
    );
  }
}

/// Liens « Confidentialité · Conditions » (accueil 18+, paywall, réglages).
class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.onDarkMuted,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.onDarkMuted,
    );
    Widget link(String label, String route) => TextButton(
      onPressed: () => context.push(route),
      child: Text(label, style: style),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        link(l10n.legalPrivacyShort, AppRoutes.privacy),
        Text('·', style: style?.copyWith(decoration: TextDecoration.none)),
        link(l10n.legalTermsShort, AppRoutes.terms),
      ],
    );
  }
}
