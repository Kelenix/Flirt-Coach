import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/edge_function.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => SupabaseAccountRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseAccountRepository implements AccountRepository {
  const SupabaseAccountRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> deleteAccount() async {
    await invokeAiFunction(_client, 'delete-account', const {});
    // Le compte n'existe plus côté serveur : on oublie seulement la session locale.
    await guardSupabase(() => _client.auth.signOut(scope: SignOutScope.local));
  }
}
