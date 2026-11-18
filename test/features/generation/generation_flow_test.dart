import 'package:flirt_coach/core/theme/app_icons.dart';
import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/generation/domain/message_style.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/generation/domain/situation.dart';
import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/generation/presentation/results_screen.dart';
import 'package:flirt_coach/features/purchases/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final messageField = find.byKey(GenerateScreen.messageFieldKey);
  final contextField = find.byKey(GenerateScreen.contextFieldKey);

  FilledButton generateButton(WidgetTester tester) =>
      tester.widget(filledButton('Générer 3 réponses'));

  Future<FakeBackend> openGenerateScreen(
    WidgetTester tester, {
    Wallet wallet = const Wallet(
      dailyCredits: 5,
      bonusCredits: 0,
      isPremium: false,
    ),
    bool phoneViewport = true,
  }) async {
    if (phoneViewport) {
      // Téléphone courant (1080 × 2400 px), pour tester l'écran tel qu'il s'affiche.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
    }
    final repository = FakeBackend(wallet: wallet);
    await tester.pumpWidget(await buildSignedInApp(repository));
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('écran Générer : invite, crédits, bouton bloqué sans message', (
    tester,
  ) async {
    await openGenerateScreen(tester);

    expect(find.text('Générer un message'), findsOneWidget);
    expect(find.text('Colle son dernier message…'), findsOneWidget);
    expect(find.text('5 crédits'), findsOneWidget);
    expect(generateButton(tester).onPressed, isNull);
  });

  testWidgets('message collé → 3 propositions, crédit décompté', (
    tester,
  ) async {
    final repository = await openGenerateScreen(tester);

    await tester.enterText(messageField, '  Salut, ta journée ?  ');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    expect(repository.requests.single.message, 'Salut, ta journée ?');
    expect(repository.requests.single.style, MessageStyle.classic);
    expect(find.byType(ResultsScreen), findsOneWidget);
    for (var i = 1; i <= 3; i++) {
      expect(find.text('Proposition 1.$i'), findsOneWidget);
    }
    // La page Résultats du kit n'affiche pas les crédits : on vérifie le solde.
    expect(repository.wallet.dailyCredits, 4);
  });

  testWidgets('Copier place la proposition dans le presse-papiers', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await openGenerateScreen(tester);
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Copier').at(1));
    await tester.pumpAndSettle();

    expect(copied, 'Proposition 1.2');
    expect(find.textContaining('Copié'), findsOneWidget);
  });

  testWidgets('Régénérer remplace les propositions', (tester) async {
    final repository = await openGenerateScreen(tester);
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Régénérer (1 crédit)'));
    await tester.pumpAndSettle();

    expect(repository.requests, hasLength(2));
    expect(find.text('Proposition 2.1'), findsOneWidget);
    expect(repository.wallet.dailyCredits, 3);
  });

  testWidgets('style avancé verrouillé pour un gratuit : ouvre le paywall', (
    tester,
  ) async {
    await openGenerateScreen(tester);
    expect(find.byIcon(AppIcons.lock), findsNWidgets(6));

    await tester.tap(find.text('Drôle'));
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
  });

  testWidgets('Premium : styles avancés utilisables', (tester) async {
    final repository = await openGenerateScreen(
      tester,
      wallet: const Wallet(dailyCredits: 5, bonusCredits: 0, isPremium: true),
    );

    expect(find.byIcon(AppIcons.lock), findsNothing);
    expect(find.text('Premium'), findsOneWidget);
    await tester.tap(find.text('Mystérieux'));
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    expect(repository.requests.single.style, MessageStyle.mysterious);
  });

  testWidgets('plus de crédit : message clair, génération bloquée', (
    tester,
  ) async {
    await openGenerateScreen(
      tester,
      wallet: const Wallet(dailyCredits: 0, bonusCredits: 0, isPremium: false),
    );
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();

    expect(
      find.textContaining('Tu as utilisé tes crédits du jour'),
      findsOneWidget,
    );
    expect(find.text('Générer 3 réponses'), findsNothing);
    expect(find.text('Passer Premium'), findsOneWidget);
  });

  testWidgets('demande refusée par la modération : raison affichée', (
    tester,
  ) async {
    final repository = await openGenerateScreen(tester)
      ..refusal = 'Elle a dit non : respecte son choix.';
    await tester.enterText(messageField, 'Comment la faire céder ?');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    expect(find.text('Elle a dit non : respecte son choix.'), findsOneWidget);
    expect(find.byType(ResultsScreen), findsNothing);
    expect(repository.wallet.dailyCredits, 5);
  });

  testWidgets('IA indisponible : erreur, on reste sur l\'écran', (
    tester,
  ) async {
    final repository = await openGenerateScreen(tester)
      ..error = const AiUnavailableFailure();
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    expect(find.textContaining('momentanément indisponible'), findsOneWidget);
    expect(find.byType(ResultsScreen), findsNothing);

    repository.error = null;
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultsScreen), findsOneWidget);
  });

  testWidgets('réponse : le contexte facultatif est transmis', (tester) async {
    final repository = await openGenerateScreen(tester);
    await tester.enterText(messageField, 'Coucou');
    await tester.enterText(contextField, " On s'est rencontrés au salsa ");
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    final request = repository.requests.single;
    expect(request.situation, Situation.reply);
    expect(request.context, "On s'est rencontrés au salsa");
  });

  testWidgets('autre situation : pas de message reçu, contexte facultatif', (
    tester,
  ) async {
    final repository = await openGenerateScreen(tester);
    await tester.enterText(messageField, 'Texte saisi avant de changer');

    await tester.tap(find.text('Répondre à un message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Démarrer une conversation').last);
    await tester.pumpAndSettle();

    expect(messageField, findsNothing);
    expect(find.textContaining('sa bio'), findsOneWidget);
    expect(generateButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    final request = repository.requests.single;
    expect(request.situation, Situation.opener);
    expect(request.message, isNull);
    expect(request.context, isNull);
    expect(find.byType(ResultsScreen), findsOneWidget);
  });

  testWidgets('les 7 situations sont proposées', (tester) async {
    await openGenerateScreen(tester);
    await tester.tap(find.text('Répondre à un message'));
    await tester.pumpAndSettle();

    for (final label in [
      'Démarrer une conversation',
      'Flirter',
      'Relancer la conversation',
      'Avant un rendez-vous',
      "M'excuser",
      'Rompre en douceur',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
  });

  testWidgets('petit écran et grande police : aucun débordement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await openGenerateScreen(tester, phoneViewport: false);
    await tester.scrollUntilVisible(
      messageField,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(messageField, 'Coucou');
    await tester.pump();
    await tester.tap(find.text('Générer 3 réponses'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
