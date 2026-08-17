import 'package:flutter/material.dart';
import 'package:life_sync_app/features/tasks/presentation/pages/add_task_sheet.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fab.dart';
import '../widgets/task_calendar_header.dart';
import '../widgets/task_timeline.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            90,
          ),
          child: Column(
            children: [
              const TaskCalendarHeader(),

              const SizedBox(height: AppSpacing.xxl),

              const Expanded(
                child: SingleChildScrollView(child: TaskTimeline()),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: AppFab(
        onPressed: () {
          AddTaskSheet.show(context);
        },
      ),
    );
  }
}
