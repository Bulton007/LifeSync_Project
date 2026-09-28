import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/widgets/analytics_charts.dart';

void main() {
  testWidgets('donut animates data changes and respects reduced motion', (
    tester,
  ) async {
    Widget chart(double value, {bool reducedMotion = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reducedMotion),
        child: Center(
          child: AnalyticsDonut(
            values: [value, 20],
            colors: const [Colors.blue, Colors.red],
            child: const Text('Total'),
          ),
        ),
      ),
    );
    await tester.pumpWidget(chart(10));
    final animation = find.byType(TweenAnimationBuilder<double>);
    expect(
      tester.widget<TweenAnimationBuilder<double>>(animation).duration,
      const Duration(milliseconds: 650),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpAndSettle();
    await tester.pumpWidget(chart(30));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpAndSettle();
    await tester.pumpWidget(chart(40, reducedMotion: true));
    expect(
      tester.widget<TweenAnimationBuilder<double>>(animation).duration,
      Duration.zero,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
