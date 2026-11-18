import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Traduit les exceptions Supabase en [Failure] typés. Au-delà de [timeout]
/// (réseau captif, serveur muet), l'appel échoue en [NetworkFailure].
Future<T> guardSupabase<T>(
  Future<T> Function() action, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  try {
    return await action().timeout(timeout);
  } on Failure {
    rethrow;
  } on AuthRetryableFetchException {
    throw const NetworkFailure();
  } on SocketException {
    throw const NetworkFailure();
  } on TimeoutException {
    throw const NetworkFailure();
  } catch (error) {
    // Type seulement : jamais de contenu utilisateur dans les journaux.
    debugPrint('Erreur inattendue : ${error.runtimeType}');
    throw const UnexpectedFailure();
  }
}
