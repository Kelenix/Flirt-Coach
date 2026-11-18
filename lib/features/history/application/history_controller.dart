import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/supabase_history_repository.dart';
import '../domain/history_entry.dart';

/// Historique chargé page par page ; [hasMore] indique s'il reste des entrées.
final class HistoryPage {
  const HistoryPage({required this.entries, required this.hasMore});

  final List<HistoryEntry> entries;
  final bool hasMore;
}

final historyControllerProvider =
    AsyncNotifierProvider.autoDispose<HistoryController, HistoryPage>(
      HistoryController.new,
    );

class HistoryController extends AutoDisposeAsyncNotifier<HistoryPage> {
  static const pageSize = 20;

  @override
  Future<HistoryPage> build() => _load(const []);

  Future<HistoryPage> _load(List<HistoryEntry> current) async {
    final page = await ref
        .read(historyRepositoryProvider)
        .fetchPage(
          before: current.isEmpty ? null : current.last.createdAt,
          limit: pageSize,
        );
    return HistoryPage(
      entries: [...current, ...page],
      hasMore: page.length == pageSize,
    );
  }

  /// Ajoute la page suivante ; en cas d'erreur, les entrées affichées restent
  /// et l'erreur est renvoyée à l'écran.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncData(await _load(current.entries));
  }

  /// Supprime une entrée ; l'erreur éventuelle est renvoyée à l'écran.
  Future<void> delete(String id) async {
    await ref.read(historyRepositoryProvider).delete(id);
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      HistoryPage(
        entries: [
          for (final entry in current.entries)
            if (entry.id != id) entry,
        ],
        hasMore: current.hasMore,
      ),
    );
  }
}
