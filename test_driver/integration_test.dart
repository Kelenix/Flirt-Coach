import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

/// Lance les tests de bout en bout sur un appareil et enregistre les mesures de
/// performance dans `build/performance.json`.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    await File(
      'build/performance.json',
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  },
);
