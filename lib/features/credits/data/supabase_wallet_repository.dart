import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/wallet.dart';
import '../domain/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => SupabaseWalletRepository(ref.watch(supabaseClientProvider)),
);

/// Portefeuille au format renvoyé par le serveur (`get_wallet`, Edge Functions).
Wallet walletFromJson(Map<String, dynamic> json) => Wallet(
  dailyCredits: json['daily_credits'] as int,
  bonusCredits: json['bonus_credits'] as int,
  isPremium: json['is_premium'] as bool,
  adRewardsLeft: json['ad_rewards_left'] as int? ?? 0,
);

class SupabaseWalletRepository implements WalletRepository {
  const SupabaseWalletRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<Wallet> fetch() => guardSupabase(() async {
    final rows = await _client.rpc<List<dynamic>>('get_wallet');
    return walletFromJson(rows.single as Map<String, dynamic>);
  });
}
