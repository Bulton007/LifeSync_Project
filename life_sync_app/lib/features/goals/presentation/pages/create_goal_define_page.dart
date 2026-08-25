import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateGoalDefinePage extends StatelessWidget {
  const CreateGoalDefinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        // Static UI: navigation will be connected later.
        leading: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
        ),
        title: const Text('Create Goal'),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            _GoalCreationSteps(),
            Expanded(
              child: _DefineGoalForm(),
            ),
            _BottomAction(),
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
            active: true,
          ),
          _StepLine(active: false),
          _StepItem(
            number: '2',
            label: 'Plan',
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

  const _StepItem({
    required this.number,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Text(
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
            color: active
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight:
                active ? FontWeight.w600 : FontWeight.w400,
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
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : AppColors.disabled,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}

// ============================================================================
// FORM
// ============================================================================

class _DefineGoalForm extends StatelessWidget {
  const _DefineGoalForm();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.textPrimary,
                size: 21,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Define your goal',
                    style: AppTextStyles.titleM,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Start with a clear goal and describe what '
                    'success will look like.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Goal name
        Text(
          'Goal',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Enter your goal',
            prefixIcon: Icon(Icons.flag_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Outcome
        Text(
          'What Success Will Look Like?',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe your expected outcome',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Dates
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _StaticDateField(
                label: 'Start Date',
                value: 'Friday, 08 Aug 2026',
                icon: Icons.calendar_today_outlined,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StaticDateField(
                label: 'Due Date',
                value: 'Not Set',
                icon: Icons.event_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Optional guidance card
        const _GoalTipCard(),
      ],
    );
  }
}

class _StaticDateField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StaticDateField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: value == 'Not Set'
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalTipCard extends StatelessWidget {
  const _GoalTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.info,
            size: 21,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make it clear and measurable',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'A well-defined goal makes it easier to create '
                  'milestones and monitor your progress.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTTOM BUTTON
// ============================================================================

class _BottomAction extends StatelessWidget {
  const _BottomAction();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: ElevatedButton(
        // Static UI only.
        onPressed: () {},
        child: const Text('Next: Build Your Plan'),
      ),
    );
  }
}