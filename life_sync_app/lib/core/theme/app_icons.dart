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
  // FIGMA SVG ICON ASSET PATHS (assets/icons/)
  // ============================================================
  static const String iconHome = 'assets/icons/home.svg';
  static const String iconCalendar = 'assets/icons/calendar.svg';
  static const String iconGoals = 'assets/icons/goals.svg';
  static const String iconFinance = 'assets/icons/finance.svg';
  static const String iconHabits = 'assets/icons/habits.svg';
  static const String iconJournal = 'assets/icons/journal.svg';
  static const String iconBot = 'assets/icons/bot.svg';
  static const String iconPlus = 'assets/icons/plus.svg';
  static const String iconNotification = 'assets/icons/notification.svg';
  static const String iconGoogle = 'assets/icons/google.svg';
  static const String iconApple = 'assets/icons/apple.svg';
  static const String iconFacebook = 'assets/icons/facebook.svg';

  const AppIcons._();
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
