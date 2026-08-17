import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              style: AppTextStyles.titleM,
            ),
          ],
        ),

        const Spacer(),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.today_outlined,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(
          width: AppSpacing.xs,
        ),
      ],
    );
  }
}