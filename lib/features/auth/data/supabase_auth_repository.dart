import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseAuthRepository implements AuthRepository {
  const SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get hasSession => _client.auth.currentSession != null;

  @override
  String? get userId => _client.auth.currentUser?.id;

  @override
  Future<void> signInAnonymously() => guardSupabase(() async {
    if (hasSession) return;
    await _client.auth.signInAnonymously();
  });

  @override
  Future<void> confirmAge() =>
      guardSupabase(() => _client.rpc<void>('confirm_age'));
}
