import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:life_sync_app/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:life_sync_app/features/habits/domain/repositories/habit_repository.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';

final class HabitBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HabitRemoteDataSource>()) {
      Get.lazyPut(
        () => HabitRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<HabitRepository>()) {
      Get.lazyPut<HabitRepository>(
        () => HabitRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<HabitController>()) {
      Get.lazyPut(() => HabitController(Get.find()), fenix: true);
    }
  }
}
