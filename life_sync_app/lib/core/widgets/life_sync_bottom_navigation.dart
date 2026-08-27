import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';

class LifeSyncBottomNavigation extends StatelessWidget {
  const LifeSyncBottomNavigation({
    required this.currentIndex,
    required this.onTabSelected,
    this.onAssistantPressed,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onAssistantPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      // The rectangular area around the navigation stays transparent.
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 370;

            final horizontalPadding = isSmallScreen
                ? AppSpacing.sm
                : AppSpacing.md;

            final navigationHeight = isSmallScreen ? 52.0 : 56.0;
            final assistantSize = isSmallScreen ? 46.0 : 52.0;
            final gap = isSmallScreen ? 6.0 : AppSpacing.sm;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SizedBox(
                height: navigationHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: _NavigationBar(
                        currentIndex: currentIndex,
                        onTabSelected: onTabSelected,
                        compact: isSmallScreen,
                      ),
                    ),
                    SizedBox(width: gap),
                    _AssistantButton(
                      size: assistantSize,
                      onTap: onAssistantPressed,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// NAVIGATION BAR
// ============================================================================

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.compact,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          // Lightweight translucent glass appearance.
          // No expensive BackdropFilter is used.
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: Colors.white.withValues(alpha: 0.90), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavigationItem(
                icon: Icons.other_houses_outlined,
                selectedIcon: Icons.other_houses_outlined,
                label: 'Home',
                selected: currentIndex == 0,
                compact: compact,
                onTap: () => onTabSelected(0),
              ),
            ),
            Expanded(
              child: _NavigationItem(
                icon: Icons.track_changes_outlined,
                selectedIcon: Icons.track_changes,
                label: 'Goal',
                selected: currentIndex == 1,
                compact: compact,
                onTap: () => onTabSelected(1),
              ),
            ),
            Expanded(
              child: _NavigationItem(
                icon: Icons.query_stats_outlined,
                selectedIcon: Icons.query_stats,
                label: 'Finance',
                selected: currentIndex == 2,
                compact: compact,
                onTap: () => onTabSelected(2),
              ),
            ),
            Expanded(
              child: _NavigationItem(
                icon: Icons.grid_view_outlined,
                selectedIcon: Icons.grid_view_rounded,
                label: 'More',
                selected: currentIndex == 3,
                compact: compact,
                onTap: () => onTabSelected(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NAVIGATION ITEM
// ============================================================================

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final itemColor = selected
        ? const Color(0xFF4F83F7)
        : AppColors.textSecondary;

    return Material(
      color: selected
          ? const Color(0xFFE9EAED).withValues(alpha: 0.80)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: itemColor,
                size: compact ? 18 : 20,
              ),
              const SizedBox(height: 1),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTextStyles.caption.copyWith(
                    color: itemColor,
                    fontSize: compact ? 9 : 10,
                    height: 1,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
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

// ============================================================================
// ASSISTANT BUTTON
// ============================================================================

class _AssistantButton extends StatelessWidget {
  const _AssistantButton({required this.size, required this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8E3FF),
                  Color(0xFFC7CBFF),
                  Color(0xFF79B8FF),
                ],
              ),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF779CFF).withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/lifesync_assistant.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: size * 0.52,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
