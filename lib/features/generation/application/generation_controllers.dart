import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';

import '../data/supabase_generation_repository.dart';
import '../domain/generation_request.dart';
import '../domain/generation_result.dart';
import '../../credits/application/wallet_controller.dart';

final generationControllerProvider =
    AsyncNotifierProvider.autoDispose<GenerationController, GenerationResult?>(
      GenerationController.new,
    );

class GenerationController extends AutoDisposeAsyncNotifier<GenerationResult?> {
  /// Dernière demande, conservée pour « Régénérer ».
  GenerationRequest? _lastRequest;

  @override
  GenerationResult? build() => null;

  /// Demande que « Régénérer » renverra (pour en afficher le coût).
  GenerationRequest? get lastRequest => _lastRequest;

  /// Renvoie `true` si des propositions sont disponibles.
  Future<bool> generate(GenerationRequest request) async {
    _lastRequest = request;
    state = const AsyncLoading();
    state = await keepAliveWhile(
      ref,
      () => AsyncValue.guard(() async {
        final result = await ref
            .read(generationRepositoryProvider)
            .generate(request);
        ref.read(walletProvider.notifier).replace(result.wallet);
        return result;
      }),
    );
    return state.valueOrNull is GeneratedProposals;
  }

  Future<bool> regenerate() async {
    final request = _lastRequest;
    if (request == null) return false;
    return generate(request);
  }
}
