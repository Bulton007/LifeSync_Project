import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:life_sync_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:life_sync_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';

final class TaskBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TaskRemoteDataSource>()) {
      Get.lazyPut<TaskRemoteDataSource>(
        () => TaskRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<TaskRepository>()) {
      Get.lazyPut<TaskRepository>(
        () => TaskRepositoryImpl(Get.find<TaskRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<TaskController>()) {
      Get.lazyPut<TaskController>(
        () => TaskController(Get.find<TaskRepository>()),
        fenix: true,
      );
    }
  }
}
