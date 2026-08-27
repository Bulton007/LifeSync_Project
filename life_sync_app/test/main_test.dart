import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/widgets/startup_page.dart';
import 'package:life_sync_app/main.dart';

void main() {
  setUpAll(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('boots into the secure session restoration gate', (tester) async {
    await tester.pumpWidget(const LifeSyncApp());
    await tester.pump();

    expect(find.byType(StartupPage), findsOneWidget);
  });
}
