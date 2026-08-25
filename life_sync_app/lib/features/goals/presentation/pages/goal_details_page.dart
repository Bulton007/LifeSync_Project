import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalDetailsPage extends StatelessWidget {
  const GoalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        // Static UI only.
        leading: const Icon(Icons.arrow_back_ios_new, size: 20),
        title: const Text('Goal Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            _GoalSummaryCard(),
            SizedBox(height: AppSpacing.xl),
            _MilestonesHeader(),
            SizedBox(height: AppSpacing.sm),
            _MilestonesCard(),
          ],
        ),
      ),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.primary100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GoalIdentity(),
          const SizedBox(height: AppSpacing.md),
          const _GoalDateInformation(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Goal Progress',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '38%',
            style: AppTextStyles.titleL.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const LinearProgressIndicator(
              value: 0.38,
              minHeight: 7,
              backgroundColor: AppColors.primary100,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _GoalStatistics(),
        ],
      ),
    );
  }
}

class _GoalIdentity extends StatelessWidget {
  const _GoalIdentity();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: AppColors.primary,
            size: 25,
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
    );
  }
}

class _GoalDateInformation extends StatelessWidget {
  const _GoalDateInformation();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _DateItem(
            icon: Icons.calendar_today_outlined,
            text: 'Started on 1 June 2026',
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DateItem(
            icon: Icons.event_outlined,
            text: 'Due 10 Oct 2026',
          ),
        ),
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DateItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
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

class _GoalStatistics extends StatelessWidget {
  const _GoalStatistics();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _GoalStatistic(
            icon: Icons.flag_outlined,
            label: 'Milestones',
            value: '1/4',
          ),
        ),
        _VerticalDivider(),
        Expanded(
          child: _GoalStatistic(
            icon: Icons.task_alt_outlined,
            label: 'Tasks',
            value: '8/24',
          ),
        ),
        _VerticalDivider(),
        Expanded(
          child: _GoalStatistic(
            icon: Icons.favorite_border,
            label: 'Goal Health',
            value: 'On Track',
            valueColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _GoalStatistic extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _GoalStatistic({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.micro,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      color: AppColors.border,
    );
  }
}

// ============================================================================
// MILESTONES
// ============================================================================

class _MilestonesHeader extends StatelessWidget {
  const _MilestonesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Milestones',
            style: AppTextStyles.titleM,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.sm),
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
                'Edit Milestone',
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

class _MilestonesCard extends StatelessWidget {
  const _MilestonesCard();

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
          _MilestoneTile(
            number: 1,
            title: 'Build Strong Study Routine',
            subtitle: '4/4 Tasks Completed',
            status: 'Completed',
            statusColor: AppColors.success,
            completed: true,
          ),
          Divider(),
          _MilestoneTile(
            number: 2,
            title: 'Improve Academic Performance',
            subtitle: '2/4 Tasks Completed',
            status: 'In Progress',
            statusColor: AppColors.info,
            expanded: true,
            tasks: [
              _MilestoneTask(
                title: 'Review lesson notes',
                completed: true,
              ),
              _MilestoneTask(
                title: 'Complete practice exercise',
                completed: true,
              ),
              _MilestoneTask(
                title: 'Study for one focused hour',
                completed: false,
              ),
              _MilestoneTask(
                title: 'Prepare tomorrow’s materials',
                completed: false,
              ),
            ],
          ),
          Divider(),
          _MilestoneTile(
            number: 3,
            title: 'Prepare for Mid-Term',
            subtitle: '0/4 Tasks Completed',
            status: 'Upcoming',
            statusColor: AppColors.disabledBackground,
          ),
          Divider(),
          _MilestoneTile(
            number: 4,
            title: 'Prepare for Final',
            subtitle: '0/4 Tasks Completed',
            status: 'Upcoming',
            statusColor: AppColors.disabledBackground,
          ),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final bool completed;
  final bool expanded;
  final List<_MilestoneTask> tasks;

  const _MilestoneTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.completed = false,
    this.expanded = false,
    this.tasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.primary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: completed
                        ? AppColors.primary
                        : AppColors.primary200,
                  ),
                ),
                child: completed
                    ? const Icon(
                        Icons.check,
                        size: 17,
                        color: AppColors.textOnPrimary,
                      )
                    : Text(
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
                    Text(subtitle, style: AppTextStyles.micro),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _MilestoneStatusBadge(
                    text: status,
                    color: statusColor,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          if (expanded && tasks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Column(children: tasks),
            ),
          ],
        ],
      ),
    );
  }
}

class _MilestoneTask extends StatelessWidget {
  final String title;
  final bool completed;

  const _MilestoneTask({
    required this.title,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 17,
            color: completed
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: completed
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                decoration:
                    completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneStatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _MilestoneStatusBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}