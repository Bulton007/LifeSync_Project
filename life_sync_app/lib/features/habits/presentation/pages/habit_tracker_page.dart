import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_fab.dart';
import '../widgets/habit_card.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            90,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Text(
                    'Habit Tracker',
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
                  Text(
                    'Today',
                    style: AppTextStyles.titleXL,
                  ),
                  const Spacer(),
                  Text(
                    '3/5 completed',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView(
                  children: const [
                    HabitCard(
                      title: 'Morning Routine',
                      streak: '🔥 168 Days Streak',
                      icon: Icons.wb_sunny_outlined,
                      iconBackground: Color(0xFFFFEAD7),
                      iconColor: AppColors.warning,
                      items: [
                        'Make Breakfast',
                        'Drink a Cup of Water',
                        'Make Bed',
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    HabitCard(
                      title: 'Read 10 Pages',
                      streak: '🔥 47 Days Streak',
                      icon: Icons.menu_book_rounded,
                      iconBackground: AppColors.successMuted,
                      iconColor: AppColors.success,
                    ),
                    SizedBox(height: AppSpacing.md),
                    HabitCard(
                      title: 'Run 20 Minutes',
                      streak: '🔥 21 Days Streak',
                      icon: Icons.directions_run_rounded,
                      iconBackground: AppColors.infoMuted,
                      iconColor: AppColors.info,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () {},
      ),
    );
  }
}