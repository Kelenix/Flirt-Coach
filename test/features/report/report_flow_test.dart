import 'package:flirt_coach/features/generation/presentation/generate_screen.dart';
import 'package:flirt_coach/features/report/data/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<FakeBackend> openResults(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final backend = FakeBackend();
    await tester.pumpWidget(await buildSignedInApp(backend));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(GenerateScreen.messageFieldKey),
      'Tu fais quoi ce soir ?',
    );
    await tester.pump();
    await tester.tap(filledButton('Générer 3 réponses'));
    await tester.pumpAndSettle();
    return backend;
  }

  testWidgets('signaler une réponse : motif choisi, signalement envoyé', (
    tester,
  ) async {
    final backend = await openResults(tester);

    await tester.tap(find.byTooltip('Signaler').at(1));
    await tester.pumpAndSettle();
    expect(find.text('Signaler cette réponse'), findsOneWidget);

    await tester.tap(find.text('Harcèlement ou insistance'));
    await tester.pumpAndSettle();

    expect(backend.reports.single, (
      generationId: 'gen-1',
      text: 'Proposition 1.2',
      reason: ReportReason.harassment,
    ));
    expect(find.text('Merci, ton signalement a été envoyé.'), findsOneWidget);
  });

  testWidgets('fermer sans choisir de motif : rien n\'est envoyé', (
    tester,
  ) async {
    final backend = await openResults(tester);

    await tester.tap(find.byTooltip('Signaler').first);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(backend.reports, isEmpty);
  });
}
