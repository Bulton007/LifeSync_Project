import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';

class TaskCalendarHeader extends StatelessWidget {
  const TaskCalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const dates = ['19', '20', '21', '22', '23', '24', '25'];

    return Column(
      children: [
        Row(
          children: [
            const AppBackButton(),

            const Spacer(),

            Column(
              children: [
                Text(
                  '2026',
                  style: AppTextStyles.micro,
                ),
                Text(
                  'January',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const Spacer(),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            days.length,
            (index) {
              return SizedBox(
                width: 40,
                child: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(
                    color: index == 3
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dates.length,
            (index) {
              final selected = index == 3;

              return Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  dates[index],
                  style: AppTextStyles.bodyPrimary.copyWith(
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}