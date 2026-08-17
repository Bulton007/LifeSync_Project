import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../widgets/habit_color_selector.dart';
import '../widgets/habit_frequency_selector.dart';

class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({super.key});

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
                    'New Habit',
                    style: AppTextStyles.titleL,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Habit Name',
                style: AppTextStyles.bodyPrimary.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'e.g. Read 10 pages',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const HabitFrequencySelector(),
              const SizedBox(height: AppSpacing.xxl),
              const HabitColorSelector(),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Reminder',
                style: AppTextStyles.bodyPrimary.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Choose reminder time',
                  prefixIcon: Icon(
                    Icons.notifications_none_rounded,
                  ),
                  suffixIcon: Icon(
                    Icons.chevron_right_rounded,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Goal',
                style: AppTextStyles.bodyPrimary.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '1 time per day',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Create Habit',
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