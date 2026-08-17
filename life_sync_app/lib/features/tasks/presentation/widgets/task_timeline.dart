import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'task_timeline_item.dart';

class TaskTimeline extends StatelessWidget {
  const TaskTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To-do List',
          style: AppTextStyles.titleL.copyWith(
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        const TaskTimelineItem(
          time: 'N/A',
          title: 'Finish Dashboard Design',
        ),

        const Divider(),

        const TaskTimelineItem(
          time: '8:00 AM',
          title: 'Interview at Antropic',
          subtitle: 'CV and Documentation on the Desk',
        ),

        const Divider(),

        const TaskTimelineItem(
          time: '8:00 PM',
          title: 'Laundry',
        ),
      ],
    );
  }
}