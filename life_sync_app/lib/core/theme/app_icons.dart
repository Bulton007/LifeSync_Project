import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Semantic and core icon registry for the LifeSync Design System.
///
/// Provides both vector IconData representations and asset file paths
/// corresponding directly to Figma design components.
abstract final class AppIcons {
  // Navigation
  static const IconData home = CupertinoIcons.home;
  static const IconData homeFilled = Icons.home;
  static const IconData goal = CupertinoIcons.bolt_circle;
  static const IconData goalFilled = CupertinoIcons.bolt_circle_fill;
  static const IconData finance = CupertinoIcons.chart_bar_alt_fill;
  static const IconData more = CupertinoIcons.square_grid_2x2;
  static const IconData moreFilled = CupertinoIcons.square_grid_2x2_fill;

  // Actions
  static const IconData add = CupertinoIcons.add;
  static const IconData search = CupertinoIcons.search;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData bell = CupertinoIcons.bell;
  static const IconData bellFilled = CupertinoIcons.bell_fill;
  static const IconData check = CupertinoIcons.check_mark;
  static const IconData close = CupertinoIcons.xmark;
  static const IconData chevronRight = CupertinoIcons.chevron_right;
  static const IconData chevronLeft = CupertinoIcons.chevron_left;
  static const IconData chevronDown = CupertinoIcons.chevron_down;

  // Form & Auth
  static const IconData mail = CupertinoIcons.mail;
  static const IconData lock = CupertinoIcons.lock;
  static const IconData eye = CupertinoIcons.eye;
  static const IconData eyeOff = CupertinoIcons.eye_slash;
  static const IconData user = CupertinoIcons.person;
  static const IconData userFilled = CupertinoIcons.person_fill;

  // LifeSync Modules
  static const IconData calendar = CupertinoIcons.calendar;
  static const IconData streak = CupertinoIcons.flame_fill;
  static const IconData timer = CupertinoIcons.timer;
  static const IconData habit = CupertinoIcons.repeat;
  static const IconData task = CupertinoIcons.check_mark_circled;
  static const IconData journal = CupertinoIcons.book_fill;
  static const IconData leaf = CupertinoIcons.leaf_arrow_circlepath;

  // Legacy / Image Asset paths
  static const String appLogo = AppImages.appLogo;
  static const String assistantAvatar = AppImages.assistantAvatar;
  static const String appIconForeground = AppImages.appIconForeground;

  // ============================================================
  // FIGMA SVG ICON ASSET PATHS (assets/icons/ and Life-Sync SVG File/)
  // ============================================================
  static const String iconHome = LifeSyncSvgAssets.bottomHome;
  static const String iconHomeSelected = LifeSyncSvgAssets.bottomHomeSelected;
  static const String iconCalendar = 'assets/icons/calendar.svg';
  static const String iconGoals = LifeSyncSvgAssets.bottomGoal;
  static const String iconGoalsSelected = LifeSyncSvgAssets.bottomGoalSelected;
  static const String iconFinance = LifeSyncSvgAssets.bottomFinance;
  static const String iconFinanceSelected =
      LifeSyncSvgAssets.bottomFinanceSelected;
  static const String iconHabits = 'assets/icons/habits.svg';
  static const String iconJournal = LifeSyncSvgAssets.bottomJournal;
  static const String iconJournalSelected =
      LifeSyncSvgAssets.bottomJournalSelected;
  static const String iconMore = LifeSyncSvgAssets.bottomMore;
  static const String iconMoreSelected = LifeSyncSvgAssets.bottomMoreSelected;
  static const String iconPomo = LifeSyncSvgAssets.bottomPomo;
  static const String iconPomoSelected = LifeSyncSvgAssets.bottomPomoSelected;
  static const String iconSetting = LifeSyncSvgAssets.bottomSetting;
  static const String iconSettingSelected =
      LifeSyncSvgAssets.bottomSettingSelected;
  static const String iconBot = 'assets/icons/bot.svg';
  static const String iconPlus = 'assets/icons/plus.svg';
  static const String iconNotification = 'assets/icons/notification.svg';
  static const String iconGoogle = 'assets/icons/google.svg';
  static const String iconApple = 'assets/icons/apple.svg';
  static const String iconFacebook = 'assets/icons/facebook.svg';

  const AppIcons._();
}

