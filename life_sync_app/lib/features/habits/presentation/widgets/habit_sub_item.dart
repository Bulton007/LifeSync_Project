import 'package:flutter/material.dart';
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

  static const Color primaryBlue = Color(0xFF4F8DF7);
  static const Color darkText = Color(0xFF222222);
  static const Color secondaryText = Color(0xFF777B87);
  static const Color connectorColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
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
                      color: connectorColor,
                    ),
                  ),

                  // Circular checkbox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isCompleted ? primaryBlue : Colors.white,
                      border: Border.all(
                        color: item.isCompleted
                            ? primaryBlue
                            : const Color(0xFFD1D5DB),
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
                  color: item.isCompleted ? secondaryText : darkText,
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: secondaryText,
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
