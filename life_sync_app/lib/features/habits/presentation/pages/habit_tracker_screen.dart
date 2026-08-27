import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/widgets/app_empty_view.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Obx(() {
          final view = controller.state.value;
          if (view.status == ViewStatus.loading ||
              view.status == ViewStatus.initial) {
            return const AppLoadingView(message: 'Loading habits…');
          }
          if (view.status == ViewStatus.error && view.data == null) {
            return AppErrorView(
              message: view.exception?.message ?? 'Habits could not be loaded.',
              onRetry: controller.loadHabits,
            );
          }
          return RefreshIndicator(
            onRefresh: () => controller.loadHabits(refresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _Header(controller: controller)),
                if (controller.habits.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      title: 'No habits yet',
                      message: 'Create a habit to start tracking your routine.',
                      icon: Icons.autorenew,
                      actionLabel: 'Add habit',
                      onAction: () => Get.toNamed<void>(AppRoutes.habitEditor),
                    ),
                  )
                else if (controller.scheduledHabits.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      title: 'Nothing scheduled',
                      message: 'There are no habits scheduled for this day.',
                      icon: Icons.event_available_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList.separated(
                      itemCount: controller.scheduledHabits.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final habit = controller.scheduledHabits[index];
                        return _HabitCard(habit: habit, controller: controller);
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed<void>(AppRoutes.habitEditor),
        backgroundColor: const Color(0xFF2979FF),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final HabitController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedDate.value;
    final weekStart = selected.subtract(Duration(days: selected.weekday % 7));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(icon: Icons.chevron_left, onTap: Get.back),
              Column(
                children: [
                  Text(
                    '${selected.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _monthName(selected.month),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              _CircleButton(
                icon: Icons.calendar_today_outlined,
                color: const Color(0xFF1E88E5),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selected,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.selectDate(picked);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));
              final selectedDay = _sameDate(date, selected);
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => controller.selectDate(date),
                child: Column(
                  children: [
                    Text(
                      const ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedDay
                            ? const Color(0xFF1E88E5)
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedDay
                            ? const Color(0xFF1E88E5)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: selectedDay ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Habit Tracker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit, required this.controller});
  final HabitModel habit;
  final HabitController controller;

  @override
  Widget build(BuildContext context) {
    final done = controller.isCompletedOn(
      habit.habitId,
      controller.selectedDate.value,
    );
    return Opacity(
      opacity: habit.active ? 1 : 0.58,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.autorenew,
                color: Color(0xFF1E88E5),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => Get.toNamed<void>(
                  AppRoutes.habitProgress,
                  arguments: habit,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      habit.active ? '🔥 ${habit.streak} day streak' : 'Paused',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => TextButton.icon(
                onPressed:
                    done || !habit.active || controller.isSubmitting.value
                    ? null
                    : () async {
                        final ok = await controller.recordCompletion(
                          habit,
                          controller.selectedDate.value,
                        );
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                controller.errorMessage.value ??
                                    'Could not record completion.',
                              ),
                            ),
                          );
                        }
                      },
                style: TextButton.styleFrom(
                  backgroundColor: done
                      ? const Color(0xFFE8F1FC)
                      : Colors.white,
                  side: BorderSide(
                    color: done ? Colors.transparent : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Icon(
                  Icons.check,
                  size: 14,
                  color: done ? const Color(0xFF1E88E5) : Colors.grey,
                ),
                label: Text(
                  done ? 'Done' : 'Complete',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: done ? const Color(0xFF1E88E5) : Colors.grey,
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              onSelected: (value) => _handleAction(context, value),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'active',
                  child: Text(habit.active ? 'Pause' : 'Resume'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, String action) async {
    if (action == 'edit') {
      Get.toNamed<void>(AppRoutes.habitEditor, arguments: habit);
      return;
    }
    if (action == 'active') {
      final ok = await controller.setActive(habit, !habit.active);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.errorMessage.value ?? 'Could not update habit.',
            ),
          ),
        );
      }
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete habit?'),
        content: const Text('Its completion history will also be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final ok = await controller.deleteHabit(habit.habitId);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.errorMessage.value ?? 'Could not delete habit.',
            ),
          ),
        );
      }
    }
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.black87,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: IconButton(
      icon: Icon(icon, color: color),
      onPressed: onTap,
    ),
  );
}

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
bool _sameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
