import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddTagSheet extends StatelessWidget {
  const AddTagSheet({super.key});

  static Future<void> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor:
          Colors.black.withValues(alpha: 0.18),
      builder: (_) {
        return const AddTagSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboard =
        MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: keyboard,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppRadius.xl,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Add Tag',
                style: AppTextStyles.titleM,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              const TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type a tag...',
                  prefixIcon: Icon(
                    Icons.tag_rounded,
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add Tag',
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