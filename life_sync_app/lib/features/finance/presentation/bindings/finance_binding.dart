import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:life_sync_app/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:life_sync_app/features/finance/presentation/controllers/finance_controller.dart';

final class FinanceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FinanceRemoteDataSource>()) {
      Get.lazyPut(
        () => FinanceRemoteDataSource(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<FinanceRepository>()) {
      Get.lazyPut<FinanceRepository>(
        () => FinanceRepositoryImpl(Get.find()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<FinanceController>()) {
      Get.lazyPut(() => FinanceController(Get.find()), fenix: true);
    }
  }
}
