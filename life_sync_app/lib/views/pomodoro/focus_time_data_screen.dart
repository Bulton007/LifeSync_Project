import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/widgets/analytics_charts.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';

final class FocusTimeDataScreen extends StatelessWidget {
  const FocusTimeDataScreen({super.key});

  String _duration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '@hours h @minutes min'.trParams({
      'hours': '$hours',
      'minutes': '$minutes',
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FocusController>();
    final colors = context.lifeSyncColors;
    final dates = MaterialLocalizations.of(context);
    return Scaffold(
      backgroundColor: colors.cardSurface,
      appBar: AppBar(
        backgroundColor: colors.cardSurface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Back'.tr,
          onPressed: Get.back<void>,
          icon: const Icon(Icons.chevron_left),
        ),
        title: Text(
          'Focus Statistics'.tr,
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final anchor = controller.periodAnchor.value;
        final period = controller.period.value;
        final start = switch (period) {
          FocusPeriod.month => DateTime(anchor.year, anchor.month),
          FocusPeriod.quarter => DateTime(
            anchor.year,
            ((anchor.month - 1) ~/ 3) * 3 + 1,
          ),
          FocusPeriod.year => DateTime(anchor.year),
        };
        final monthCount = period == FocusPeriod.month
            ? 1
            : period == FocusPeriod.quarter
            ? 3
            : 12;
        final end = DateTime(start.year, start.month + monthCount);
        final labels = <String>[];
        final values = <double>[];
        var cursor = start;
        while (cursor.isBefore(end)) {
          final next = period == FocusPeriod.month
              ? DateTime(cursor.year, cursor.month, cursor.day + 1)
              : DateTime(cursor.year, cursor.month + 1);
          labels.add(
            period == FocusPeriod.month ? '${cursor.day}' : '${cursor.month}',
          );
          final seconds = controller.filteredSessions
              .where(
                (session) =>
                    !session.startedAt.isBefore(cursor) &&
                    session.startedAt.isBefore(next),
              )
              .fold<int>(0, (sum, session) => sum + session.durationSeconds);
          values.add(seconds / 60);
          cursor = next;
        }
        final periodLabel = switch (period) {
          FocusPeriod.month => dates.formatMonthYear(start),
          FocusPeriod.quarter =>
            'Q${((start.month - 1) ~/ 3) + 1} · ${start.year}',
          FocusPeriod.year => '${start.year}',
        };
        return RefreshIndicator(
          onRefresh: controller.loadSessions,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Pomodoro'.tr,
                      value: '${controller.totalPomodoros}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'Total Focus Time'.tr,
                      value: _duration(controller.totalFocusSeconds),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
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
                    Wrap(
                      spacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Overview Trends'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<FocusPeriod>(
                          key: const ValueKey('focus-period'),
                          value: period,
                          isDense: true,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.primaryText,
                          ),
                          items: FocusPeriod.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.name.capitalizeFirst!.tr),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.period.value = value;
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Previous period'.tr,
                          onPressed: controller.previousPeriod,
                          icon: const Icon(Icons.chevron_left, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            periodLabel,
                            style: TextStyle(
                              color: colors.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Next period'.tr,
                          onPressed: end.isAfter(DateTime.now())
                              ? null
                              : controller.nextPeriod,
                          icon: const Icon(Icons.chevron_right, size: 20),
                        ),
                      ],
                    ),
                    if (controller.isLoading.value)
                      const SizedBox(
                        height: 205,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      AnalyticsBarChart(
                        labels: labels,
                        series: [
                          ChartSeries('Focus'.tr, values, colors.primaryBlue),
                        ],
                        unit: 'min'.tr,
                      ),
                    if (controller.errorMessage.value != null)
                      TextButton(
                        onPressed: controller.loadSessions,
                        child: Text(
                          'Unable to load focus history. Tap to retry.'.tr,
                        ),
                      )
                    else if (controller.filteredSessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Complete a focus session to see your trend.'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondaryText,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (controller.filteredSessions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Recorded Sessions'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                for (final session in controller.filteredSessions.take(20))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.timer_outlined,
                      color: colors.primaryBlue,
                    ),
                    title: Text(
                      session.taskName ?? session.mode.name.capitalizeFirst!.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(dates.formatMediumDate(session.startedAt)),
                    trailing: Text(
                      _duration(session.durationSeconds),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ],
          ),
        );
      }),
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
        color: colors.inputSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colors.secondaryText),
          ),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: colors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
