import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/features/habits/presentation/models/habit_item_model.dart';

/// Renders a single sub-habit item with a circular checkbox, label,
/// and vertical connector line connecting to adjacent sub-habits.
class HabitSubItemWidget extends StatelessWidget {
  const HabitSubItemWidget({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.onToggle,
    super.key,
  });

  final HabitSubItem item;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // Connector line + circular checkbox
            SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vertical connecting line
                  CustomPaint(
                    size: const Size(32, 32),
                    painter: _SubItemConnectorPainter(
                      isFirst: isFirst,
                      isLast: isLast,
                      color: colors.border,
                    ),
                  ),

                  // Circular checkbox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isCompleted ? colors.primaryBlue : colors.inputSurface,
                      border: Border.all(
                        color: item.isCompleted
                            ? colors.primaryBlue
                            : colors.border,
                        width: 1.8,
                      ),
                    ),
                    child: item.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Sub-habit title
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: item.isCompleted ? colors.secondaryText : colors.primaryText,
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: colors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubItemConnectorPainter extends CustomPainter {
  const _SubItemConnectorPainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  final bool isFirst;
  final bool isLast;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Line from top to center if not first item
    if (!isFirst) {
      canvas.drawLine(Offset(centerX, 0), Offset(centerX, centerY - 10), paint);
    }

    // Line from center to bottom if not last item
    if (!isLast) {
      canvas.drawLine(
        Offset(centerX, centerY + 10),
        Offset(centerX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SubItemConnectorPainter oldDelegate) =>
      oldDelegate.isFirst != isFirst ||
      oldDelegate.isLast != isLast ||
      oldDelegate.color != color;
}
