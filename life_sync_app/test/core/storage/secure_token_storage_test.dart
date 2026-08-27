import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

void main() {
  group('SecureTokenStorage', () {
    late _MemorySecureStore store;
    late SecureTokenStorage storage;

    setUp(() {
      store = _MemorySecureStore();
      storage = SecureTokenStorage(store);
    });

    test('persists and restores an auth session', () async {
      await storage.saveSession(
        const StoredAuthSession(
          accessToken: ' token ',
          tokenType: ' Bearer ',
          userId: 19,
        ),
      );

      final restored = await storage.readSession();

      expect(restored?.accessToken, 'token');
      expect(restored?.tokenType, 'Bearer');
      expect(restored?.userId, 19);
      expect(restored?.authorizationHeader, 'Bearer token');
    });

    test('clears every session field', () async {
      await storage.saveSession(
        const StoredAuthSession(
          accessToken: 'token',
          tokenType: 'Bearer',
          userId: 19,
        ),
      );

      await storage.clearSession();

      expect(await storage.readSession(), isNull);
      expect(store.values, isEmpty);
    });

    test('removes a partial or malformed session', () async {
      store.values['auth.access_token'] = 'token';
      store.values['auth.user_id'] = 'not-an-id';

      expect(await storage.readSession(), isNull);
      expect(store.values, isEmpty);
    });

    test('rejects an empty access token', () async {
      expect(
        () => storage.saveSession(
          const StoredAuthSession(
            accessToken: ' ',
            tokenType: 'Bearer',
            userId: 19,
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}

final class _MemorySecureStore implements SecureKeyValueStore {
  final Map<String, String> values = {};

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
