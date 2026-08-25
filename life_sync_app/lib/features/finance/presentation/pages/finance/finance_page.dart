import 'package:flutter/material.dart';
import 'package:life_sync_app/features/goals/presentation/widgets/saving_goal_preview_card.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_fab.dart';
import '../../widgets/finance/finance_balance_card.dart';
import '../../widgets/transaction/recent_transaction_item.dart';
class FinancePage extends StatelessWidget {
  const FinancePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            100,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Financial Management',
                          style:
                              AppTextStyles.titleL.copyWith(
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(
                          height: AppSpacing.xs,
                        ),

                        Text(
                          'Track and Manage your money here',
                          style:
                              AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.analytics_outlined,
                        size: 21,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              // ==================================================
              // BALANCE
              // ==================================================

              const FinanceBalanceCard(),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              // ==================================================
              // SAVING GOALS HEADER
              // ==================================================

              Row(
                children: [
                  Text(
                    'Saving Goal',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              // ==================================================
              // SAVING GOALS
              // ==================================================

              SizedBox(
                height: 145,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SavingGoalPreviewCard(
                      title: 'Siem Reap Trip',
                      amount: '\$150.00',
                      progress: 0.42,
                      icon: Icons.flight_takeoff_rounded,
                      color: AppColors.info,
                      backgroundColor:
                          AppColors.infoMuted,
                    ),

                    SizedBox(
                      width: AppSpacing.md,
                    ),

                    SavingGoalPreviewCard(
                      title: 'School tuition',
                      amount: '\$480.00',
                      progress: 0.34,
                      icon: Icons.school_outlined,
                      color: AppColors.success,
                      backgroundColor:
                          AppColors.successMuted,
                    ),

                    SizedBox(
                      width: AppSpacing.md,
                    ),

                    SavingGoalPreviewCard(
                      title: 'Emergency Fund',
                      amount: '\$250.00',
                      progress: 0.25,
                      icon: Icons.savings_outlined,
                      color: Color(0xFF7C5CFC),
                      backgroundColor:
                          Color(0xFFEAE6FF),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              // ==================================================
              // RECENT TRANSACTION HEADER
              // ==================================================

              Row(
                children: [
                  Text(
                    'Recent Transaction',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              // ==================================================
              // TRANSACTIONS
              // ==================================================

              const RecentTransactionItem(
                title: 'Food',
                time: 'Today, 7:34 AM',
                amount: '-\$2.8',
              ),

              const RecentTransactionItem(
                title: 'Coffee',
                time: 'Today, 7:34 AM',
                amount: '-\$2',
              ),

              const RecentTransactionItem(
                title: 'Allowance',
                time: 'Yesterday, 8:00 PM',
                amount: '+\$30',
                isIncome: true,
              ),

              const RecentTransactionItem(
                title: 'Save to Siem Reap',
                time: 'Yesterday, 5:35 PM',
                amount: '\$35',
                isSaving: true,
              ),

              const RecentTransactionItem(
                title: 'Salary',
                time: 'Yesterday',
                amount: '+\$250',
                isIncome: true,
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