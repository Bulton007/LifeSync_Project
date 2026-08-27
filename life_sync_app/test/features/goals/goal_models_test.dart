import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';

void main() {
  test('GoalModel parses string decimals without double arithmetic', () {
    final goal = GoalModel.fromJson({
      'id': 8,
      'userId': 2,
      'title': 'Emergency fund',
      'description': 'Six months',
      'targetAmount': '1000.00',
      'currentAmount': '125.75',
      'completed': false,
      'archived': false,
      'deadline': '2030-12-31',
      'createdAt': '2026-08-27T08:00:00',
      'updatedAt': '2026-08-27T08:00:00',
    });

    expect(goal.currentAmount.toApiString(), '125.75');
    expect(goal.progress, closeTo(0.1257, 0.0001));
  });
}
