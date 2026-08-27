import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/auth_guard.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/widgets/app_shell.dart';
import 'package:life_sync_app/core/widgets/startup_page.dart';
import 'package:life_sync_app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:life_sync_app/features/finance/presentation/bindings/finance_binding.dart';
import 'package:life_sync_app/features/habits/presentation/bindings/habit_binding.dart';
import 'package:life_sync_app/features/habits/presentation/pages/add_new_habit_screen.dart';
import 'package:life_sync_app/features/habits/presentation/pages/habit_progress_screen.dart';
import 'package:life_sync_app/features/habits/presentation/pages/habit_tracker_screen.dart';
import 'package:life_sync_app/features/notifications/presentation/bindings/notification_binding.dart';
import 'package:life_sync_app/features/notifications/presentation/pages/notification_history_screen.dart';
import 'package:life_sync_app/features/personal_progress/presentation/bindings/personal_progress_binding.dart';
import 'package:life_sync_app/features/personal_progress/presentation/pages/personal_progress_screen.dart';
import 'package:life_sync_app/features/goals/presentation/bindings/goal_binding.dart';
import 'package:life_sync_app/features/goals/presentation/pages/create_goal_first_step_screen.dart';
import 'package:life_sync_app/features/goals/presentation/pages/goal_details_screen.dart';
import 'package:life_sync_app/features/tasks/presentation/bindings/task_binding.dart';
import 'package:life_sync_app/features/tasks/presentation/pages/add_to_do_list_full_screen.dart';
import 'package:life_sync_app/features/tasks/presentation/pages/to_do_list_screen.dart';
import 'package:life_sync_app/features/user/presentation/bindings/user_binding.dart';
import 'package:life_sync_app/features/user/presentation/pages/change_password_page.dart';
import 'package:life_sync_app/features/user/presentation/pages/profile_page.dart';
import 'package:life_sync_app/views/authentication/created_success_screen.dart';
import 'package:life_sync_app/views/authentication/fill_name_screen.dart';
import 'package:life_sync_app/views/authentication/forgot_password_screen.dart';
import 'package:life_sync_app/views/authentication/sign_in_screen.dart';
import 'package:life_sync_app/views/authentication/sign_up_create_password_screen.dart';
import 'package:life_sync_app/views/authentication/sign_up_screen.dart';
import 'package:life_sync_app/views/authentication/sign_up_verify_email_screen.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.startup, page: () => const StartupPage()),
    GetPage<dynamic>(
      name: AppRoutes.shell,
      page: () => const AppShell(),
      bindings: [
        UserBinding(),
        TaskBinding(),
        HabitBinding(),
        GoalBinding(),
        FinanceBinding(),
        NotificationBinding(),
      ],
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.createPassword,
      page: () => const SignUpCreatePasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.fillName,
      page: () => const FillNameScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.verifyEmail,
      page: () => const SignUpVerifyEmailScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.createdSuccess,
      page: () => const CreatedSuccessScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      bindings: [UserBinding(), AuthBinding()],
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      binding: AuthBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.tasks,
      page: () => const ToDoListScreen(),
      binding: TaskBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.taskEditor,
      page: () => const AddTodoFullScreen(),
      binding: TaskBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.habits,
      page: () => const HabitTrackerScreen(),
      binding: HabitBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.habitEditor,
      page: () => const AddNewHabitScreen(),
      binding: HabitBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.habitProgress,
      page: () => const HabitProgressScreen(),
      binding: HabitBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.goalEditor,
      page: () => const CreateGoalFirstStepScreen(),
      binding: GoalBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.goalDetails,
      page: () => const GoalDetailsScreen(),
      binding: GoalBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.personalProgress,
      page: () => const PersonalProgressScreen(),
      binding: PersonalProgressBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.notifications,
      page: () => const NotificationHistoryScreen(),
      binding: NotificationBinding(),
      middlewares: [AuthGuard()],
    ),
  ];

  const AppPages._();
}
