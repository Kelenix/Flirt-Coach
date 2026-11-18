import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences.dart';

final ageConfirmationStoreProvider = Provider<AgeConfirmationStore>(
  (ref) => AgeConfirmationStore(ref.watch(sharedPreferencesProvider)),
);

/// Copie locale de la confirmation d'âge, pour ne pas la redemander à chaque
/// lancement. La référence reste `profiles.age_confirmed_at` côté serveur.
class AgeConfirmationStore {
  const AgeConfirmationStore(this._preferences);

  final SharedPreferences _preferences;

  static const _key = 'age_confirmed';

  bool get isConfirmed => _preferences.getBool(_key) ?? false;

  Future<void> markConfirmed() => _preferences.setBool(_key, true);
}
