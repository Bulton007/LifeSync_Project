import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_journal_item.dart';
import '../widgets/calendar_task_item.dart';
import '../widgets/month_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

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
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const CalendarHeader(),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              const MonthCalendar(),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              const Divider(),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              Text(
                'Wednesday, January 22',
                style: AppTextStyles.titleM,
              ),

              const SizedBox(
                height: AppSpacing.xs,
              ),

              Text(
                '2 tasks • 1 journal',
                style: AppTextStyles.caption,
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              Row(
                children: [
                  Text(
                    'Tasks',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  Text(
                    '2',
                    style:
                        AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              const CalendarTaskItem(
                title: 'Finish Dashboard Design',
                time: '8:00 AM',
                priority: 'High',
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              const CalendarTaskItem(
                title: 'Laundry',
                time: '8:00 PM',
                priority: 'Normal',
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              Text(
                'Journal',
                style: AppTextStyles.titleM,
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              const CalendarJournalItem(
                title: 'A productive day',
                preview:
                    'Today was a very productive day. I completed most of my tasks...',
                mood: '😊',
              ),
            ],
          ),
        ),
      ),
    );
  }
}