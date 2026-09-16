import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/habits/presentation/models/habit_item_model.dart';
import 'package:life_sync_app/features/habits/presentation/widgets/habits_card.dart';

void main() {
  group('HabitsCard Tests', () {
    testWidgets('renders empty illustration when habits list is empty',
        (tester) async {
      var clickedAddSchedule = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitsCard(
              habits: const [],
              onAddSchedule: () => clickedAddSchedule = true,
            ),
          ),
        ),
      );

      expect(find.text('Habits'), findsOneWidget);
      expect(find.text('No habits scheduled today.'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(
        find.textContaining('Alright, what habit are we starting?'),
        findsOneWidget,
      );
      expect(find.text('Create one'), findsOneWidget);
      expect(find.text('Add Habit Schedule'), findsNothing);

      await tester.tap(find.text('Create one'));
      expect(clickedAddSchedule, isTrue);
    });

    testWidgets('renders all 3 habits and responds to interaction',
        (tester) async {
      var habits = [
        const Habit(
          id: '1',
          title: 'Morning Routine',
          streakText: '168 Days Streaks',
          icon: Icons.wb_sunny_rounded,
          iconBgColor: Color(0xFFFFF1E8),
          iconColor: Color(0xFFFF9500),
          statusType: HabitStatusType.progress,
          isExpanded: true,
          subHabits: [
            HabitSubItem(
              id: '1-1',
              title: 'Make Breakfast',
              isCompleted: false,
            ),
            HabitSubItem(
              id: '1-2',
              title: 'Drink a Cup of Water',
              isCompleted: false,
            ),
            HabitSubItem(
              id: '1-3',
              title: 'Make bed',
              isCompleted: true,
            ),
          ],
        ),
        const Habit(
          id: '2',
          title: 'Read 10 Pages',
          streakText: '168 Days Streaks',
          icon: Icons.menu_book_rounded,
          iconBgColor: Color(0xFFEAF8EE),
          iconColor: Color(0xFF22C55E),
          statusType: HabitStatusType.completedPill,
          isExpanded: false,
        ),
        const Habit(
          id: '3',
          title: 'Run 20 Minutes',
          streakText: '168 Days Streaks',
          icon: Icons.directions_run_rounded,
          iconBgColor: Color(0xFFE6F8FA),
          iconColor: Color(0xFF00B4D8),
          statusType: HabitStatusType.doneOutlinedPill,
          isExpanded: false,
        ),
      ];

      var toggledSubItem = false;
      var toggledExpand = false;
      var clickedViewAll = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HabitsCard(
                  habits: habits,
                  onViewAll: () => clickedViewAll = true,
                  onToggleExpand: (habit) {
                    toggledExpand = true;
                    setState(() {
                      habits = [
                        habits[0].copyWith(isExpanded: !habits[0].isExpanded),
                        habits[1],
                        habits[2],
                      ];
                    });
                  },
                  onSubItemToggle: (habit, sub) {
                    toggledSubItem = true;
                    setState(() {
                      final updated = habit.subHabits.map((item) {
                        return item.id == sub.id
                            ? item.copyWith(isCompleted: !item.isCompleted)
                            : item;
                      }).toList();
                      habits = [
                        habit.copyWith(subHabits: updated),
                        habits[1],
                        habits[2],
                      ];
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify all three habit titles and streaks
      expect(find.text('Morning Routine'), findsOneWidget);
      expect(find.text('Read 10 Pages'), findsOneWidget);
      expect(find.text('Run 20 Minutes'), findsOneWidget);
      expect(find.text('168 Days Streaks'), findsNWidgets(3));

      // Verify Morning Routine progress text and sub-habits
      expect(find.text('1/3'), findsOneWidget);
      expect(find.text('Make Breakfast'), findsOneWidget);
      expect(find.text('Drink a Cup of Water'), findsOneWidget);
      expect(find.text('Make bed'), findsOneWidget);

      // Verify completed pill and done pill
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Toggle first sub-item
      await tester.tap(find.text('Make Breakfast'));
      await tester.pumpAndSettle();
      expect(toggledSubItem, isTrue);
      // Completed count should now be 2/3
      expect(find.text('2/3'), findsOneWidget);

      // Tap View All
      await tester.tap(find.text('View All'));
      expect(clickedViewAll, isTrue);

      // Tap Habit #1 to collapse
      await tester.tap(find.text('Morning Routine'));
      await tester.pumpAndSettle();
      expect(toggledExpand, isTrue);
      // Sub-habits should be collapsed
      expect(find.text('Make Breakfast'), findsNothing);
    });
  });
}
