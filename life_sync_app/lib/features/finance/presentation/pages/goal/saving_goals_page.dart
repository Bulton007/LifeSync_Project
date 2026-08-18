import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_back_button.dart';
import '../../../../../core/widgets/app_fab.dart';
import '../../widgets/goal/saving_goal_list_item.dart';
import '../../widgets/goal/saving_summary_card.dart';

class SavingGoalsPage extends StatelessWidget {
  const SavingGoalsPage({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),

                  const Spacer(),

                  Text(
                    'Saving Goals',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              const SavingSummaryCard(),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'Saving Goals',
                style: AppTextStyles.titleM,
              ),

              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: ListView(
                  children: const [
                    SavingGoalListItem(
                      title: 'Siem Reap Trip',
                      subtitle: 'Est. Complete on 31 March 2027',
                      savedAmount: '\$72.00',
                      targetAmount: '\$150.00',
                      progress: 0.48,
                      icon: Icons.flight_takeoff_rounded,
                      color: AppColors.info,
                      backgroundColor: AppColors.infoMuted,
                    ),

                    SizedBox(height: AppSpacing.md),

                    SavingGoalListItem(
                      title: 'School Tuition',
                      subtitle: 'Est. Complete on 31 March 2027',
                      savedAmount: '\$72.00',
                      targetAmount: '\$150.00',
                      progress: 0.44,
                      icon: Icons.school_outlined,
                      color: AppColors.success,
                      backgroundColor: AppColors.successMuted,
                    ),

                    SizedBox(height: AppSpacing.md),

                    SavingGoalListItem(
                      title: 'Emergency Fund',
                      subtitle: 'Est. Complete on 31 March 2027',
                      savedAmount: '\$72.00',
                      targetAmount: 'N/A',
                      progress: 0.70,
                      icon: Icons.savings_outlined,
                      color: Color(0xFF7C5CFC),
                      backgroundColor: Color(0xFFEAE6FF),
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