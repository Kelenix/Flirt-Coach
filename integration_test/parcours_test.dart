import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/generation/presentation/results_screen.dart';
import 'package:flirt_coach/features/message_bank/presentation/message_bank_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/test_app.dart';

/// Parcours critique de bout en bout sur un vrai appareil (rendu réel, serveur
/// simulé pour rester déterministe), avec mesure de la fluidité image par image.
///
/// Lancement : `flutter drive --profile -d APPAREIL
/// --driver=test_driver/integration_test.dart
/// --target=integration_test/parcours_test.dart`
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('accueil 18+ → Générer → Résultats → Banque', (tester) async {
    await tester.pumpWidget(await buildTestApp(FakeAuthRepository()));
    await tester.pumpAndSettle();

    await binding.watchPerformance(() async {
      // Accueil 18+.
      await tester.tap(find.text("J'ai 18 ans ou plus"));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();
      expect(find.byType(GenerateScreen), findsOneWidget);

      // Générer → Résultats → retour. Sur appareil, le clavier n'est pas simulé :
      // on choisit une situation qui ne demande pas de message à coller.
      await tester.tap(find.text('Répondre à un message'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Démarrer une conversation').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Générer 3 réponses'));
      await tester.pumpAndSettle();
      expect(find.byType(ResultsScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Retour'));
      await tester.pumpAndSettle();

      // Banque : changement d'onglet et défilement de liste.
      await openFromMenu(tester, 'Banque');
      expect(find.byType(MessageBankScreen), findsOneWidget);
      for (var i = 0; i < 3; i++) {
        await tester.fling(
          find.byType(TabBarView),
          const Offset(-400, 0),
          1500,
        );
        await tester.pumpAndSettle();
      }
      await tester.fling(
        find.byType(ListView).last,
        const Offset(0, -600),
        1500,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Retour'));
      await tester.pumpAndSettle();

      // Réglages, puis défilement de l'écran Générer.
      await openFromMenu(tester, 'Réglages');
      await tester.tap(find.byTooltip('Retour'));
      await tester.pumpAndSettle();
      await tester.fling(
        find.byType(Scrollable).first,
        const Offset(0, -500),
        1500,
      );
      await tester.pumpAndSettle();
    }, reportKey: 'parcours_principal');
  });
}
