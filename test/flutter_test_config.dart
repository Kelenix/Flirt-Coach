import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Chargé automatiquement par `flutter test` pour chaque fichier de test.
///
/// Les tests d'écrans vérifient les textes français : l'appareil simulé est en
/// français. Un test qui vérifie une autre langue la fixe lui-même
/// (`tester.platformDispatcher.localesTestValue`, voir `test/l10n/`).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    // Fichiers sans widget : aucune liaison Flutter à configurer.
    if (BindingBase.debugBindingType() == null) return;
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue =
        const [Locale('fr', 'FR')];
  });
  await testMain();
}
