import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalSuccessPage extends StatelessWidget {
  const GoalSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Replace with your own illustration asset later.
              const _SuccessIllustration(),

              const SizedBox(height: AppSpacing.xxl),

              Text(
                'The journey starts now!',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleXL.copyWith(color: AppColors.primary),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Your goal is set — every step from here brings '
                'you closer to your finish line.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyPrimary.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              const Row(
                children: [
                  Expanded(
                    child: _SuccessSummaryItem(
                      icon: Icons.flag_outlined,
                      label: 'Milestones',
                      value: '4',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _SuccessSummaryItem(
                      icon: Icons.task_alt_outlined,
                      label: 'Tasks',
                      value: '24',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _SuccessSummaryItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Due Date',
                      value: '10th Oct',
                      secondaryValue: '2026',
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              const _BottomActions(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SUCCESS ILLUSTRATION
// ============================================================================

class _SuccessIllustration extends StatelessWidget {
  const _SuccessIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 12,
            child: Container(
              width: 220,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),

          Positioned(
            bottom: 62,
            right: 20,
            child: Icon(
              Icons.landscape_outlined,
              size: 145,
              color: AppColors.primary200.withValues(alpha: 0.75),
            ),
          ),

          const Positioned(
            bottom: 42,
            left: 72,
            child: Icon(
              Icons.directions_walk,
              size: 105,
              color: AppColors.foreground,
            ),
          ),

          Positioned(
            bottom: 58,
            right: 44,
            child: Container(width: 3, height: 70, color: AppColors.primary),
          ),

          const Positioned(
            bottom: 112,
            right: 22,
            child: Icon(Icons.flag, size: 38, color: AppColors.primary),
          ),

          Positioned(
            left: 33,
            top: 35,
            child: Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x18000000), blurRadius: 10),
                ],
              ),
              child: const Icon(
                Icons.check,
                size: 22,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUMMARY ITEMS
// ============================================================================

class _SuccessSummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? secondaryValue;

  const _SuccessSummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.secondaryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 19, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.button,
          ),
          if (secondaryValue != null)
            Text(secondaryValue!, style: AppTextStyles.micro),
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
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            // Static UI only.
            onPressed: () {},
            child: const Text('View Goal'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            // Static UI only.
            onPressed: () {},
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
