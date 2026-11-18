import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/report.dart';

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
