import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';

class JournalTimelinePage extends StatelessWidget {
  const JournalTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _JournalHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  const _WeekCalendar(),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Journal',
                    style: AppTextStyles.titleXL.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  const _JournalTimeline(),
                ],
              ),
            ),

            Positioned(
              right: AppSpacing.xl,
              bottom: AppSpacing.xl,
              child: _JournalFab(
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _JournalHeader extends StatelessWidget {
  const _JournalHeader();

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
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'January',
              style: AppTextStyles.bodyL.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        const Spacer(),

        _CircleIconButton(
          icon: Icons.search_rounded,
          onTap: () {},
        ),

        const SizedBox(width: AppSpacing.md),

        _CircleIconButton(
          icon: Icons.calendar_month_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}

// ============================================================
// WEEK CALENDAR
// ============================================================

class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar();

  @override
  Widget build(BuildContext context) {
    const days = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    const dates = [
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            days.length,
            (index) {
              final selected = index == 3;

              return SizedBox(
                width: 42,
                child: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: selected
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
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  dates[index],
                  style: AppTextStyles.bodyL.copyWith(
                    color: selected
                        ? Colors.white
                        : index == 0 || index == 6
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                    fontWeight: selected
                        ? FontWeight.w500
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

// ============================================================
// JOURNAL TIMELINE
// ============================================================

class _JournalTimeline extends StatelessWidget {
  const _JournalTimeline();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _JournalTimelineEntry(
          time: '11:27 PM',
          title: 'Night Time',
          description:
              'Tonight, Siem Reap had a completely different atmosphere from the daytime. As the sun disappeared, the streets slowly filled with warm lights, music, and people enjoying the cool...',
          imageAssets: [
            'assets/images/journal/night_time.png',
          ],
        ),

        _JournalTimelineEntry(
          time: '7:35 PM',
          title: 'A Day in Siem Reap',
          description:
              'Today was one of those days that felt both peaceful and unforgettable. I woke up early to catch the sunrise and headed toward Angkor Wat while the sky was still dark. As the first rays of sunlight appeared behind the ancient temple, the reflection on the...',
          imageAssets: [
            'assets/images/journal/siem_reap_1.png',
            'assets/images/journal/siem_reap_2.png',
          ],
          isLast: true,
        ),
      ],
    );
  }
}

class _JournalTimelineEntry extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final List<String> imageAssets;
  final bool isLast;

  const _JournalTimelineEntry({
    required this.time,
    required this.title,
    required this.description,
    required this.imageAssets,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 26,
          child: Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),

              if (!isLast)
                Container(
                  width: 1.5,
                  height: 240,
                  color: AppColors.border,
                ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  title,
                  style: AppTextStyles.titleM.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  description,
                  style: AppTextStyles.bodyPrimary.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                if (imageAssets.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),

                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: imageAssets
                        .map(
                          (asset) => _JournalImage(
                            assetPath: asset,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// IMAGE
// ============================================================

class _JournalImage extends StatelessWidget {
  final String assetPath;

  const _JournalImage({
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        width: 110,
        height: 78,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Container(
            width: 110,
            height: 78,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// FLOATING BUTTON
// ============================================================

class _JournalFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _JournalFab({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      elevation: 5,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 66,
          height: 66,
          child: Icon(
            Icons.eco_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}