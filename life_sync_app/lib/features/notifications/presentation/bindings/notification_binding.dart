import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:life_sync_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:life_sync_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:life_sync_app/features/notifications/presentation/controllers/notification_controller.dart';

final class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationRemoteDataSource>()) {
      Get.lazyPut(
        () => NotificationRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<NotificationRepository>()) {
      Get.lazyPut<NotificationRepository>(
        () => NotificationRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController(Get.find()), fenix: true);
    }
  }
}
