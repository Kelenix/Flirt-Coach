import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/failure.dart';
import '../l10n/app_language.dart';
import 'supabase_client.dart';

/// Un appel IA peut durer jusqu'à ~50 s côté serveur (délai et nouvel essai).
const aiCallTimeout = Duration(seconds: 70);

/// Appelle une Edge Function IA et traduit ses codes d'erreur en [Failure].
/// La langue de l'interface (`locale`) accompagne chaque appel : le serveur
/// rédige dans cette langue les textes adressés à l'utilisateur.
Future<Map<String, dynamic>> invokeAiFunction(
  SupabaseClient client,
  String name,
  Map<String, dynamic> body,
) => guardSupabase(() async {
  try {
    final response = await client.functions.invoke(
      name,
      body: {...body, 'locale': currentLanguageCode()},
    );
    return response.data as Map<String, dynamic>;
  } on FunctionsFetchException {
    throw const NetworkFailure();
  } on FunctionException catch (error) {
    throw failureForFunctionError(error.details);
  }
}, timeout: aiCallTimeout);

/// Code d'erreur renvoyé par une Edge Function (`{"error": "..."}`) → [Failure].
Failure failureForFunctionError(Object? details) => switch (details is Map
    ? details['error']
    : null) {
  'insufficient_credits' => const InsufficientCreditsFailure(),
  'premium_required' => const PremiumRequiredFailure(),
  'daily_limit' => const DailyLimitFailure(),
  'rate_limited' => const RateLimitedFailure(),
  'ai_unavailable' => const AiUnavailableFailure(),
  'unusable_input' => const UnreadableScreenshotFailure(),
  'invalid_code' => const AccessCodeFailure(AccessCodeProblem.invalid),
  'code_unavailable' => const AccessCodeFailure(AccessCodeProblem.unavailable),
  'too_many_attempts' => const AccessCodeFailure(
    AccessCodeProblem.tooManyAttempts,
  ),
  _ => const UnexpectedFailure(),
};
