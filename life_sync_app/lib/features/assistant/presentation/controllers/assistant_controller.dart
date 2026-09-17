import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';

final class AssistantController extends GetxController {
  AssistantController(this._geminiService);

  final GeminiAssistantService _geminiService;

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
              'Gemini API key is not configured yet.\n\n'
              'Please ensure the backend server is running and configured with GEMINI_API_KEY in .env.',
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
      return;
    }

    isLoading.value = true;

    try {
      final reply = await _geminiService.sendMessage(
        prompt: text,
        conversationHistory: messages.toList(),
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
    messages.clear();
  }
}
