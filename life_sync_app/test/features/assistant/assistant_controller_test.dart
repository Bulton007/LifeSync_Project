import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';
import 'package:life_sync_app/features/assistant/presentation/controllers/assistant_controller.dart';

final class _FakeSecureStore implements SecureKeyValueStore {
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}

void main() {
  late _FakeSecureStore fakeStore;
  late GeminiAssistantService geminiService;
  late AssistantController controller;

  setUp(() {
    fakeStore = _FakeSecureStore();
    geminiService = GeminiAssistantService(fakeStore);
    controller = AssistantController(geminiService);
  });

  tearDown(() {
    controller.dispose();
  });

  test(
    'AssistantController starts with no messages and no api key by default',
    () async {
      await controller.checkApiKey();
      expect(controller.messages, isEmpty);
      expect(controller.isLoading.value, isFalse);
      expect(controller.hasApiKey.value, isFalse);
    },
  );

  test(
    'Saving and clearing Gemini API key updates state and storage',
    () async {
      await controller.saveApiKey('test-key-12345');
      expect(controller.hasApiKey.value, isTrue);
      expect(await controller.getApiKey(), 'test-key-12345');

      await controller.clearApiKey();
      expect(controller.hasApiKey.value, isFalse);
      expect(await controller.getApiKey(), isNull);
    },
  );

  test(
    'Sending message when API key is missing adds helpful configuration prompt',
    () async {
      await controller.sendMessage('Hello assistant!');

      expect(controller.messages.length, 2);
      expect(controller.messages[0].sender, MessageSender.user);
      expect(controller.messages[0].text, 'Hello assistant!');

      expect(controller.messages[1].sender, MessageSender.assistant);
      expect(controller.messages[1].isError, isTrue);
      expect(
        controller.messages[1].text,
        contains('Gemini API key is not configured yet'),
      );
    },
  );

  test('Clear conversation resets messages list', () async {
    await controller.sendMessage('Test');
    expect(controller.messages, isNotEmpty);

    controller.clearConversation();
    expect(controller.messages, isEmpty);
  });
}
