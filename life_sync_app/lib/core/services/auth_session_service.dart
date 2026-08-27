import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

/// Coordinates persisted authentication state without owning feature UI state.
final class AuthSessionService extends GetxService {
  AuthSessionService(this._tokenStorage);

  final TokenStorage _tokenStorage;
  StoredAuthSession? _currentSession;
  bool _initialized = false;

  StoredAuthSession? get currentSession => _currentSession;

  bool get isInitialized => _initialized;

  bool get isAuthenticated => _currentSession != null;

  Future<StoredAuthSession?> restoreSession() async {
    _currentSession = await _tokenStorage.readSession();
    _initialized = true;
    return _currentSession;
  }

  Future<void> saveSession(StoredAuthSession session) async {
    await _tokenStorage.saveSession(session);
    _currentSession = session;
    _initialized = true;
  }

  Future<void> clearSession() async {
    try {
      await _tokenStorage.clearSession();
    } finally {
      _currentSession = null;
      _initialized = true;
    }
  }

  Future<void> handleUnauthorized() async {
    await clearSession();

    if (Get.key.currentState != null && Get.currentRoute != AppRoutes.signIn) {
      await Get.offAllNamed<void>(AppRoutes.signIn);
    }
  }
}
