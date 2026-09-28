import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/home/presentation/widgets/daily_progress_indicator.dart';

void main() {
  testWidgets('ring, percentage and emoji follow daily completion changes', (
    tester,
  ) async {
    Future<void> show(int completed, int total) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DailyProgressIndicator(
            completed: completed,
            total: total,
            color: Colors.blue,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );

    for (final scenario in [
      (0, 0, '🌱', '0%', 0.0),
      (0, 4, '💪', '0%', 0.0),
      (1, 4, '🙂', '25%', 0.25),
      (2, 4, '😄', '50%', 0.5),
      (4, 4, '🥳', '100%', 1.0),
      (1, 4, '🙂', '25%', 0.25),
      (5, 4, '🥳', '100%', 1.0),
      (0, 0, '🌱', '0%', 0.0),
    ]) {
      await show(scenario.$1, scenario.$2);
      expect(find.text(scenario.$3), findsOneWidget);
      expect(find.text(scenario.$4), findsOneWidget);
      expect(
        tester
            .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator),
            )
            .value,
        scenario.$5,
      );
      expect(tester.takeException(), isNull);
    }
  });
}
