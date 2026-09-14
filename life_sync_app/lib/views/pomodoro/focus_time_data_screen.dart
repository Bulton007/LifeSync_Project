import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';

final class FocusTimeDataScreen extends StatelessWidget {
  const FocusTimeDataScreen({super.key});

  String _duration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }

  String _periodLabel(FocusController controller) {
    final date = controller.periodAnchor.value;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return switch (controller.period.value) {
      FocusPeriod.month => '${months[date.month - 1]} ${date.year}',
      FocusPeriod.quarter => 'Q${((date.month - 1) ~/ 3) + 1} ${date.year}',
      FocusPeriod.year => '${date.year}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FocusController>();
    final colors = context.lifeSyncColors;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back<void>,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        title: const Text('Focus Statistics'),
        actions: [
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<FocusPeriod>(
                value: controller.period.value,
                borderRadius: BorderRadius.circular(12),
                items: FocusPeriod.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.name.capitalizeFirst!),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) controller.period.value = value;
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadSessions,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Pomodoro',
                      value: '${controller.totalPomodoros}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'Total Focus Time',
                      value: _duration(controller.totalFocusSeconds),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview Trends',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        IconButton(
                          tooltip: 'Previous period',
                          onPressed: controller.previousPeriod,
                          icon: const Icon(Icons.chevron_left, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            _periodLabel(controller),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.primaryBlue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Next period',
                          onPressed: controller.nextPeriod,
                          icon: const Icon(Icons.chevron_right, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final values = controller.dailySeconds;
                    if (controller.isLoading.value && values.isEmpty) {
                      return const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (values.isEmpty) {
                      return SizedBox(
                        height: 180,
                        child: Center(
                          child: Text(
                            'Complete a focus session to see your trend.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colors.secondaryText),
                          ),
                        ),
                      );
                    }
                    final ordered = values.entries.toList()
                      ..sort((a, b) => a.key.compareTo(b.key));
                    return SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _FocusChartPainter(
                          values: ordered.map((entry) => entry.value).toList(),
                          bar: colors.primaryBlue,
                          grid: colors.chartGrid,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Obx(() {
              final history = controller.filteredSessions.take(12).toList();
              if (history.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: history
                      .map(
                        (session) => ListTile(
                          leading: Icon(
                            session.mode.name == 'pomodoro'
                                ? Icons.timer_outlined
                                : Icons.speed_outlined,
                            color: colors.primaryBlue,
                          ),
                          title: Text(
                            session.taskName ??
                                session.mode.name.capitalizeFirst!,
                          ),
                          subtitle: Text(
                            '${session.startedAt.month}/${session.startedAt.day}/${session.startedAt.year}',
                          ),
                          trailing: Text(_duration(session.durationSeconds)),
                        ),
                      )
                      .toList(growable: false),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

final class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: colors.secondaryText, fontSize: 10),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: colors.primaryBlue,
              fontSize: 23,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

final class _FocusChartPainter extends CustomPainter {
  const _FocusChartPainter({
    required this.values,
    required this.bar,
    required this.grid,
  });
  final List<int> values;
  final Color bar;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var index = 0; index < 4; index++) {
      final y = size.height * index / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final maxValue = math.max(1, values.reduce(math.max));
    final gap = 4.0;
    final width = math.max(
      3.0,
      (size.width - gap * (values.length - 1)) / values.length,
    );
    final paint = Paint()
      ..color = bar
      ..style = PaintingStyle.fill;
    for (var index = 0; index < values.length; index++) {
      final height = size.height * values[index] / maxValue;
      final left = index * (width + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, size.height - height, width, height),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FocusChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.bar != bar ||
      oldDelegate.grid != grid;
}
