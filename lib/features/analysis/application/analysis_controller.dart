import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../credits/application/wallet_controller.dart';
import '../data/supabase_analysis_repository.dart';
import '../domain/conversation_analysis.dart';

final analysisControllerProvider =
    AsyncNotifierProvider.autoDispose<
      AnalysisController,
      ConversationAnalysis?
    >(AnalysisController.new);

class AnalysisController extends AutoDisposeAsyncNotifier<ConversationAnalysis?>
    with GuardedAction {
  @override
  ConversationAnalysis? build() => null;

  Future<void> analyze({
    String? conversation,
    Uint8List? screenshot,
    String? context,
  }) async {
    await runGuarded(() async {
      final result = await ref
          .read(analysisRepositoryProvider)
          .analyze(
            conversation: conversation,
            screenshot: screenshot,
            context: context,
          );
      ref.read(walletProvider.notifier).replace(result.wallet);
      return result;
    });
  }
}
