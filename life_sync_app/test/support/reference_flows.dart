import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/localization/app_translations.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/widgets/analytics_charts.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:life_sync_app/features/finance/presentation/pages/financial_dashboard_screen.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goal_tracker_screen.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goal_details_screen.dart';
import 'package:life_sync_app/features/goals/presentation/pages/create_goal_first_step_screen.dart';
import 'package:life_sync_app/views/pomodoro/pomo_screen.dart';
import 'package:life_sync_app/views/pomodoro/focus_time_data_screen.dart';
import 'reference_fixtures.dart';

Widget referenceApp(Widget home, {bool dark = false, bool khmer = false}) =>
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(khmer ? 'km' : 'en'),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('km')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        brightness: dark ? Brightness.dark : Brightness.light,
        colorSchemeSeed: const Color(0xFF4D7FF0),
        fontFamily: 'NotoSansKhmer',
        scaffoldBackgroundColor: dark
            ? LifeSyncColors.dark.pageBackground
            : Colors.white,
        extensions: [dark ? LifeSyncColors.dark : LifeSyncColors.light],
      ),
      home: home,
      getPages: [
        GetPage(
          name: AppRoutes.focusStatistics,
          page: () => const FocusTimeDataScreen(),
        ),
        GetPage(
          name: AppRoutes.goalEditor,
          page: () => const CreateGoalFirstStepScreen(),
        ),
        GetPage(
          name: AppRoutes.goalDetails,
          page: () => const GoalDetailsScreen(),
        ),
      ],
    );

