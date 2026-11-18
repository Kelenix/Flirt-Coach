import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/edge_function.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../credits/data/supabase_wallet_repository.dart';
import '../domain/generation_repository.dart';
import '../domain/generation_request.dart';
import '../domain/generation_result.dart';

final generationRepositoryProvider = Provider<GenerationRepository>(
  (ref) => SupabaseGenerationRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseGenerationRepository implements GenerationRepository {
  const SupabaseGenerationRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<GenerationResult> generate(GenerationRequest request) async {
    final json = switch (request.screenshot) {
      final screenshot? => await invokeAiFunction(_client, 'screenshot-reply', {
        'image': base64Encode(screenshot),
        'style': request.style.apiName,
        'context': ?request.context,
      }),
      null => await invokeAiFunction(_client, 'generate', {
        'situation': request.situation.apiName,
        'style': request.style.apiName,
        if (request.situation.requiresMessage) 'message': request.message,
        'context': ?request.context,
      }),
    };
    final wallet = walletFromJson(json['wallet'] as Map<String, dynamic>);
    if (json['refused'] == true) {
      return GenerationResult.refused(
        reason: json['reason'] as String? ?? '',
        wallet: wallet,
      );
    }
    return GenerationResult.proposals(
      id: json['id'] as String,
      proposals: List<String>.from(json['proposals'] as List),
      wallet: wallet,
    );
  }
}
