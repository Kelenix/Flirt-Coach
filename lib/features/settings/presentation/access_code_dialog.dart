import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Saisie du code d'accès Premium (ADR-031). Renvoie le code, ou `null` si annulé.
Future<String?> showAccessCodeDialog(BuildContext context) =>
    showDialog<String>(
      context: context,
      builder: (_) => const _AccessCodeDialog(),
    );

class _AccessCodeDialog extends StatefulWidget {
  const _AccessCodeDialog();

  @override
  State<_AccessCodeDialog> createState() => _AccessCodeDialogState();
}

class _AccessCodeDialogState extends State<_AccessCodeDialog> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _code.text.trim();
    if (code.isNotEmpty) Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.accessCodeTitle),
      content: TextField(
        controller: _code,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(hintText: l10n.accessCodeHint),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.accessCodeConfirm)),
      ],
    );
  }
}
