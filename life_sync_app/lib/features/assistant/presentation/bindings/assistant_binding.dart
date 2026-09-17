import 'package:get/get.dart';
import 'package:life_sync_app/core/config/app_environment.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';
import 'package:life_sync_app/features/assistant/presentation/controllers/assistant_controller.dart';

final class AssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeminiAssistantService>(() {
      final env = Get.isRegistered<AppEnvironment>()
          ? Get.find<AppEnvironment>()
          : null;
      final apiClient = Get.isRegistered<ApiClient>()
          ? Get.find<ApiClient>()
          : null;
      return GeminiAssistantService(
        Get.find<SecureKeyValueStore>(),
        apiClient: apiClient,
        defaultApiKey:
            env?.geminiApiKey ?? const String.fromEnvironment('GEMINI_API_KEY'),
        apiBaseUrl: env?.geminiApiBaseUrl,
        preferredModel: env?.geminiModel,
      );
    });
    Get.lazyPut<AssistantController>(
      () => AssistantController(Get.find<GeminiAssistantService>()),
    );
  }
}
