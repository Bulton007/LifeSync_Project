import 'package:flutter/material.dart';
import 'package:life_sync_app/features/finance/presentation/widgets/finance/finance_form_field.dart';
import 'package:life_sync_app/features/finance/presentation/widgets/goal/saving_goal_color_selector.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_back_button.dart';


class CreateSavingGoalPage extends StatelessWidget {
  const CreateSavingGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================================================
              // HEADER
              // ================================================

              Row(
                children: [
                  const AppBackButton(),

                  const Spacer(),

                  Text(
                    'New Saving Goal',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 16,
                    ),
                    label: const Text(
                      'Save',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              // ================================================
              // PURPOSE
              // ================================================

              const FinanceFormField(
                label: 'Purpose',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'e.g. Siem Reap Trip',
                    prefixIcon: Icon(
                      Icons.edit_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              // ================================================
              // COLOR
              // ================================================

              const SavingGoalColorSelector(),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              // ================================================
              // TARGET AMOUNT
              // ================================================

              const FinanceFormField(
                label: 'Target Amount',
                child: TextField(
                  keyboardType:
                      TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. \$168',
                    prefixText: '\$ ',
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              // ================================================
              // COMPLETE DATE
              // ================================================

              const FinanceFormField(
                label: 'Est. Complete Date',
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Friday, 10 July 2024',
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.xxxl,
              ),

              // ================================================
              // BUTTON
              // ================================================

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Create Saving Goal',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}