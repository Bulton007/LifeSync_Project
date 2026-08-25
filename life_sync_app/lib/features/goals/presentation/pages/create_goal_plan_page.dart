import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateGoalPlanPage extends StatelessWidget {
  /// Use true to preview the empty milestone design.
  final bool showEmptyState;

  const CreateGoalPlanPage({
    super.key,
    this.showEmptyState = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        // Static UI only.
        leading: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
        ),
        title: const Text('Create Goal'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _GoalCreationSteps(),
            Expanded(
              child: showEmptyState
                  ? const _EmptyPlanContent()
                  : const _FilledPlanContent(),
            ),
            _BottomActions(
              nextButtonEnabled: !showEmptyState,
            ),
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
          _StepItem(
            number: '1',
            label: 'Define',
            completed: true,
          ),
          _StepLine(active: true),
          _StepItem(
            number: '2',
            label: 'Plan',
            active: true,
          ),
          _StepLine(active: false),
          _StepItem(
            number: '3',
            label: 'Review',
          ),
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
            color: highlighted
                ? AppColors.primary
                : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: highlighted
                  ? AppColors.primary
                  : AppColors.border,
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
            color: highlighted
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight: highlighted
                ? FontWeight.w600
                : FontWeight.w400,
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
        color: active
            ? AppColors.primary
            : AppColors.disabled,
      ),
    );
  }
}

// ============================================================================
// SHARED HEADER
// ============================================================================

class _PlanHeader extends StatelessWidget {
  const _PlanHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Milestones',
                style: AppTextStyles.titleM,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Set milestones for goal progression',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const _AiAssistantBadge(),
      ],
    );
  }
}

class _AiAssistantBadge extends StatelessWidget {
  const _AiAssistantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'AI Assistant',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _EmptyPlanContent extends StatelessWidget {
  const _EmptyPlanContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const _PlanHeader(),
          const Expanded(
            child: _EmptyMilestoneIllustration(),
          ),
        ],
      ),
    );
  }
}

class _EmptyMilestoneIllustration extends StatelessWidget {
  const _EmptyMilestoneIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: AppColors.primary50,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.fact_check_outlined,
                size: 82,
                color: AppColors.primary,
              ),
              Positioned(
                right: 28,
                bottom: 29,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'No milestones yet',
          style: AppTextStyles.titleM,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Break your goal into smaller and achievable steps.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Create your first milestone',
          style: AppTextStyles.button.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FILLED STATE
// ============================================================================

class _FilledPlanContent extends StatelessWidget {
  const _FilledPlanContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _PlanHeader(),
        SizedBox(height: AppSpacing.xl),
        _MilestoneCard(
          number: 1,
          title: 'Build Strong Study Routine',
          taskCount: '4 Tasks',
          tasks: [
            'Create a weekly study schedule',
            'Review lesson notes every evening',
            'Study for one focused hour',
            'Prepare tomorrow’s materials',
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _MilestoneCard(
          number: 2,
          title: 'Improve Academic Performance',
          taskCount: '4 Tasks',
        ),
        SizedBox(height: AppSpacing.md),
        _MilestoneCard(
          number: 3,
          title: 'Prepare for Mid-Term',
          taskCount: '4 Tasks',
        ),
        SizedBox(height: AppSpacing.md),
        _MilestoneCard(
          number: 4,
          title: 'Prepare for Final',
          taskCount: '4 Tasks',
        ),
        SizedBox(height: AppSpacing.sm),
        _AddMilestoneButton(),
      ],
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final int number;
  final String title;
  final String taskCount;
  final List<String> tasks;

  const _MilestoneCard({
    required this.number,
    required this.title,
    required this.taskCount,
    this.tasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Icon(
                  Icons.drag_indicator,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: AppColors.primary200,
                  ),
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
              const Icon(
                Icons.edit_outlined,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.delete_outline,
                size: 19,
                color: AppColors.error,
              ),
            ],
          ),
          if (tasks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            for (final task in tasks)
              _TaskRow(title: task),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;

  const _TaskRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 64,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMilestoneButton extends StatelessWidget {
  const _AddMilestoneButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        // Static UI only.
        onPressed: () {},
        icon: const Icon(
          Icons.add_circle_outline,
          size: 19,
        ),
        label: const Text('Add Milestone'),
      ),
    );
  }
}

// ============================================================================
// BOTTOM BUTTONS
// ============================================================================

class _BottomActions extends StatelessWidget {
  final bool nextButtonEnabled;

  const _BottomActions({
    required this.nextButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
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
              onPressed: nextButtonEnabled ? () {} : null,
              child: const Text('Next: Review Goal'),
            ),
          ),
        ],
      ),
    );
  }
}