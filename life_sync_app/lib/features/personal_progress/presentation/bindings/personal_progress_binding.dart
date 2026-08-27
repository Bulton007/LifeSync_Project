import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/personal_progress/data/datasources/personal_progress_remote_data_source.dart';
import 'package:life_sync_app/features/personal_progress/data/repositories/personal_progress_repository_impl.dart';
import 'package:life_sync_app/features/personal_progress/domain/repositories/personal_progress_repository.dart';
import 'package:life_sync_app/features/personal_progress/presentation/controllers/personal_progress_controller.dart';

final class PersonalProgressBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PersonalProgressRemoteDataSource>()) {
      Get.lazyPut(
        () => PersonalProgressRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PersonalProgressRepository>()) {
      Get.lazyPut<PersonalProgressRepository>(
        () => PersonalProgressRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PersonalProgressController>()) {
      Get.lazyPut(
        () => PersonalProgressController(
          Get.find(),
          Get.find<AuthSessionService>(),
        ),
        fenix: true,
      );
    }
  }
}