void registerReferenceFlows({
  Future<void> Function(WidgetTester tester, String name)? capture,
  bool narrow = false,
}) {
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());

  Future<void> screen(WidgetTester tester, Widget widget) async {
    if (narrow) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'timer duration validation, pause/resume, recording and statistics',
    (tester) async {
      final repository = TestFocusRepository();
      final clock = TestClock(DateTime.now());
      final focus = Get.put(
        FocusController(repository, MemoryStore(), clock: clock),
      );
      await screen(tester, referenceApp(const PomoScreen()));
      await tap(tester, find.byKey(const ValueKey('edit-focus-duration')));
      await tester.enterText(
        find.byKey(const ValueKey('focus-duration-input')),
        '0',
      );
      await tap(tester, find.byKey(const ValueKey('save-focus-duration')));
      expect(find.text('Enter 1 to 180 minutes.'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('focus-duration-input')),
        '40',
      );
      await capture?.call(tester, 'focus-duration');
      await tap(tester, find.byKey(const ValueKey('save-focus-duration')));
      expect(find.text('40:00'), findsOneWidget);
      await capture?.call(tester, 'pomodoro-idle');
      await tap(tester, find.byKey(const ValueKey('focus-start')));
      clock.advance(const Duration(seconds: 65));
      await tester.pump(const Duration(milliseconds: 300));
      expect(focus.displaySeconds, 2335);
      await tap(tester, find.byKey(const ValueKey('focus-pause')));
      expect(focus.isRunning.value, isFalse);
      expect(find.byKey(const ValueKey('edit-focus-duration')), findsNothing);
      await capture?.call(tester, 'pomodoro-paused');
      await tap(tester, find.byKey(const ValueKey('focus-pause')));
      expect(focus.isRunning.value, isTrue);
      await tap(tester, find.byKey(const ValueKey('focus-stop')));
      await tap(tester, find.text('Stop and Record'));
      expect(repository.sessions, hasLength(1));
      expect(focus.pomodoroSeconds, 2400);
      await tap(tester, find.text('Stopwatch'));
      await tap(tester, find.byKey(const ValueKey('focus-start')));
      clock.advance(const Duration(seconds: 10));
      await tester.pump(const Duration(milliseconds: 300));
      await tap(tester, find.byKey(const ValueKey('focus-pause')));
      expect(focus.displaySeconds, 10);
      await capture?.call(tester, 'stopwatch-paused');
      focus.reset();
      await tap(tester, find.byKey(const ValueKey('focus-statistics')));
      expect(find.byType(AnalyticsBarChart), findsOneWidget);
      expect(focus.totalFocusSeconds, 65);
      await capture?.call(tester, 'focus-statistics');
      await tap(tester, find.byKey(const ValueKey('focus-period')));
      await tap(tester, find.text('Year').last);
      expect(focus.period.value, FocusPeriod.year);
      expect(tester.takeException(), isNull);
      focus.onClose();
    },
  );

  testWidgets(
    'finance period, series, grouping and categories use real aggregates',
    (tester) async {
      Get.put<FinanceRepository>(TestFinanceRepository());
      await screen(
        tester,
        referenceApp(FinancialDashboardScreen(initialDate: DateTime(2026, 9))),
      );
      expect(find.text(r'$1004.00'), findsOneWidget);
      expect(find.text(r'$202.00'), findsWidgets);
      expect(find.text(r'$802.00'), findsOneWidget);
      await capture?.call(tester, 'finance-month');
      await tap(tester, find.byKey(const ValueKey('finance-period')));
      await tap(tester, find.text('Quarter').last);
      expect(find.text('Q3 · 2026'), findsOneWidget);
      await capture?.call(tester, 'finance-quarter');
      await tap(tester, find.byKey(const ValueKey('finance-series')));
      await tap(tester, find.text('Expense').last);
      final chart = tester.widget<AnalyticsBarChart>(
        find.byType(AnalyticsBarChart),
      );
      expect(chart.series, hasLength(1));
      await tap(tester, find.byKey(const ValueKey('finance-grouping')));
      await tap(tester, find.text('Daily').last);
      expect(
        tester.widget<AnalyticsBarChart>(find.byType(AnalyticsBarChart)).labels,
        hasLength(92),
      );
      await capture?.call(tester, 'finance-daily');
      await tap(tester, find.byKey(const ValueKey('finance-category')));
      await tap(tester, find.text('Income').last);
      expect(find.text('Salary'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'goal plan review create retries only unsaved milestones and opens detail',
    (tester) async {
      final repository = TestGoalRepository()..failNextMilestone = true;
      final controller = Get.put(GoalController(repository));
      await screen(tester, referenceApp(const GoalTrackerScreen()));
      await capture?.call(tester, 'goals-empty');
      await tap(tester, find.byTooltip('Create goal'));
      await tap(tester, find.byKey(const ValueKey('goal-next')));
      expect(find.text('Goal title is required'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('goal-title')),
        'Emergency fund',
      );
      await tester.enterText(
        find.byKey(const ValueKey('goal-description')),
        'Build a reliable safety net',
      );
      await tester.enterText(find.byKey(const ValueKey('goal-target')), '1000');
      await tester.enterText(find.byKey(const ValueKey('goal-current')), '380');
      await tap(tester, find.byKey(const ValueKey('goal-next')));
      await tap(tester, find.byKey(const ValueKey('add-draft-milestone')));
      await tester.enterText(
        find.byKey(const ValueKey('milestone-title')),
        'Save first contribution',
      );
      await capture?.call(tester, 'goal-milestone-editor');
      await tap(tester, find.byKey(const ValueKey('save-draft-milestone')));
      await capture?.call(tester, 'goal-plan');
      await tap(tester, find.byKey(const ValueKey('goal-next')));
      await capture?.call(tester, 'goal-review');
      await tap(tester, find.byKey(const ValueKey('goal-next')));
      expect(
        find.text('Goal saved. Retry to save the remaining milestones.'),
        findsOneWidget,
      );
      expect(repository.createCalls, 1);
      await tap(tester, find.byKey(const ValueKey('goal-next')));
      expect(repository.createCalls, 1);
      expect(repository.milestones, hasLength(1));
      expect(find.text('The journey starts now!'), findsOneWidget);
      await capture?.call(tester, 'goal-success');
      await tap(tester, find.text('View Goal'));
      expect(find.text('Emergency fund'), findsOneWidget);
      await tap(tester, find.text('Save first contribution'));
      await capture?.call(tester, 'goal-detail');
      await tap(tester, find.text('Complete'));
      expect(controller.milestones.values.first.single.completed, isTrue);
      Get.back<void>();
      await tester.pumpAndSettle();
      expect(find.text('1/1 milestones'), findsOneWidget);
      await capture?.call(tester, 'goals-populated');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('finance and focus empty states remain readable in dark Khmer', (
    tester,
  ) async {
    Get.put<FinanceRepository>(TestFinanceRepository()..empty = true);
    Get.put(FocusController(TestFocusRepository(), MemoryStore()));
    await screen(
      tester,
      referenceApp(
        FinancialDashboardScreen(initialDate: DateTime(2026, 9)),
        dark: true,
        khmer: true,
      ),
    );
    expect(find.byType(AnalyticsBarChart), findsOneWidget);
    await capture?.call(tester, 'finance-empty-khmer-dark');
    await tester.pumpWidget(
      referenceApp(const FocusTimeDataScreen(), dark: true, khmer: true),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AnalyticsBarChart), findsOneWidget);
    await capture?.call(tester, 'focus-empty-khmer-dark');
    expect(tester.takeException(), isNull);
  });
}
