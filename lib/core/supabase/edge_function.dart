import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';
import 'supabase_client.dart';

/// Appelle une Edge Function IA et traduit ses codes d'erreur en [Failure].
Future<Map<String, dynamic>> invokeAiFunction(
  SupabaseClient client,
  String name,
  Map<String, dynamic> body,
) => guardSupabase(() async {
  try {
    final response = await client.functions.invoke(name, body: body);
    return response.data as Map<String, dynamic>;
  } on FunctionsFetchException {
    throw const NetworkFailure();
  } on FunctionException catch (error) {
    final details = error.details;
    throw switch (details is Map ? details['error'] : null) {
      'insufficient_credits' => const InsufficientCreditsFailure(),
      'premium_required' => const PremiumRequiredFailure(),
      'daily_limit' => const DailyLimitFailure(),
      'ai_unavailable' => const AiUnavailableFailure(),
      'unusable_input' => const UnreadableScreenshotFailure(),
      _ => const UnexpectedFailure(),
    };
  }
});
