import 'package:flutter/material.dart';

class DailyProgressIndicator extends StatelessWidget {
  const DailyProgressIndicator({
    required this.completed,
    required this.total,
    required this.color,
    required this.backgroundColor,
    super.key,
  });

  final int completed;
  final int total;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final progress = total <= 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final emoji = total <= 0
        ? '🌱'
        : progress == 1
        ? '🥳'
        : progress >= 0.5
        ? '😄'
        : progress > 0
        ? '🙂'
        : '💪';
    final percentage = '${(progress * 100).floor()}%';
    return Semantics(
      value: percentage,
      child: SizedBox(
        width: 66,
        height: 66,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                color: color,
                backgroundColor: backgroundColor,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Text(emoji, style: const TextStyle(fontSize: 25)),
                ),
                Text(percentage, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
