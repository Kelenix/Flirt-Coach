import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

/// Crédits et droits de l'utilisateur, tels que calculés par le serveur.
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required int dailyCredits,
    required int bonusCredits,
    required bool isPremium,

    /// Vidéos récompensées encore possibles aujourd'hui (0 pour Premium).
    @Default(0) int adRewardsLeft,
  }) = _Wallet;

  const Wallet._();

  int get credits => dailyCredits + bonusCredits;

  bool canAfford(int cost) => isPremium || credits >= cost;
}
