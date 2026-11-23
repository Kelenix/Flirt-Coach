import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/bank_message.dart';

final messageBankRepositoryProvider = Provider<MessageBankRepository>(
  (ref) => SupabaseMessageBankRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(sharedPreferencesProvider),
  ),
);

/// Lit la banque sur le serveur et en garde une copie locale par langue (contenu
/// public, non sensible) pour la consultation hors-ligne.
class SupabaseMessageBankRepository implements MessageBankRepository {
  const SupabaseMessageBankRepository(this._client, this._preferences);

  static String _cacheKey(String languageCode) =>
      'message_bank_cache_$languageCode';

  /// Sans réseau, une requête peut rester en attente : au-delà, la copie locale sert.
  static const _timeout = Duration(seconds: 6);

  final SupabaseClient _client;
  final SharedPreferences _preferences;

  @override
  Future<List<BankMessage>> fetchAll(String languageCode) async {
    try {
      final rows = await guardSupabase(
        () => _client
            .from('message_bank')
            .select('category, body')
            .eq('language', languageCode)
            .order('category', ascending: true)
            .order('sort_order', ascending: true)
            .timeout(_timeout),
      );
      await _preferences.setString(_cacheKey(languageCode), jsonEncode(rows));
      return _parse(rows);
    } on Failure {
      final cached = _preferences.getString(_cacheKey(languageCode));
      if (cached == null) rethrow;
      return _parse(jsonDecode(cached) as List<dynamic>);
    }
  }

  static List<BankMessage> _parse(List<dynamic> rows) => [
    for (final row in rows.cast<Map<String, dynamic>>())
      if (BankCategory.fromApi(row['category'] as String) case final category?)
        BankMessage(category: category, body: row['body'] as String),
  ];
}
