import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/credits/application/wallet_controller.dart';
import 'features/onboarding/application/onboarding_controller.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';

class FlirtCoachApp extends ConsumerStatefulWidget {
  const FlirtCoachApp({super.key});

  @override
  ConsumerState<FlirtCoachApp> createState() => _FlirtCoachAppState();
}

class _FlirtCoachAppState extends ConsumerState<FlirtCoachApp> {
  /// Retour dans l'app : le portefeuille est relu (crédits du jour remis à neuf
  /// pendant la nuit, achat validé entre-temps).
  late final _lifecycle = AppLifecycleListener(
    onResume: () {
      if (ref.read(accessGateProvider)) ref.invalidate(walletProvider);
    },
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
