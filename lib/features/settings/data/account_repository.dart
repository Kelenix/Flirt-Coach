import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/edge_function.dart';
import '../../../core/supabase/supabase_client.dart';

/// Compte de l'utilisateur. Les erreurs sont des `Failure`.
abstract interface class AccountRepository {
  /// Supprime définitivement le compte et ses données côté serveur (US-05),
  /// puis ferme la session locale.
  Future<void> deleteAccount();
}

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
