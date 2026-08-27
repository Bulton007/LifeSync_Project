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
    _initialHabit = Get.arguments as HabitModel;
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
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
                          color: const Color(0xFFE8F1FC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.autorenew,
                          color: Color(0xFF1E88E5),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Color(0xFF1E88E5),
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
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Started on ${_formatDate(habit.startDate ?? habit.createdAt ?? DateTime.now())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
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
                        color: Colors.grey.shade700,
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
                            color: Color(0xFF1E88E5),
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
                            color: Color(0xFF1E88E5),
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
                            color: Color(0xFF1E88E5),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _monthName(_visibleMonth.month),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 18,
                              color: Color(0xFF1E88E5),
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
                            icon: const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Color(0xFF1E88E5),
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
                  const Text(
                    'Completion history',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (history.isEmpty)
                    const Text(
                      'No completions recorded yet.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    for (final log in history.take(12))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF1E88E5),
                          size: 20,
                        ),
                        title: Text(
                          _formatDate(log.completedDate),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: log.note.isEmpty
                            ? null
                            : Text(
                                log.note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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

  Widget _backButton() => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black87),
        onPressed: Get.back,
      ),
    ),
  );
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                text: suffix,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
    final first = DateTime(month.year, month.month);
    final leading = first.weekday - 1;
    final count = DateTime(month.year, month.month + 1, 0).day;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.04),
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
                      color: Colors.grey,
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
                    color: done ? const Color(0xFF1E88E5) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: scheduled && !done
                        ? Border.all(color: Colors.blue.shade100)
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
                          ? Colors.black87
                          : Colors.grey.shade300,
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
