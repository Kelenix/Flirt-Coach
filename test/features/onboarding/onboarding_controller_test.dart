import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/onboarding/application/onboarding_controller.dart';
import 'package:flirt_coach/features/onboarding/data/age_confirmation_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<ProviderContainer> containerWith(
    FakeAuthRepository auth, {
    bool isAgeConfirmed = false,
  }) async {
    final container = ProviderContainer(
      overrides: await testOverrides(auth, isAgeConfirmed: isAgeConfirmed),
    );
    addTearDown(container.dispose);
    // Garde le contrôleur autoDispose en vie pendant le test.
    container.listen(onboardingControllerProvider, (_, _) {});
    return container;
  }

  test('start crée la session, confirme l\'âge et ouvre l\'accès', () async {
    final auth = FakeAuthRepository();
    final container = await containerWith(auth);
    expect(container.read(accessGateProvider), isFalse);

    await container.read(onboardingControllerProvider.notifier).start();

    expect(auth.hasSession, isTrue);
    expect(auth.isAgeConfirmed, isTrue);
    expect(container.read(ageConfirmationStoreProvider).isConfirmed, isTrue);
    expect(container.read(accessGateProvider), isTrue);
  });

  test('un échec réseau ne mémorise rien et laisse l\'accès fermé', () async {
    final auth = FakeAuthRepository(error: const NetworkFailure());
    final container = await containerWith(auth);

    await container.read(onboardingControllerProvider.notifier).start();

    final state = container.read(onboardingControllerProvider);
    expect(state.error, isA<NetworkFailure>());
    expect(container.read(ageConfirmationStoreProvider).isConfirmed, isFalse);
    expect(container.read(accessGateProvider), isFalse);
  });

  test(
    'l\'accès exige à la fois la confirmation d\'âge et une session',
    () async {
      final confirmedWithoutSession = await containerWith(
        FakeAuthRepository(),
        isAgeConfirmed: true,
      );
      expect(confirmedWithoutSession.read(accessGateProvider), isFalse);

      final sessionWithoutConfirmation = await containerWith(
        FakeAuthRepository(hasSession: true),
      );
      expect(sessionWithoutConfirmation.read(accessGateProvider), isFalse);

      final both = await containerWith(
        FakeAuthRepository(hasSession: true),
        isAgeConfirmed: true,
      );
      expect(both.read(accessGateProvider), isTrue);
    },
  );
}
