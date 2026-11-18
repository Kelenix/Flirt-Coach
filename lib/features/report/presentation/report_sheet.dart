import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../data/report_repository.dart';

/// Demande un motif puis envoie le signalement de [text] (US-07) ; confirme ou
/// affiche l'erreur dans une barre en bas d'écran.
Future<void> reportProposal(
  BuildContext context,
  WidgetRef ref, {
  required String generationId,
  required String text,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final reason = await showModalBottomSheet<ReportReason>(
    context: context,
    backgroundColor: AppColors.panel,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              l10n.reportTitle,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
          ),
          for (final reason in ReportReason.values)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              title: Text(_reasonLabel(l10n, reason)),
              onTap: () => Navigator.of(sheetContext).pop(reason),
            ),
        ],
      ),
    ),
  );
  if (reason == null) return;
  String message;
  try {
    await ref
        .read(reportRepositoryProvider)
        .report(generationId: generationId, text: text, reason: reason);
    message = l10n.reportSent;
  } catch (error) {
    message = failureMessage(l10n, error);
  }
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _reasonLabel(AppLocalizations l10n, ReportReason reason) =>
    switch (reason) {
      ReportReason.offensive => l10n.reportReasonOffensive,
      ReportReason.sexual => l10n.reportReasonSexual,
      ReportReason.harassment => l10n.reportReasonHarassment,
      ReportReason.manipulative => l10n.reportReasonManipulative,
      ReportReason.other => l10n.reportReasonOther,
    };
