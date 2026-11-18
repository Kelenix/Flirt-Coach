import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import '../../shared/widgets/gradient_background.dart';

/// Écran affiché à la place de l'app quand elle a été compilée sans sa
/// configuration : un message clair plutôt qu'un logo figé. Destiné aux
/// développeurs (un build publié contient toujours sa configuration).
class ConfigurationErrorApp extends StatelessWidget {
  const ConfigurationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Builder(
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          return Scaffold(
            body: GradientBackground(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Configuration manquante',
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "Cette version a été compilée sans l'adresse du serveur. "
                      'Recompile-la avec --dart-define-from-file=config/prod.json '
                      '(ou dev.json, phone.json) : voir le README.',
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
