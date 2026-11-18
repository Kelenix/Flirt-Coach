import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analysis/presentation/analysis_screen.dart';
import '../features/generation/presentation/generate_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/legal/presentation/legal_screen.dart';
import '../features/message_bank/presentation/message_bank_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/generation/presentation/results_screen.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/presentation/welcome_screen.dart';
import '../features/purchases/presentation/paywall_screen.dart';
import '../features/respect/presentation/respect_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final accessChanges = ValueNotifier(ref.read(accessGateProvider));
  ref.listen(accessGateProvider, (_, isOpen) => accessChanges.value = isOpen);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: accessChanges,
    // Garde unique : sans confirmation d'âge ni session, seuls /welcome et les pages
    // légales sont accessibles.
    redirect: (context, state) {
      final isOpen = ref.read(accessGateProvider);
      final isAtWelcome = state.matchedLocation == AppRoutes.welcome;
      if (AppRoutes.public.contains(state.matchedLocation)) return null;
      if (!isOpen && !isAtWelcome) return AppRoutes.welcome;
      if (isOpen && isAtWelcome) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const GenerateScreen(),
      ),
      GoRoute(
        path: AppRoutes.results,
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: AppRoutes.respect,
        builder: (context, state) => const RespectScreen(),
      ),
      GoRoute(
        path: AppRoutes.analysis,
        builder: (context, state) => const AnalysisScreen(),
      ),
      GoRoute(
        path: AppRoutes.bank,
        builder: (context, state) => const MessageBankScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) =>
            const LegalScreen(document: LegalDocument.privacy),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (context, state) =>
            const LegalScreen(document: LegalDocument.terms),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        builder: (context, state) => PaywallScreen(
          annualOffer: state.uri.queryParameters['offer'] == 'annual',
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    accessChanges.dispose();
  });
  return router;
});
