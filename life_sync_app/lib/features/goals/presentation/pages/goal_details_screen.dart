import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';

class GoalDetailsScreen extends StatefulWidget {
  const GoalDetailsScreen({super.key});
  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late final GoalController _controller;
  late final GoalModel _initial;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GoalController>();
    final args = Get.arguments;
    if (args is GoalModel) {
      _initial = args;
      _controller.loadDetails(_initial.id);
    } else {
      _initial =
          _controller.goals.firstOrNull ??
          GoalModel(
            id: 0,
            userId: 0,
            title: 'Goal',
            description: '',
            targetAmount: MoneyAmount.zero(),
            currentAmount: MoneyAmount.zero(),
            completed: false,
            archived: false,
            deadline: DateTime.now().add(const Duration(days: 30)),
          );
      if (_initial.id != 0) {
        _controller.loadDetails(_initial.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final goal =
              _controller.goals.firstWhereOrNull(
                (item) => item.id == _initial.id,
              ) ??
              _initial;
          final milestones =
              _controller.milestones[goal.id] ?? const <GoalMilestoneModel>[];
          final schedules =
              _controller.schedules[goal.id] ?? const <GoalScheduleModel>[];
          final completeMilestones = milestones
              .where((item) => item.completed)
              .length;
          return RefreshIndicator(
            onRefresh: () async {
              await _controller.loadGoals(refresh: true);
              await _controller.loadDetails(goal.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.elevatedSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: Get.back,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed<void>(
                              AppRoutes.goalEditor,
                              arguments: goal,
                            ),
                            icon: Icon(
                              Icons.edit_outlined,
                              color: colors.primaryBlue,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) => _goalAction(goal, value),
                            itemBuilder: (_) => [
                              if (!goal.completed)
                                const PopupMenuItem(
                                  value: 'complete',
                                  child: Text('Complete goal'),
                                ),
                              if (!goal.archived)
                                const PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Archive goal'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primaryBlue.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.flag_outlined,
                          color: colors.primaryBlue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryBlue,
                              ),
                            ),
                            if (goal.description?.isNotEmpty == true) ...[
                              const SizedBox(height: 4),
                              Text(
                                goal.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.secondaryText,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      _DateLabel(
                        label: 'Due ${_date(goal.deadline)}',
                        color: colors.primaryBlue,
                      ),
                      _DateLabel(
                        label:
                            'Started ${_date(goal.createdAt ?? DateTime.now())}',
                        color: colors.secondaryText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Goal Progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(goal.progress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${goal.currentAmount.format()} of ${goal.targetAmount.format()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: goal.progress,
                            minHeight: 8,
                            backgroundColor: colors.divider,
                            valueColor: AlwaysStoppedAnimation(
                              colors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _Metric(
                                label: 'Milestones',
                                value:
                                    '$completeMilestones/${milestones.length}',
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Schedules',
                                value:
                                    '${schedules.where((item) => item.completed).length}/${schedules.length}',
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Status',
                                value: goal.completed
                                    ? 'Complete'
                                    : goal.archived
                                    ? 'Archived'
                                    : 'Active',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Milestones',
                    action: 'Add Milestone',
                    onTap: () => _milestoneDialog(goal.id),
                  ),
                  const SizedBox(height: 12),
                  if (_controller.detailsLoading.contains(goal.id) &&
                      milestones.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (milestones.isEmpty)
                    const _InlineEmpty(
                      message: 'No milestones yet.',
                      svgAsset: LifeSyncSvgAssets.goalChecklist,
                    )
                  else
                    for (final milestone in milestones) ...[
                      _MilestoneCard(
                        item: milestone,
                        controller: _controller,
                        onEdit: () =>
                            _milestoneDialog(goal.id, existing: milestone),
                      ),
                      const SizedBox(height: 10),
                    ],
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Contribution Schedule',
                    action: 'Add Schedule',
                    onTap: () => _scheduleDialog(goal.id),
                  ),
                  const SizedBox(height: 12),
                  if (schedules.isEmpty)
                    const _InlineEmpty(
                      message: 'No scheduled contributions yet.',
                    )
                  else
                    for (final schedule in schedules) ...[
                      _ScheduleCard(item: schedule, controller: _controller),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _goalAction(GoalModel goal, String action) async {
    if (action == 'complete') {
      await _controller.completeGoal(goal);
    } else if (action == 'archive') {
      await _controller.archiveGoal(goal);
    }
  }

  Future<void> _milestoneDialog(
    int goalId, {
    GoalMilestoneModel? existing,
  }) async {
    final title = TextEditingController(text: existing?.title ?? '');
    var date =
        existing?.targetDate ?? DateTime.now().add(const Duration(days: 7));
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add milestone' : 'Edit milestone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                maxLength: 100,
                decoration: const InputDecoration(labelText: 'Milestone title'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_date(date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200),
                  );
                  if (picked != null) {
                    setDialogState(() => date = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, title.text.trim().isNotEmpty),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      if (existing == null) {
        await _controller.createMilestone(goalId, title.text, date);
      } else {
        await _controller.updateMilestone(existing, title.text, date);
      }
    }
    title.dispose();
  }

  Future<void> _scheduleDialog(int goalId) async {
    final amount = TextEditingController();
    var date = DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add contribution'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,10}(?:\.\d{0,2})?'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: r'$ ',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_date(date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200),
                  );
                  if (picked != null) {
                    setDialogState(() => date = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                try {
                  Navigator.pop(
                    dialogContext,
                    MoneyAmount.parse(amount.text).minorUnits > BigInt.zero,
                  );
                } on FormatException {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Enter a valid amount.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      await _controller.createSchedule(
        goalId,
        date,
        MoneyAmount.parse(amount.text),
      );
    }
    amount.dispose();
  }
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.calendar_today_outlined, size: 14, color: color),
      const SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: colors.secondaryText),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add, size: 14),
          label: Text(action, style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.message, this.svgAsset});
  final String message;
  final String? svgAsset;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgAsset != null) ...[
            SvgPicture.asset(svgAsset!, height: 110, fit: BoxFit.contain),
            const SizedBox(height: 12),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.item,
    required this.controller,
    required this.onEdit,
  });
  final GoalMilestoneModel item;
  final GoalController controller;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.completed
              ? colors.positive.withValues(alpha: .55)
              : colors.border,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: item.completed
                ? null
                : () => controller.completeMilestone(item),
            icon: Icon(
              item.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: item.completed ? colors.positive : colors.secondaryText,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: item.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  'Target ${_date(item.targetDate)}',
                  style: TextStyle(fontSize: 10, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
          ),
          IconButton(
            onPressed: () => controller.deleteMilestone(item),
            icon: Icon(Icons.delete_outline, size: 18, color: colors.negative),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.item, required this.controller});
  final GoalScheduleModel item;
  final GoalController controller;
  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.completed
              ? colors.positive.withValues(alpha: .55)
              : colors.border,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: item.completed
                ? null
                : () => controller.completeSchedule(item),
            icon: Icon(
              item.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: item.completed ? colors.positive : colors.secondaryText,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.amount.format(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Scheduled ${_date(item.scheduleDate)}',
                  style: TextStyle(fontSize: 10, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          if (!item.completed)
            IconButton(
              onPressed: () => controller.deleteSchedule(item),
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: colors.negative,
              ),
            ),
        ],
      ),
    );
  }
}

String _date(DateTime value) => '${value.day}/${value.month}/${value.year}';