/// SVG and Vector asset registry from "Life-Sync SVG File".
abstract final class LifeSyncSvgAssets {
  // Bottom Bar Icons (Default & Selected States)
  static const String bottomHome =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Home.svg';
  static const String bottomHomeSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Sel-Home.svg';
  static const String bottomGoal =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Goal.svg';
  static const String bottomGoalSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Sel-Goal.svg';
  static const String bottomFinance =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Financial.svg';
  static const String bottomFinanceSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Sel-Financial.svg';
  static const String bottomJournal =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Journal.svg';
  static const String bottomJournalSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Journal-Sel.svg';
  static const String bottomMore =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=More.svg';
  static const String bottomMoreSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Sel-More.svg';
  static const String bottomPomo =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Pomo.svg';
  static const String bottomPomoSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Pomo-Sel.svg';
  static const String bottomSetting =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Setting.svg';
  static const String bottomSettingSelected =
      'assets/Life-Sync SVG File/Icons/BottomBar/Property 1=Setting-Sel.svg';
  static const String animedIconAi =
      'assets/Life-Sync SVG File/Icons/BottomBar/AnimedIconAI.json';

  // Financial Tab Icons
  static const String financeVector =
      'assets/Life-Sync SVG File/Icons/FinancialTab/Vector.svg';
  static const String financeGrowth =
      'assets/Life-Sync SVG File/Icons/FinancialTab/fluent_arrow-growth-20-regular.svg';
  static const String financeGrowthAlt =
      'assets/Life-Sync SVG File/Icons/FinancialTab/fluent_arrow-growth-20-regular-1.svg';
  static const String financeSavings =
      'assets/Life-Sync SVG File/Icons/FinancialTab/hugeicons_savings.svg';

  // Utility / Action Icons
  static const String icLoop =
      'assets/Life-Sync SVG File/Icons/ic_round-loop.svg';
  static const String taskEdit =
      'assets/Life-Sync SVG File/Icons/task-edit-01.svg';

  // Screen Illustrations & Vector Graphics
  static const String hello = 'assets/Life-Sync SVG File/Images/Hello.svg';
  static const String bro = 'assets/Life-Sync SVG File/Images/bro.svg';
  static const String pana = 'assets/Life-Sync SVG File/Images/pana.svg';
  static const String rafiki = 'assets/Life-Sync SVG File/Images/rafiki.svg';
  static const String goalScreenMain =
      'assets/Life-Sync SVG File/Images/GoalScreenMain.svg';
  static const String goalChecklist =
      'assets/Life-Sync SVG File/Images/Goal-Checklist.svg';
  static const String createdGoalSuccess =
      'assets/Life-Sync SVG File/Images/CreatedGoalSuccess.svg';
  static const String mindMap = 'assets/Life-Sync SVG File/Images/mind-map.svg';
  static const String group11 = 'assets/Life-Sync SVG File/Images/Group 11.svg';
  static const String group = 'assets/Life-Sync SVG File/Images/Group.svg';
  static const String activityTracker =
      'assets/Life-Sync SVG File/Images/undraw_activity-tracker_3o6r 1.svg';
  static const String done =
      'assets/Life-Sync SVG File/Images/undraw_done_i0ak 1.svg';

  const LifeSyncSvgAssets._();
}

/// Image asset path registry for LifeSync frontend (assets/images/).
/// All files are PNG format.
abstract final class AppImages {
  // Brand & Illustration Images
  static const String appLogo = 'assets/images/app_logo.png';
  static const String assistantAvatar = 'assets/images/lifesync_assistant.png';
  static const String appIconForeground =
      'assets/images/app_icon_foreground.png';
  static const String nightTime = 'assets/images/night_time.png';
  static const String siemReap1 = 'assets/images/aiem_reap_1.png';
  static const String siemReap2 = 'assets/images/siem_reap_2.png';

  // PNG Icons
  static const String iconHome = 'assets/images/icon_home.png';
  static const String iconCalendar = 'assets/images/icon_calendar.png';
  static const String iconGoals = 'assets/images/icon_goals.png';
  static const String iconFinance = 'assets/images/icon_finance.png';
  static const String iconHabits = 'assets/images/icon_habits.png';
  static const String iconJournal = 'assets/images/icon_journal.png';
  static const String iconBot = 'assets/images/icon_bot.png';
  static const String iconBell = 'assets/images/icon_bell.png';

  // Social Login Logos
  static const String googleLogo = 'assets/images/google_logo.png';
  static const String appleLogo = 'assets/images/apple_logo.png';
  static const String facebookLogo = 'assets/images/facebook_logo.png';

  const AppImages._();
}
