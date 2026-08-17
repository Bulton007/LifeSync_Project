import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../widgets/journal_tag_chip.dart';

class JournalDetailPage extends StatelessWidget {
  const JournalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const AppBackButton(),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'A productive day',
                              style:
                                  AppTextStyles.titleXL,
                            ),
                          ),

                          const Text(
                            '😊',
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: AppSpacing.sm,
                      ),

                      Text(
                        'Wednesday, January 22',
                        style: AppTextStyles.caption,
                      ),

                      const SizedBox(
                        height: AppSpacing.xxl,
                      ),

                      Text(
                        '''
Today was a very productive day.

I completed most of my tasks and finally finished the dashboard design. It feels great seeing the ideas come together into something real.

I also spent some time planning what I want to complete next. I want to stay consistent instead of trying to do everything at once.

Overall, today felt focused and meaningful.
''',
                        style:
                            AppTextStyles.bodyPrimary.copyWith(
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(
                        height: AppSpacing.xxl,
                      ),

                      const Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          JournalTagChip(
                            label: 'productive',
                          ),
                          JournalTagChip(
                            label: 'work',
                          ),
                        ],
                      ),
                    ],
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