import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/history_entry.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => SupabaseHistoryRepository(ref.watch(supabaseClientProvider)),
);

/// Lit l'historique sous RLS : le serveur ne renvoie rien à un utilisateur gratuit.
class SupabaseHistoryRepository implements HistoryRepository {
  const SupabaseHistoryRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<HistoryEntry>> fetchPage({
    DateTime? before,
    required int limit,
  }) => guardSupabase(() async {
    var query = _client
        .from('generations')
        .select('id, kind, input_text, output, created_at');
    if (before != null) {
      query = query.lt('created_at', before.toUtc().toIso8601String());
    }
    final rows = await query.order('created_at', ascending: false).limit(limit);
    return [for (final row in rows) entryFromRow(row)];
  });

  @override
  Future<void> delete(String id) => guardSupabase(
    () => _client.rpc<void>('delete_generation', params: {'p_id': id}),
  );
}

/// Ligne de `generations` → entrée lisible, quel que soit le type de génération.
HistoryEntry entryFromRow(Map<String, dynamic> row) {
  final output = row['output'] as Map<String, dynamic>? ?? const {};
  final results = switch (row['kind'] as String) {
    'respect_check' => [?output['alternative'] as String?],
    'conversation_analysis' => [
      ?output['suggestedMessage'] as String?,
      ?output['dateSuggestion'] as String?,
    ],
    _ => [
      for (final proposal in output['proposals'] as List? ?? const [])
        proposal as String,
    ],
  };
  return HistoryEntry(
    id: row['id'] as String,
    kind: row['kind'] as String,
    createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
    input: row['input_text'] as String?,
    results: results,
  );
}
