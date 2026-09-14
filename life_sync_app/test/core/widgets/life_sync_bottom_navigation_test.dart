
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/theme/app_theme.dart';
import 'package:life_sync_app/core/widgets/life_sync_bottom_navigation.dart';

void main() {
  testWidgets('uses real blur without a solid white navigation rectangle', (
    tester,
  ) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          extendBody: true,
          bottomNavigationBar: LifeSyncBottomNavigation(
            currentIndex: selected,
            onTabSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    final boxes = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(boxes.where((box) => box.color == Colors.white), isEmpty);

    await tester.tap(find.text('Goal'));
    expect(selected, 1);
  });
}
