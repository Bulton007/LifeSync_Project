import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/features/goals/data/datasources/goal_remote_data_source.dart';
import 'package:life_sync_app/features/goals/data/repositories/goal_repository_impl.dart';
import 'package:life_sync_app/features/goals/domain/repositories/goal_repository.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';

final class GoalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GoalRemoteDataSource>()) {
      Get.lazyPut(
        () => GoalRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GoalRepository>()) {
      Get.lazyPut<GoalRepository>(
        () => GoalRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GoalController>()) {
      Get.lazyPut(() => GoalController(Get.find()), fenix: true);
    }
  }
}
