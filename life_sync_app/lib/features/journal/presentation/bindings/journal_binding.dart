import 'package:get/get.dart';
import 'package:life_sync_app/core/database/life_sync_database.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/journal/data/datasources/journal_local_data_source.dart';
import 'package:life_sync_app/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:life_sync_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';

final class JournalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LifeSyncDatabase>()) {
      Get.put(LifeSyncDatabase(), permanent: true);
    }
    if (!Get.isRegistered<JournalLocalDataSource>()) {
      Get.lazyPut(
        () => JournalLocalDataSource(
          Get.find<LifeSyncDatabase>(),
          Get.find<AuthSessionService>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<JournalRepository>()) {
      Get.lazyPut<JournalRepository>(
        () => JournalRepositoryImpl(Get.find<JournalLocalDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<JournalController>()) {
      Get.lazyPut(
        () => JournalController(Get.find<JournalRepository>()),
        fenix: true,
      );
    }
  }
}
