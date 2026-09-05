import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateGoalReviewPage extends StatelessWidget {
  const CreateGoalReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        // Static UI only.
        leading: const Icon(Icons.arrow_back_ios_new, size: 20),
        title: const Text('Create Goal'),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            _GoalCreationSteps(),
            Expanded(child: _ReviewContent()),
            _BottomActions(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STEP INDICATOR
// ============================================================================

class _GoalCreationSteps extends StatelessWidget {
  const _GoalCreationSteps();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          _StepItem(number: '1', label: 'Define', completed: true),
          _StepLine(active: true),
          _StepItem(number: '2', label: 'Plan', completed: true),
          _StepLine(active: true),
          _StepItem(number: '3', label: 'Review', active: true),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String label;
  final bool active;
  final bool completed;

  const _StepItem({
    required this.number,
    required this.label,
    this.active = false,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = active || completed;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: highlighted ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: highlighted ? AppColors.primary : AppColors.border,
            ),
          ),
          child: completed
              ? const Icon(
                  Icons.check,
                  size: 15,
                  color: AppColors.textOnPrimary,
                )
              : Text(
                  number,
                  style: AppTextStyles.micro.copyWith(
                    color: active
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: highlighted ? AppColors.primary : AppColors.textSecondary,
            fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;

  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          bottom: 18,
        ),
        color: active ? AppColors.primary : AppColors.disabled,
      ),
    );
  }
}

// ============================================================================
// REVIEW CONTENT
// ============================================================================

class _ReviewContent extends StatelessWidget {
  const _ReviewContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _GoalSummaryCard(),
        SizedBox(height: AppSpacing.xl),
        _MilestoneSectionHeader(),
        SizedBox(height: AppSpacing.sm),
        _MilestoneList(),
      ],
    );
  }
}

// ============================================================================
// GOAL SUMMARY
// ============================================================================

class _GoalSummaryCard extends StatelessWidget {
  const _GoalSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Be an Outstanding Student',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Outcome: Get 4.0 GPA on this Semester',
                      style: AppTextStyles.micro,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Expanded(
                child: _DateItem(
                  icon: Icons.calendar_today_outlined,
                  text: 'Started on 1 June 2026',
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DateItem(
                  icon: Icons.event_outlined,
                  text: 'Due 10 Oct 2026',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DateItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// MILESTONES
// ============================================================================

class _MilestoneSectionHeader extends StatelessWidget {
  const _MilestoneSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('Milestones', style: AppTextStyles.titleM)),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.edit_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Edit',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MilestoneList extends StatelessWidget {
  const _MilestoneList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          _ReviewMilestone(
            number: 1,
            title: 'Build Strong Study Routine',
            taskCount: '4 Tasks',
            expanded: true,
            tasks: [
              'Create a weekly study schedule',
              'Review lesson notes every evening',
              'Study for one focused hour',
              'Prepare tomorrow’s materials',
            ],
          ),
          Divider(),
          _ReviewMilestone(
            number: 2,
            title: 'Improve Academic Performance',
            taskCount: '4 Tasks',
          ),
          Divider(),
          _ReviewMilestone(
            number: 3,
            title: 'Prepare for Mid-Term',
            taskCount: '4 Tasks',
          ),
          Divider(),
          _ReviewMilestone(
            number: 4,
            title: 'Prepare for Final',
            taskCount: '4 Tasks',
          ),
        ],
      ),
    );
  }
}

class _ReviewMilestone extends StatelessWidget {
  final int number;
  final String title;
  final String taskCount;
  final bool expanded;
  final List<String> tasks;

  const _ReviewMilestone({
    required this.number,
    required this.title,
    required this.taskCount,
    this.expanded = false,
    this.tasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.primary200),
                ),
                child: Text(
                  number.toString().padLeft(2, '0'),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.button),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(taskCount, style: AppTextStyles.micro),
                  ],
                ),
              ),
              Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          if (expanded && tasks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                children: [
                  for (int index = 0; index < tasks.length; index++)
                    _ReviewTask(number: index + 1, title: tasks[index]),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewTask extends StatelessWidget {
  final int number;
  final String title;

  const _ReviewTask({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            '$number.',
            style: AppTextStyles.micro.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(title, style: AppTextStyles.caption)),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTTOM ACTIONS
// ============================================================================

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              // Static UI only.
              onPressed: () {},
              child: const Text('Back & Edit'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              // Static UI only.
              onPressed: () {},
              child: const Text('Create Goal'),
            ),
          ),
        ],
      ),
    );
  }
}
