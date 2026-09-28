import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

class ChartSeries {
  const ChartSeries(this.label, this.values, this.color);
  final String label;
  final List<double> values;
  final Color color;
}

class AnalyticsBarChart extends StatelessWidget {
  const AnalyticsBarChart({
    required this.labels,
    required this.series,
    this.unit = '',
    super.key,
  });
  final List<String> labels;
  final List<ChartSeries> series;
  final String unit;

  @override
  Widget build(BuildContext context) => Semantics(
    label: series
        .map(
          (item) =>
              '${item.label}: ${item.values.fold<double>(0, (sum, value) => sum + value).toStringAsFixed(1)} $unit',
        )
        .join(', '),
    child: SizedBox(
      height: 205,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(
          '${labels.join('|')}:${series.map((item) => '${item.label}:${item.values.join(',')}').join('|')}',
        ),
        tween: Tween(begin: 0, end: 1),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        builder: (context, progress, child) => CustomPaint(
          painter: _BarsPainter(
            labels,
            series,
            unit,
            Theme.of(context).colorScheme.onSurfaceVariant,
            context.lifeSyncColors.chartGrid,
            Directionality.of(context),
            progress,
          ),
        ),
      ),
    ),
  );
}

class _BarsPainter extends CustomPainter {
  _BarsPainter(
    this.labels,
    this.series,
    this.unit,
    this.textColor,
    this.grid,
    this.direction,
    this.progress,
  );
  final List<String> labels;
  final List<ChartSeries> series;
  final String unit;
  final Color textColor;
  final Color grid;
  final TextDirection direction;
  final double progress;

  void _text(Canvas canvas, String text, Offset offset, {bool center = false}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: 9),
      ),
      textDirection: direction,
    )..layout(maxWidth: 58);
    painter.paint(
      canvas,
      center ? offset - Offset(painter.width / 2, 0) : offset,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final values = series
        .expand((item) => item.values)
        .where((value) => value.isFinite);
    final maximum = values.fold<double>(0, math.max);
    final minimum = values.fold<double>(0, math.min);
    final extent = math.max(1.0, math.max(maximum, minimum.abs()));
    final magnitude = math
        .pow(10, (math.log(extent) / math.ln10).floor())
        .toDouble();
    final top = (extent / magnitude).ceil() * magnitude;
    final bottom = minimum < 0 ? -top : 0.0;
    final plot = Rect.fromLTWH(
      44,
      12,
      math.max(1, size.width - 48),
      size.height - 40,
    );
    double position(double value) =>
        plot.bottom - (value - bottom) / (top - bottom) * plot.height;
    final paint = Paint()
      ..color = grid.withValues(alpha: .5)
      ..strokeWidth = 1;
    for (var index = 0; index <= 4; index++) {
      final value = bottom + (top - bottom) * index / 4;
      final height = position(value);
      canvas.drawLine(
        Offset(plot.left, height),
        Offset(plot.right, height),
        paint,
      );
      final number = value.abs() >= 1000
          ? '${(value / 1000).toStringAsFixed(1)}k'
          : value.toStringAsFixed(
              value.abs() < 10 && value != value.roundToDouble() ? 1 : 0,
            );
      _text(
        canvas,
        '$number${unit.isEmpty ? '' : ' $unit'}',
        Offset(0, height - 5),
      );
    }
    if (labels.isEmpty || series.isEmpty) return;
    final slot = plot.width / labels.length;
    final groupWidth = slot * .7;
    final width = groupWidth / series.length;
    final labelEvery = math.max(1, (labels.length / 6).ceil());
    for (var index = 0; index < labels.length; index++) {
      final center = plot.left + slot * (index + .5);
      if (index % labelEvery == 0 || index == labels.length - 1) {
        _text(
          canvas,
          labels[index],
          Offset(center, plot.bottom + 8),
          center: true,
        );
      }
      for (var seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
        final item = series[seriesIndex];
        final value = index < item.values.length ? item.values[index] : 0.0;
        if (!value.isFinite || value == 0) continue;
        final zero = position(0);
        final end = position(value * progress);
        final rect = Rect.fromLTRB(
          center - groupWidth / 2 + seriesIndex * width,
          math.min(zero, end),
          center -
              groupWidth / 2 +
              (seriesIndex + 1) * width -
              math.min(2, width * .15),
          math.max(zero, end),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = item.color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) => true;
}

class AnalyticsDonut extends StatelessWidget {
  const AnalyticsDonut({
    required this.values,
    required this.colors,
    required this.child,
    super.key,
  });
  final List<double> values;
  final List<Color> colors;
  final Widget child;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 132,
    height: 132,
    child: TweenAnimationBuilder<double>(
      key: ValueKey(values.join(',')),
      tween: Tween(begin: 0, end: 1),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) => CustomPaint(
        painter: _DonutPainter(
          values,
          colors,
          Theme.of(context).dividerColor,
          progress,
        ),
        child: child,
      ),
      child: Center(
        child: Padding(padding: const EdgeInsets.all(22), child: child),
      ),
    ),
  );
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.values, this.colors, this.background, this.progress);
  final double progress;
  final List<double> values;
  final List<Color> colors;
  final Color background;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(10);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawOval(rect, paint..color = background);
    final total = values.fold<double>(
      0,
      (sum, value) => sum + math.max(0, value),
    );
    if (total <= 0 || colors.isEmpty) return;
    var angle = -math.pi / 2;
    for (var index = 0; index < values.length; index++) {
      final sweep = math.max(0, values[index]) / total * math.pi * 2 * progress;
      if (sweep > 0) {
        canvas.drawArc(
          rect,
          angle + .015,
          math.max(0, sweep - .03),
          false,
          paint..color = colors[index % colors.length],
        );
      }
      angle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
