import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/widgets/startup_page.dart';
import 'package:life_sync_app/main.dart';

void main() {
  setUpAll(() {
    Get.testMode = true;
    configureAppErrorHandling();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('boots into the secure session restoration gate', (tester) async {
    await tester.pumpWidget(const LifeSyncApp());
    await tester.pump();

    expect(find.byType(StartupPage), findsOneWidget);
  });

  testWidgets('renders graceful recovery view when a widget throws', (tester) async {
    final widget = ErrorWidget.builder(
      FlutterErrorDetails(exception: Exception('Test error')),
    );
    await tester.pumpWidget(GetMaterialApp(home: widget));
    expect(find.text('Something unexpected happened'), findsOneWidget);
    expect(find.text('Return to Home'), findsOneWidget);
  });
}
