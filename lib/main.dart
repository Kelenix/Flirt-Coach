import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/configuration_error_app.dart';
import 'core/config/env.dart';
import 'core/supabase/secure_local_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(systemBarsStyle);
  if (!Env.isConfigured) {
    runApp(const ConfigurationErrorApp());
    return;
  }

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      localStorage: SecureLocalStorage(),
    ),
  );
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const FlirtCoachApp(),
    ),
  );
}
