import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/keep_alive.dart';
import '../../credits/application/wallet_controller.dart';
import '../data/supabase_respect_repository.dart';
import '../domain/respect_check.dart';

final respectControllerProvider =
    AsyncNotifierProvider.autoDispose<RespectController, RespectCheck?>(
      RespectController.new,
    );

class RespectController extends AutoDisposeAsyncNotifier<RespectCheck?> {
  @override
  RespectCheck? build() => null;

  Future<void> check({required String message, String? context}) async {
    state = const AsyncLoading();
    state = await keepAliveWhile(
      ref,
      () => AsyncValue.guard(() async {
        final result = await ref
            .read(respectRepositoryProvider)
            .check(message: message, context: context);
        ref.read(walletProvider.notifier).replace(result.wallet);
        return result;
      }),
    );
  }
}
