import 'package:flirt_coach/core/config/configuration_error_app.dart';
import 'package:flirt_coach/core/config/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('les tests sont compilés sans configuration', () {
    expect(Env.isConfigured, isFalse);
  });

  testWidgets('sans configuration : message clair au lieu du logo figé', (
    tester,
  ) async {
    await tester.pumpWidget(const ConfigurationErrorApp());

    expect(find.text('Configuration manquante'), findsOneWidget);
    expect(find.textContaining('--dart-define-from-file'), findsOneWidget);
  });
}
