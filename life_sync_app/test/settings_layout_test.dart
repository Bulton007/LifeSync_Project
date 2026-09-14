import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/settings_preview.dart';

void main() {
  testWidgets('settings and profile fit a narrow phone and navigate back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SettingsPreview());
    expect(find.text('Settings & Personalization'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('John Steven'));
    await tester.pumpAndSettle();
    expect(find.text('Third Party Connection'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Setting'), findsOneWidget);
  });
}
