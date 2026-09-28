import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';
import 'package:life_sync_app/features/assistant/data/services/gemini_assistant_service.dart';
import 'package:life_sync_app/features/assistant/presentation/controllers/assistant_controller.dart';
import 'package:life_sync_app/features/assistant/presentation/pages/assistant_screen.dart';
import '../../support/reference_fixtures.dart';

void main() {
  tearDown(() => Get.reset());

  for (final keyboardHeight in [0.0, 280.0]) {
    testWidgets(
      'long AI answer scrolls both ways with keyboard inset $keyboardHeight',
      (tester) async {
        tester.view.physicalSize = const Size(393, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.viewInsets = FakeViewPadding(bottom: keyboardHeight);
        addTearDown(tester.view.resetViewInsets);
        final controller = Get.put(
          AssistantController(
            GeminiAssistantService(MemoryStore(), defaultApiKey: 'test-only'),
          ),
        );
        controller.messages.add(
          ChatMessage(
            text: List.generate(
              80,
              (index) => 'Step $index: Make time for your priorities.',
            ).join('\n'),
            sender: MessageSender.assistant,
            timestamp: DateTime(2026),
          ),
        );
        await tester.pumpWidget(const GetMaterialApp(home: AssistantScreen()));
        await tester.pumpAndSettle();
        final list = tester.widget<ListView>(find.byType(ListView));
        final start = list.controller!.offset;
        final viewport = tester.getRect(find.byType(ListView));
        await tester.dragFrom(viewport.center, const Offset(0, -120));
        await tester.pumpAndSettle();
        expect(list.controller!.offset, greaterThan(start));
        final lower = list.controller!.offset;
        await tester.dragFrom(viewport.center, const Offset(0, 100));
        await tester.pumpAndSettle();
        expect(list.controller!.offset, lessThan(lower));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
