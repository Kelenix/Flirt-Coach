import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';

/// Motifs de signalement (INTAKE §7.5), alignés sur `report_reason` en base.
enum ReportReason {
  offensive('offensive'),
  sexual('sexual'),
  harassment('harassment'),
  manipulative('manipulative'),
  other('other');

  const ReportReason(this.apiName);

  final String apiName;
}

/// Signalement d'une réponse générée. Les erreurs sont des `Failure`.
abstract interface class ReportRepository {
  Future<void> report({
    required String generationId,
    required String text,
    required ReportReason reason,
  });
}

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => SupabaseReportRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseReportRepository implements ReportRepository {
  const SupabaseReportRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> report({
    required String generationId,
    required String text,
    required ReportReason reason,
  }) => guardSupabase(
    () => _client.rpc<void>(
      'report_generation',
      params: {
        'p_generation': generationId,
        'p_text': text,
        'p_reason': reason.apiName,
      },
    ),
  );
}
