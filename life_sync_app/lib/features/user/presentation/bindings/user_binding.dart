import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:life_sync_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:life_sync_app/features/user/domain/repositories/user_repository.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';

final class UserBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserRemoteDataSource>()) {
      Get.lazyPut<UserRemoteDataSource>(
        () => UserRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.lazyPut<UserRepository>(
        () => UserRepositoryImpl(Get.find<UserRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(
        () => ProfileController(
          Get.find<UserRepository>(),
          Get.find<AuthSessionService>(),
          ImagePicker(),
        ),
        fenix: true,
      );
    }
  }
}
