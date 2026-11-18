import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Conserve la session Supabase dans le Keychain (iOS) / Keystore (Android)
/// plutôt que dans les préférences en clair.
class SecureLocalStorage extends LocalStorage {
  const SecureLocalStorage([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _sessionKey = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() => _storage.read(key: _sessionKey);

  @override
  Future<bool> hasAccessToken() => _storage.containsKey(key: _sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _sessionKey, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _sessionKey);
}
