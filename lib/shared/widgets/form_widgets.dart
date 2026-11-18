import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Intitulé d'un champ, au-dessus de celui-ci (lisible sur le fond sombre).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

/// Compteur de caractères masqué : la limite reste appliquée, sans afficher
/// « 0/2000 » (absent des écrans du kit).
Widget? hiddenCounter(
  BuildContext context, {
  required int currentLength,
  required int? maxLength,
  required bool isFocused,
}) => null;

/// Message d'erreur ou d'information, annoncé aux lecteurs d'écran.
class FeedbackMessage extends StatelessWidget {
  const FeedbackMessage(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        liveRegion: true,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Écran à contenu défilant et action principale toujours visible en bas.
class ScrollWithBottomAction extends StatelessWidget {
  const ScrollWithBottomAction({
    super.key,
    required this.content,
    required this.bottom,
  });

  final List<Widget> content;
  final List<Widget> bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: content,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: bottom),
        ),
      ],
    );
  }
}
