import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../widgets/task_form.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const AppBackButton(),

                  const Spacer(),

                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 16,
                    ),
                    label: const Text('Save'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(
                        color: AppColors.border,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              const Expanded(
                child: SingleChildScrollView(
                  child: TaskForm(),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'UI only — logic will be connected later',
                  style: AppTextStyles.micro,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}