import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences.dart';
import '../../credits/domain/wallet.dart';

/// Horloge, remplaçable dans les tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final annualOfferProvider = Provider<AnnualOffer>(
  (ref) => AnnualOffer(
    ref.watch(sharedPreferencesProvider),
    ref.watch(clockProvider),
  ),
);

/// Offre annuelle présentée une seule fois, 3 jours après la première utilisation,
/// aux utilisateurs gratuits (INTAKE §4, hypothèse H8).
class AnnualOffer {
  AnnualOffer(this._preferences, this._now);

  final SharedPreferences _preferences;
  final DateTime Function() _now;

  static const delay = Duration(days: 3);
  static const _firstSeenKey = 'first_seen_at';
  static const _shownKey = 'annual_offer_shown';

  /// Enregistre la première utilisation si besoin, puis dit s'il faut montrer l'offre.
  bool shouldShow(Wallet wallet) {
    final now = _now();
    final firstSeen = DateTime.tryParse(
      _preferences.getString(_firstSeenKey) ?? '',
    );
    if (firstSeen == null) {
      _preferences.setString(_firstSeenKey, now.toIso8601String());
      return false;
    }
    return !wallet.isPremium &&
        !(_preferences.getBool(_shownKey) ?? false) &&
        now.difference(firstSeen) >= delay;
  }

  Future<void> markShown() => _preferences.setBool(_shownKey, true);
}
