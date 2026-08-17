import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HabitProgressCalendar extends StatelessWidget {
  const HabitProgressCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    const days = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return Column(
      children: [
        Row(
          children: days
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 28,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final completed = index % 5 != 0;

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed
                    ? AppColors.primary
                    : AppColors.accent,
              ),
              alignment: Alignment.center,
              child: completed
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}