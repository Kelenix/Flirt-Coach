import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/edge_function.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../credits/data/supabase_wallet_repository.dart';
import '../domain/analysis_repository.dart';
import '../domain/conversation_analysis.dart';

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => SupabaseAnalysisRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseAnalysisRepository implements AnalysisRepository {
  const SupabaseAnalysisRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<ConversationAnalysis> analyze({
    String? conversation,
    Uint8List? screenshot,
    String? context,
  }) async {
    final json = await invokeAiFunction(_client, 'conversation-analysis', {
      'conversation': ?conversation,
      if (screenshot != null) 'image': base64Encode(screenshot),
      'context': ?context,
    });
    final wallet = walletFromJson(json['wallet'] as Map<String, dynamic>);
    if (json['refused'] == true) {
      return ConversationAnalysis.refused(
        reason: json['reason'] as String? ?? '',
        wallet: wallet,
      );
    }
    return ConversationAnalysis.result(
      momentum: Momentum.fromApi(json['momentum'] as String),
      summary: json['summary'] as String,
      nextStep: json['next_step'] as String,
      suggestedMessage: json['suggested_message'] as String,
      dateSuggestion: json['date_suggestion'] as String?,
      wallet: wallet,
    );
  }
}
