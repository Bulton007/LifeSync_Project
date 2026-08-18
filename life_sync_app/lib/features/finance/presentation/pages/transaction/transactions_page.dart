import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_back_button.dart';
import '../../widgets/transaction/transaction_filter_bar.dart';
import '../../widgets/transaction/transaction_group.dart';
import '../../widgets/transaction/transaction_list_item.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const AppBackButton(),

                      const SizedBox(
                        width: AppSpacing.md,
                      ),

                      Expanded(
                        child: Text(
                          'Transactions',
                          style: AppTextStyles.titleM,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                          ),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'All',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: AppSpacing.xl,
                  ),

                  const TransactionFilterBar(
                    selectedIndex: 0,
                  ),
                ],
              ),
            ),

            const Divider(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                children: const [
                  TransactionGroup(
                    title: 'Today',
                    incomeTotal: '\$128.68',
                    expenseTotal: '\$56.40',
                    savingTotal: '\$12.50',
                    children: [
                      TransactionListItem(
                        title: 'Food',
                        time: 'Today, 7:34 AM',
                        amount: '-\$10.4',
                        icon: Icons.restaurant_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),

                      TransactionListItem(
                        title: 'Shopping',
                        time: 'Today, 7:34 AM',
                        amount: '-\$46',
                        icon: Icons.shopping_bag_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),

                      TransactionListItem(
                        title: 'Allowance',
                        time: 'Today, 7:34 AM',
                        amount: '+\$128.68',
                        icon:
                            Icons.account_balance_wallet_outlined,
                        type:
                            TransactionVisualType.income,
                      ),

                      TransactionListItem(
                        title: 'Saved to Siem Reap Trip',
                        time: 'Today, 7:34 AM',
                        amount: '\$12.5',
                        icon: Icons.flight_takeoff_rounded,
                        type:
                            TransactionVisualType.saving,
                      ),
                    ],
                  ),

                  TransactionGroup(
                    title: '08 Aug 2026',
                    expenseTotal: '\$56.40',
                    savingTotal: '\$12.50',
                    children: [
                      TransactionListItem(
                        title: 'Food',
                        time: 'Today, 7:34 AM',
                        amount: '-\$10.4',
                        icon: Icons.restaurant_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),

                      TransactionListItem(
                        title: 'Shopping',
                        time: 'Today, 7:34 AM',
                        amount: '-\$46',
                        icon: Icons.shopping_bag_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),

                      TransactionListItem(
                        title: 'Allowance',
                        time: 'Today, 7:34 AM',
                        amount: '+\$128.68',
                        icon:
                            Icons.account_balance_wallet_outlined,
                        type:
                            TransactionVisualType.income,
                      ),

                      TransactionListItem(
                        title: 'Saved to Siem Reap Trip',
                        time: 'Today, 7:34 AM',
                        amount: '\$12.5',
                        icon: Icons.flight_takeoff_rounded,
                        type:
                            TransactionVisualType.saving,
                      ),
                    ],
                  ),

                  TransactionGroup(
                    title: '07 Aug 2026',
                    expenseTotal: '\$56.40',
                    children: [
                      TransactionListItem(
                        title: 'Food',
                        time: 'Today, 7:34 AM',
                        amount: '-\$10.4',
                        icon: Icons.restaurant_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),

                      TransactionListItem(
                        title: 'Shopping',
                        time: 'Today, 7:34 AM',
                        amount: '-\$46',
                        icon: Icons.shopping_bag_outlined,
                        type:
                            TransactionVisualType.expense,
                      ),
                    ],
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