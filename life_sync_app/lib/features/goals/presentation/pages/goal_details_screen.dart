import 'package:flutter/material.dart';
import 'package:life_sync_app/features/goals/presentation/widgets/milestone_editor_sheet.dart';
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
            title: 'Goal'.tr,
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
      backgroundColor: colors.cardSurface,
      body: SafeArea(
        child: Obx(() {
          final goal =
              _controller.goals.firstWhereOrNull(
                (item) => item.id == _initial.id,
              ) ??
              _initial;
          final milestones =
              _controller.milestones[goal.id] ?? <GoalMilestoneModel>[];
          final schedules =
              _controller.schedules[goal.id] ?? <GoalScheduleModel>[];
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
                                PopupMenuItem(
                                  value: 'complete',
                                  child: Text('Complete goal'.tr),
                                ),
                              if (!goal.archived)
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Archive goal'.tr),
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
                      color: colors.inputSurface,
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
                          'Goal Progress'.tr,
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
                                label: 'Milestones'.tr,
                                value:
                                    '$completeMilestones/${milestones.length}',
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Schedules'.tr,
                                value:
                                    '${schedules.where((item) => item.completed).length}/${schedules.length}',
                              ),
                            ),
                            Expanded(
                              child: _Metric(
                                label: 'Status'.tr,
                                value: goal.completed
                                    ? 'Complete'.tr
                                    : goal.archived
                                    ? 'Archived'.tr
                                    : 'Active'.tr,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Milestones'.tr,
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
                    _InlineEmpty(
                      message: 'No milestones yet.',
                      svgAsset: LifeSyncSvgAssets.goalChecklist,
                    )
                  else
                    for (final milestone in milestones) ...[
                      _MilestoneCard(
                        item: milestone,
                        index: milestones.indexOf(milestone) + 1,
                        controller: _controller,
                        onEdit: () =>
                            _milestoneDialog(goal.id, existing: milestone),
                      ),
                      const SizedBox(height: 10),
                    ],
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Contribution Schedule'.tr,
                    action: 'Add Schedule',
                    onTap: () => _scheduleDialog(goal.id),
                  ),
                  const SizedBox(height: 12),
                  if (schedules.isEmpty)
                    _InlineEmpty(message: 'No scheduled contributions yet.')
                  else
                    for (final schedule in schedules) ...[
                      _ScheduleCard(
                        item: schedule,
                        controller: _controller,
                        onEdit: () =>
                            _scheduleDialog(goal.id, existing: schedule),
                      ),
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
    bool success = false;
    if (action == 'complete') {
      success = await _controller.completeGoal(goal);
    } else if (action == 'archive') {
      success = await _controller.archiveGoal(goal);
    }
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (_controller.errorMessage.value ?? 'Unable to update goal.').tr,
          ),
        ),
      );
    }
  }

  Future<void> _milestoneDialog(
    int goalId, {
    GoalMilestoneModel? existing,
  }) async {
    final goal =
        _controller.goals.firstWhereOrNull((item) => item.id == goalId) ??
        _initial;
    final start = goal.createdAt ?? DateTime.now();
    final firstDate = DateTime(start.year, start.month, start.day);
    final lastDate = DateTime(
      goal.deadline.year,
      goal.deadline.month,
      goal.deadline.day,
    );
    if (lastDate.isBefore(firstDate)) return;
    final input = await showModalBottomSheet<MilestoneDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => MilestoneEditorSheet(
        original: existing == null
            ? null
            : MilestoneDraft(existing.title, existing.targetDate),
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
    if (input == null) return;
    final success = existing == null
        ? await _controller.createMilestone(goalId, input.title, input.date)
        : await _controller.updateMilestone(existing, input.title, input.date);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (_controller.errorMessage.value ?? 'Unable to save milestone.').tr,
          ),
        ),
      );
    }
  }

  Future<void> _scheduleDialog(
    int goalId, {
    GoalScheduleModel? existing,
  }) async {
    final amount = TextEditingController(
      text: existing?.amount.toApiString() ?? '',
    );
    var date =
        existing?.scheduleDate ?? DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            (existing == null ? 'Add contribution' : 'Edit contribution').tr,
          ),
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
                decoration: InputDecoration(
                  labelText: 'Amount'.tr,
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
                    firstDate: date.isBefore(DateTime.now())
                        ? date
                        : DateTime.now(),
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
              child: Text('Cancel'.tr),
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
                    SnackBar(content: Text('Enter a valid amount.'.tr)),
                  );
                }
              },
              child: Text('Save'.tr),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      final success = existing == null
          ? await _controller.createSchedule(
              goalId,
              date,
              MoneyAmount.parse(amount.text),
            )
          : await _controller.updateSchedule(
              existing,
              date,
              MoneyAmount.parse(amount.text),
            );
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (_controller.errorMessage.value ??
                      'Unable to update contribution.')
                  .tr,
            ),
          ),
        );
      }
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
    required this.index,
  });
  final GoalMilestoneModel item;
  final GoalController controller;
  final VoidCallback onEdit;
  final int index;
  Future<void> _action(BuildContext context, bool delete) async {
    if (delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete milestone?'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'.tr),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'.tr),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    final success = delete
        ? await controller.deleteMilestone(item)
        : await controller.completeMilestone(item);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (controller.errorMessage.value ?? 'Unable to save milestone.').tr,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: Container(
            width: 34,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.completed ? colors.primaryBlue : colors.cardSurface,
              border: Border.all(color: colors.primaryBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$index'.padLeft(2, '0'),
              style: TextStyle(
                color: item.completed ? Colors.white : colors.primaryBlue,
              ),
            ),
          ),
          title: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          subtitle: Text(
            '${(item.completed ? 'Completed' : 'Upcoming').tr} · ${MaterialLocalizations.of(context).formatMediumDate(item.targetDate)}',
            style: TextStyle(
              fontSize: 11,
              color: item.completed ? colors.positive : colors.secondaryText,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 8,
                children: [
                  if (!item.completed)
                    TextButton.icon(
                      onPressed: () => _action(context, false),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text('Complete'.tr),
                    ),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: Text('Edit'.tr),
                  ),
                  TextButton.icon(
                    onPressed: () => _action(context, true),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: colors.negative,
                    ),
                    label: Text('Delete'.tr),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.item,
    required this.controller,
    required this.onEdit,
  });
  final VoidCallback onEdit;
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
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          if (!item.completed)
            IconButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text('Delete contribution?'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: Text('Cancel'.tr),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: Text('Delete'.tr),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) return;
                final success = await controller.deleteSchedule(item);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        (controller.errorMessage.value ??
                                'Unable to delete contribution.')
                            .tr,
                      ),
                    ),
                  );
                }
              },
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
