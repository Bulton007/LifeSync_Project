import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../widgets/habit_progress_calendar.dart';

class HabitProgressPage extends StatelessWidget {
  const HabitProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Text(
                    'Habit Progress',
                    style: AppTextStyles.titleL,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.successMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read 10 Pages',
                          style: AppTextStyles.titleM,
                        ),
                        Text(
                          'Every day',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppSurfaceCard(
                child: Column(
                  children: [
                    Text(
                      'Current Streak',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '🔥 47',
                      style: AppTextStyles.titleXL,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'days',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppSurfaceCard(
                      child: Column(
                        children: [
                          Text(
                            'Best Streak',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '68',
                            style: AppTextStyles.titleM,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppSurfaceCard(
                      child: Column(
                        children: [
                          Text(
                            'Completion',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '91%',
                            style: AppTextStyles.titleM,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'January 2026',
                style: AppTextStyles.titleM,
              ),
              const SizedBox(height: AppSpacing.lg),
              const HabitProgressCalendar(),
            ],
          ),
        ),
      ),
    );
  }
}