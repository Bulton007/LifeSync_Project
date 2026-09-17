import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';
import 'package:life_sync_app/features/assistant/presentation/controllers/assistant_controller.dart';

final class AssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeminiAssistantService>(
      () => GeminiAssistantService(Get.find<SecureKeyValueStore>()),
    );
    Get.lazyPut<AssistantController>(
      () => AssistantController(Get.find<GeminiAssistantService>()),
    );
  }
}
