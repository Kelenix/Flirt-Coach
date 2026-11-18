import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Traduit les exceptions Supabase en [Failure] typés.
Future<T> guardSupabase<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on Failure {
    rethrow;
  } on AuthRetryableFetchException {
    throw const NetworkFailure();
  } on SocketException {
    throw const NetworkFailure();
  } on TimeoutException {
    throw const NetworkFailure();
  } catch (_) {
    throw const UnexpectedFailure();
  }
}
