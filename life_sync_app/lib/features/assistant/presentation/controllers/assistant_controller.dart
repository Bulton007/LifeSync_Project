import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';

final class AssistantController extends GetxController {
  AssistantController(this._geminiService);

  final GeminiAssistantService _geminiService;

  bool get isBackendManaged => _geminiService.isBackendManaged;

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final hasApiKey = false.obs;
  final inputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkApiKey();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  Future<void> checkApiKey() async {
    final key = await _geminiService.getApiKey();
    hasApiKey.value = key != null && key.isNotEmpty;
  }

  Future<String?> getApiKey() => _geminiService.getApiKey();

  Future<void> saveApiKey(String key) async {
    if (key.trim().isEmpty) return;
    await _geminiService.saveApiKey(key.trim());
    hasApiKey.value = true;
  }

  Future<void> clearApiKey() async {
    await _geminiService.clearApiKey();
    hasApiKey.value = false;
  }

  Future<void> sendMessage([String? suggestion]) async {
    final text = (suggestion ?? inputController.text).trim();
    if (text.isEmpty || isLoading.value) return;

    isLoading.value = true;

    inputController.clear();

    final userMessage = ChatMessage(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    final key = await _geminiService.getApiKey();
    if (key == null || key.isEmpty) {
      messages.add(
        ChatMessage(
          text:
              'AI is not configured yet. Please connect to the LifeSync backend.',
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    try {
      final reply = await _geminiService.sendMessage(
        prompt: text,
        conversationHistory: messages.take(messages.length - 1).toList(),
      );

      messages.add(
        ChatMessage(
          text: reply,
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      messages.add(
        ChatMessage(
          text:
              'Error generating response: ${e.toString().replaceAll('Exception: ', '')}',
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearConversation() {
    if (isLoading.value) return;
    messages.clear();
  }
}
