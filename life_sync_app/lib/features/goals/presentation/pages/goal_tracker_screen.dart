import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/widgets/app_empty_view.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';

class GoalTrackerScreen extends StatelessWidget {
  const GoalTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Obx(() {
          final view = controller.state.value;
          if (view.status == ViewStatus.initial ||
              view.status == ViewStatus.loading) {
            return const AppLoadingView(message: 'Loading goals…');
          }
          if (view.status == ViewStatus.error && view.data == null) {
            return AppErrorView(
              message: view.exception?.message ?? 'Goals could not be loaded.',
              onRetry: controller.loadGoals,
            );
          }
          return RefreshIndicator(
            onRefresh: () => controller.loadGoals(refresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Goals',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2979FF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Turn your intentions into progress.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        FilledButton.icon(
                          onPressed: () =>
                              Get.toNamed<void>(AppRoutes.goalEditor),
                          icon: const Icon(Icons.add, size: 17),
                          label: const Text('New'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _Overview(controller: controller),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Text(
                      'Goals Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                if (controller.goals.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      title: 'No goals yet',
                      message:
                          'Define a measurable goal and start tracking progress.',
                      icon: Icons.flag_outlined,
                      actionLabel: 'Create goal',
                      onAction: () => Get.toNamed<void>(AppRoutes.goalEditor),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList.separated(
                      itemCount: controller.goals.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _GoalCard(
                        goal: controller.goals[index],
                        controller: controller,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.controller});
  final GoalController controller;
  @override
  Widget build(BuildContext context) {
    final percent = (controller.overallProgress * 100).round();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: controller.overallProgress,
                        strokeWidth: 9,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF2979FF),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Overall Progress',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _StatRow(
                      label: 'Active Goals',
                      value: '${controller.activeGoals.length}',
                      color: const Color(0xFF2979FF),
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'Completed',
                      value: '${controller.completedCount}',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'Archived',
                      value: '${controller.archivedCount}',
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.controller});
  final GoalModel goal;
  final GoalController controller;
  @override
  Widget build(BuildContext context) {
    final milestoneItems =
        controller.milestones[goal.id] ?? const <GoalMilestoneModel>[];
    final completedMilestones = milestoneItems
        .where((item) => item.completed)
        .length;
    final status = goal.completed
        ? 'Completed'
        : goal.archived
        ? 'Archived'
        : '${goal.deadline.difference(DateTime.now()).inDays.clamp(0, 9999)} Days Left';
    final statusColor = goal.completed
        ? Colors.green
        : goal.archived
        ? Colors.grey
        : const Color(0xFF2979FF);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Get.toNamed<void>(AppRoutes.goalDetails, arguments: goal),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: goal.completed
                ? Colors.green.shade200
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.flag_outlined,
                    color: Color(0xFF2979FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    goal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onSelected: (value) => _action(context, value),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    if (!goal.completed)
                      const PopupMenuItem(
                        value: 'complete',
                        child: Text('Complete'),
                      ),
                    if (!goal.archived)
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive'),
                      ),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.description?.isNotEmpty == true
                        ? goal.description!
                        : 'Target: ${goal.targetAmount.format()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Due ${_date(goal.deadline)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.currentAmount.format()} of ${goal.targetAmount.format()}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '$completedMilestones/${milestoneItems.length} Milestones',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Get.toNamed<void>(AppRoutes.goalDetails, arguments: goal),
                child: const Text(
                  'View Detail',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _action(BuildContext context, String action) async {
    if (action == 'edit') {
      Get.toNamed<void>(AppRoutes.goalEditor, arguments: goal);
      return;
    }
    if (action == 'complete') {
      await controller.completeGoal(goal);
      return;
    }
    if (action == 'archive') {
      await controller.archiveGoal(goal);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete goal?'),
        content: const Text(
          'Its milestones and schedules will also be deleted.',
        ),
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
      await controller.deleteGoal(goal.id);
    }
  }
}

String _date(DateTime value) => '${value.day}/${value.month}/${value.year}';
