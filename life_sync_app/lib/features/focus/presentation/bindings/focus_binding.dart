import 'package:get/get.dart';
import 'package:life_sync_app/core/database/life_sync_database.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/focus/data/datasources/focus_local_data_source.dart';
import 'package:life_sync_app/features/focus/data/repositories/focus_repository_impl.dart';
import 'package:life_sync_app/features/focus/domain/repositories/focus_repository.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';

final class FocusBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LifeSyncDatabase>()) {
      Get.put(LifeSyncDatabase(), permanent: true);
    }
    if (!Get.isRegistered<FocusLocalDataSource>()) {
      Get.lazyPut(
        () => FocusLocalDataSource(
          Get.find<LifeSyncDatabase>(),
          Get.find<AuthSessionService>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<FocusRepository>()) {
      Get.lazyPut<FocusRepository>(
        () => FocusRepositoryImpl(Get.find<FocusLocalDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<FocusController>()) {
      Get.lazyPut(
        () => FocusController(
          Get.find<FocusRepository>(),
          Get.find<SecureKeyValueStore>(),
          ownerId: Get.find<AuthSessionService>().currentSession?.userId ?? 0,
        ),
        fenix: true,
      );
    }
  }
}
