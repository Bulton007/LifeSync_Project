import 'package:flutter/material.dart';

/// Global application color system.
///
/// Do not hard-code colors inside pages or reusable widgets.
/// Always use a color declared in this class.
abstract final class AppColors {
  // ============================================================
  // NEUTRALS AND BASE
  // ============================================================
  static const Color pageBackground = Color(0xFFF6F8FC);
  /// Main application background.
  static const Color background = Color(0xFFFFFFFF);

  /// Cards, dialogs, sheets and other elevated surfaces.
  static const Color surface = Color(0xFFFFFFFF);

  /// Disabled controls and progress backgrounds.
  static const Color disabled = Color(0xFFECECF0);

  /// Soft neutral accent background.
  static const Color accent = Color(0xFFE9EBEF);

  /// Borders and dividers.
  static const Color border = Color(0xFFE5E5E5);

  /// Disabled foreground and secondary dark color.
  static const Color disabledBackground = Color(0xFF717182);

  /// Main foreground and primary text color.
  static const Color foreground = Color(0xFF0A0A0B);

  // ============================================================
  // PRIMARY
  // ============================================================

  static const Color primary50 = Color(0xFFF0FDFA);
  static const Color primary100 = Color(0xFFCCFBF1);
  static const Color primary200 = Color(0xFF99F6E4);
  static const Color primary300 = Color(0xFF5EEAD4);
  static const Color primary400 = Color(0xFF2DD4BF);
  static const Color primary500 = Color(0xFF14B8A6);
  static const Color primary600 = Color(0xFF0D9488);
  static const Color primary700 = Color(0xFF0F766E);
  static const Color primary800 = Color(0xFF115E59);
  static const Color primary900 = Color(0xFF134E4A);

  /// Default application primary color.
  static const Color primary = primary600;

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  static const Color success = Color(0xFF16A34A);
  static const Color successMuted = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFD97706);
  static const Color warningMuted = Color(0xFFFEF3C7);

  static const Color info = Color(0xFF0284C7);
  static const Color infoMuted = Color(0xFFE0F2FE);

  static const Color error = Color(0xFFD4183D);
  static const Color errorMuted = Color(0xFFFEE2E2);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static const Color textPrimary = foreground;
  static const Color textSecondary = Color(0xFF717182);
  static const Color textDisabled = disabledBackground;

  static const Color textOnPrimary = Colors.white;
  static const Color textOnSuccess = Colors.white;
  static const Color textOnError = Colors.white;

  // ============================================================
  // COMMON UI COLORS
  // ============================================================

  static const Color divider = border;
  static const Color card = surface;
  static const Color scaffold = background;

  const AppColors._();
}