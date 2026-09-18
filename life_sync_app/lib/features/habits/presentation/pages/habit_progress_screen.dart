import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';

class HabitProgressScreen extends StatefulWidget {
  const HabitProgressScreen({super.key});

  @override
  State<HabitProgressScreen> createState() => _HabitProgressScreenState();
}

class _HabitProgressScreenState extends State<HabitProgressScreen> {
  late final HabitController _controller;
  late final HabitModel _initialHabit;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HabitController>();
    final args = Get.arguments;
    if (args is HabitModel) {
      _initialHabit = args;
    } else {
      _initialHabit =
          _controller.habits.firstOrNull ??
          HabitModel(
            habitId: 0,
            userId: 0,
            name: 'Habit',
            frequency: 'DAILY',
            streak: 0,
            active: true,
            createdAt: DateTime.now(),
          );
    }
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Obx(() {
          final habit =
              _controller.habits.firstWhereOrNull(
                (item) => item.habitId == _initialHabit.habitId,
              ) ??
              _initialHabit;
          final history = _controller.historyFor(habit.habitId);
          final completedDates = history
              .map((log) => _dateKey(log.completedDate))
              .toSet();
          final scheduledDays = _scheduledDaysInMonth(habit, _visibleMonth);
          final completedInMonth = scheduledDays
              .where((date) => completedDates.contains(_dateKey(date)))
              .length;
          final skipped = scheduledDays
              .where(
                (date) =>
                    date.isBefore(_today()) &&
                    !completedDates.contains(_dateKey(date)),
              )
              .length;
          return RefreshIndicator(
            onRefresh: () => _controller.loadHabits(refresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.autorenew,
                          color: colors.primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Get.toNamed<void>(
                          AppRoutes.habitEditor,
                          arguments: habit,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: colors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colors.secondaryText,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Started on ${_formatDate(habit.startDate ?? habit.createdAt ?? DateTime.now())}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (habit.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 10),
                    Text(
                      habit.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: const Text(
                            '🔥',
                            style: TextStyle(fontSize: 14),
                          ),
                          label: 'Current streak',
                          value: '${habit.streak}',
                          suffix: 'Days',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: 'Total completed',
                          value: '${history.length}',
                          suffix: 'Days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: const Icon(
                            Icons.done_all,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: 'This month',
                          value: '$completedInMonth',
                          suffix: 'Days',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: const Icon(
                            Icons.trending_flat,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: 'Skipped',
                          value: '$skipped',
                          suffix: 'Days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_visibleMonth.year}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryBlue,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _monthName(_visibleMonth.month),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              size: 18,
                              color: colors.primaryBlue,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => setState(
                              () => _visibleMonth = DateTime(
                                _visibleMonth.year,
                                _visibleMonth.month - 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: colors.primaryBlue,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => setState(
                              () => _visibleMonth = DateTime(
                                _visibleMonth.year,
                                _visibleMonth.month + 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _CalendarGrid(
                    month: _visibleMonth,
                    habit: habit,
                    completedDates: completedDates,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Completion history',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (history.isEmpty)
                    Text(
                      'No completions recorded yet.',
                      style: TextStyle(fontSize: 12, color: colors.secondaryText),
                    )
                  else
                    for (final log in history.take(12))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.check_circle,
                          color: colors.primaryBlue,
                          size: 20,
                        ),
                        title: Text(
                          _formatDate(log.completedDate),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.primaryText,
                          ),
                        ),
                        subtitle: log.note.isEmpty
                            ? null
                            : Text(
                                log.note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colors.secondaryText),
                              ),
                      ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _backButton() {
    final colors = context.lifeSyncColors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardSurface,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
        ),
        child: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.primaryText),
          onPressed: Get.back,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
  });
  final Widget icon;
  final String label;
  final String value;
  final String suffix;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$value ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),
                  TextSpan(
                    text: suffix,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.habit,
    required this.completedDates,
  });
  final DateTime month;
  final HabitModel habit;
  final Set<String> completedDates;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final first = DateTime(month.year, month.month);
    final leading = first.weekday - 1;
    final count = DateTime(month.year, month.month + 1, 0).day;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['m', 't', 'w', 't', 'f', 's', 's']
                .map(
                  (day) => Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.secondaryText,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: leading + count,
            itemBuilder: (_, index) {
              if (index < leading) return const SizedBox.shrink();
              final date = DateTime(
                month.year,
                month.month,
                index - leading + 1,
              );
              final done = completedDates.contains(_dateKey(date));
              final scheduled = habit.isScheduledFor(date);
              return Center(
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: scheduled && !done
                        ? Border.all(
                            color: colors.primaryBlue.withValues(alpha: 0.3),
                          )
                        : null,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: done ? FontWeight.bold : FontWeight.w500,
                      color: done
                          ? Colors.white
                          : scheduled
                          ? colors.primaryText
                          : colors.secondaryText.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<DateTime> _scheduledDaysInMonth(HabitModel habit, DateTime month) {
  final last = DateTime(month.year, month.month + 1, 0).day;
  return [
        for (var day = 1; day <= last; day++)
          DateTime(month.year, month.month, day),
      ]
      .where((date) => habit.isScheduledFor(date) && !date.isAfter(_today()))
      .toList();
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String _dateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';
String _monthName(int month) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][month - 1];
String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
