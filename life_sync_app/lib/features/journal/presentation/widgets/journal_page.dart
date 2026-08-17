import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_fab.dart';
import '../widgets/journal_entry_card.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),

                  const Spacer(),

                  Text(
                    'Journal',
                    style: AppTextStyles.titleL,
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              Text(
                'Your thoughts',
                style: AppTextStyles.titleXL,
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Write, reflect and keep your memories.',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: AppSpacing.xxl),

              Expanded(
                child: ListView(
                  children: const [
                    JournalEntryCard(
                      title: 'A productive day',
                      date: 'Wednesday, January 22',
                      mood: '😊',
                      preview:
                          'Today was a very productive day. I completed most of my tasks and finally finished the dashboard design...',
                      tags: [
                        'productive',
                        'work',
                      ],
                    ),

                    SizedBox(height: AppSpacing.md),

                    JournalEntryCard(
                      title: 'Morning thoughts',
                      date: 'Tuesday, January 21',
                      mood: '☀️',
                      preview:
                          'I woke up earlier than usual today. I want to keep this routine and start my days with more focus...',
                      tags: [
                        'morning',
                        'routine',
                      ],
                    ),

                    SizedBox(height: AppSpacing.md),

                    JournalEntryCard(
                      title: 'Weekend reflection',
                      date: 'Sunday, January 19',
                      mood: '😌',
                      preview:
                          'This weekend gave me some time to slow down, rest, and think about my goals for the coming weeks...',
                      tags: [
                        'reflection',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: AppFab(
        onPressed: () {},
        icon: Icons.edit_rounded,
      ),
    );
  }
}