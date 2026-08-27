final class StoredAuthSession {
  const StoredAuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
  });

  final String accessToken;
  final String tokenType;
  final int userId;

  String get authorizationHeader => '$tokenType $accessToken';
}

abstract interface class TokenStorage {
  Future<StoredAuthSession?> readSession();

  Future<void> saveSession(StoredAuthSession session);

  Future<void> clearSession();
}
