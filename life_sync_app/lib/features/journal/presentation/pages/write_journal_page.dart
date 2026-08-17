import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../widgets/add_tag_sheet.dart';
import '../widgets/journal_tag_chip.dart';

class WriteJournalPage extends StatelessWidget {
  const WriteJournalPage({super.key});

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

                  Text(
                    'New Journal',
                    style: AppTextStyles.titleM,
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Done',
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
                      TextField(
                        style: AppTextStyles.titleXL,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle:
                              AppTextStyles.titleXL.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
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

                      TextField(
                        minLines: 14,
                        maxLines: null,
                        style:
                            AppTextStyles.bodyPrimary,
                        decoration: InputDecoration(
                          hintText:
                              'Start writing your thoughts...',
                          hintStyle:
                              AppTextStyles.bodyPrimary.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      const SizedBox(
                        height: AppSpacing.xxl,
                      ),

                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          const JournalTagChip(
                            label: 'daily',
                          ),

                          ActionChip(
                            avatar: const Icon(
                              Icons.add_rounded,
                              size: 16,
                            ),
                            label: const Text(
                              'Add Tag',
                            ),
                            onPressed: () {
                              AddTagSheet.show(
                                context,
                              );
                            },
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