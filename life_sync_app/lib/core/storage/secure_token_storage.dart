import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

final class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  const FlutterSecureKeyValueStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Stores only the credentials required to restore an authenticated session.
final class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage(this._store);

  static const _accessTokenKey = 'auth.access_token';
  static const _tokenTypeKey = 'auth.token_type';
  static const _userIdKey = 'auth.user_id';

  final SecureKeyValueStore _store;

  @override
  Future<StoredAuthSession?> readSession() async {
    final accessToken = (await _store.read(_accessTokenKey))?.trim();
    final rawUserId = (await _store.read(_userIdKey))?.trim();
    final tokenType = (await _store.read(_tokenTypeKey))?.trim();
    final userId = int.tryParse(rawUserId ?? '');

    if (accessToken == null || accessToken.isEmpty || userId == null) {
      if (accessToken != null || rawUserId != null || tokenType != null) {
        await clearSession();
      }
      return null;
    }

    return StoredAuthSession(
      accessToken: accessToken,
      tokenType: tokenType == null || tokenType.isEmpty ? 'Bearer' : tokenType,
      userId: userId,
    );
  }

  @override
  Future<void> saveSession(StoredAuthSession session) async {
    final accessToken = session.accessToken.trim();
    final tokenType = session.tokenType.trim();

    if (accessToken.isEmpty || tokenType.isEmpty) {
      throw ArgumentError('Access token and token type must not be empty.');
    }

    try {
      await _store.write(_accessTokenKey, accessToken);
      await _store.write(_tokenTypeKey, tokenType);
      await _store.write(_userIdKey, session.userId.toString());
    } on Object {
      try {
        await clearSession();
      } on Object {
        // Preserve the original secure-storage exception.
      }
      rethrow;
    }
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([
      _store.delete(_accessTokenKey),
      _store.delete(_tokenTypeKey),
      _store.delete(_userIdKey),
    ]);
  }
}
