import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/config/app_environment.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

/// Registers infrastructure shared by feature bindings.
///
/// Feature repositories and controllers intentionally belong to their own
/// route-level bindings and are not registered globally here.
final class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppEnvironment>(AppEnvironment.current, fenix: true);

    Get.lazyPut<TokenStorage>(
      () => SecureTokenStorage(
        FlutterSecureKeyValueStore(const FlutterSecureStorage()),
      ),
      fenix: true,
    );

    Get.lazyPut<AuthSessionService>(
      () => AuthSessionService(Get.find<TokenStorage>()),
      fenix: true,
    );

    Get.lazyPut<ApiClient>(
      () => ApiClient(
        environment: Get.find<AppEnvironment>(),
        tokenStorage: Get.find<TokenStorage>(),
        onUnauthorized: Get.find<AuthSessionService>().handleUnauthorized,
      ),
      fenix: true,
    );
  }
}
