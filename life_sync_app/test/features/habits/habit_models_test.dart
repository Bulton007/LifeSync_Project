import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';

void main() {
  test('HabitModel parses schedule, dates and ownership fields', () {
    final habit = HabitModel.fromJson({
      'habitId': 7,
      'userId': 4,
      'name': 'Read',
      'description': 'Ten pages',
      'frequency': 'WEEKLY:MON,WED,FRI',
      'streak': 3,
      'active': true,
      'startDate': '2026-08-01',
      'endDate': null,
      'createdAt': '2026-08-01T08:30:00',
      'updatedAt': '2026-08-02T08:30:00',
    });

    expect(habit.habitId, 7);
    expect(habit.scheduledDays, ['MON', 'WED', 'FRI']);
    expect(habit.isScheduledFor(DateTime(2026, 8, 3)), isTrue);
    expect(habit.isScheduledFor(DateTime(2026, 8, 4)), isFalse);
  });

  test('HabitLogModel parses Spring local date and date-times', () {
    final log = HabitLogModel.fromJson({
      'habitLogId': 12,
      'habitId': 7,
      'userId': 4,
      'completedDate': '2026-08-27',
      'completed': true,
      'note': 'Before breakfast',
      'createdAt': '2026-08-27T07:00:00',
      'updatedAt': '2026-08-27T07:00:00',
    });

    expect(log.completedDate, DateTime(2026, 8, 27));
    expect(log.completed, isTrue);
    expect(log.note, 'Before breakfast');
  });
}
