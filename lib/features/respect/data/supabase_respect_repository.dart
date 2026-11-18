import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/edge_function.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../credits/data/supabase_wallet_repository.dart';
import '../domain/respect_check.dart';
import '../domain/respect_repository.dart';

final respectRepositoryProvider = Provider<RespectRepository>(
  (ref) => SupabaseRespectRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseRespectRepository implements RespectRepository {
  const SupabaseRespectRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<RespectCheck> check({required String message, String? context}) async {
    final json = await invokeAiFunction(_client, 'respect-check', {
      'message': message,
      'context': ?context,
    });
    return respectCheckFromJson(json);
  }
}

/// Réponse de l'Edge Function `respect-check` → [RespectCheck].
RespectCheck respectCheckFromJson(Map<String, dynamic> json) {
  final wallet = walletFromJson(json['wallet'] as Map<String, dynamic>);
  if (json['refused'] == true) {
    return RespectCheck.refused(
      reason: json['reason'] as String? ?? '',
      wallet: wallet,
    );
  }
  final issues = <RespectIssue>[
    for (final issue in (json['issues'] as List? ?? const []).cast<Map>())
      if (RespectIssueCategory.fromApi(issue['category'] as String? ?? '')
          case final category?)
        RespectIssue(
          category: category,
          explanation: issue['explanation'] as String? ?? '',
        ),
  ];
  return RespectCheck.verdict(
    isRespectful: json['is_respectful'] as bool? ?? issues.isEmpty,
    issues: issues,
    alternative: json['alternative'] as String?,
    wallet: wallet,
  );
}
