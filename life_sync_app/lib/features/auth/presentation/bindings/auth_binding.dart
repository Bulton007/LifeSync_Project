import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:life_sync_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';

final class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRemoteDataSource>()) {
      Get.lazyPut<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(
          Get.find<AuthRepository>(),
          Get.find<AuthSessionService>(),
        ),
        fenix: true,
      );
    }
  }
}
