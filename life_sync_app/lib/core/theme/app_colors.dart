import 'package:flutter/material.dart';

/// Global color system for the application.
///
/// IMPORTANT:
/// Do not hard-code colors inside pages/widgets.
/// Always use AppColors.xxx instead.
abstract final class AppColors {
  // ============================================================
  // NEUTRALS & BASE
  // ============================================================

  /// Main application background
  static const Color background = Color(0xFFFFFFFF);

  /// Cards, dialogs, sheets, etc.
  static const Color surface = Color(0xFFFFFFFF);

  /// Disabled components
  static const Color disabled = Color(0xFFECECF0);

  /// Soft accent/background
  static const Color accent = Color(0xFFE9EBEF);

  /// Borders and dividers
  static const Color border = Color(0xFFE5E5E5);

  /// Disabled foreground / secondary dark
  static const Color disabledBackground = Color(0xFF717182);

  /// Main foreground / main text
  static const Color foreground = Color(0xFF0A0A0B);

  // ============================================================
  // PRIMARY
  // ============================================================

  static const Color primary50 = Color(0xFFF0FDFA);
  static const Color primary100 = Color(0xFFCCFBF1);
  static const Color primary200 = Color(0xFF99F6E4);

  static const Color primary400 = Color(0xFF2DD4BF);
  static const Color primary500 = Color(0xFF14B8A6);
  static const Color primary600 = Color(0xFF0D9488);
  static const Color primary700 = Color(0xFF0F766E);

  /// Default application primary color.
  ///
  /// Later, if the Figma primary is a different exact value,
  /// we only change it here.
  static const Color primary = primary600;

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  // Success
  static const Color success = Color(0xFF16A34A);
  static const Color successMuted = Color(0xFFDCFCE7);

  // Warning
  static const Color warning = Color(0xFFD97706);
  static const Color warningMuted = Color(0xFFFEF3C7);

  // Information
  static const Color info = Color(0xFF0284C7);
  static const Color infoMuted = Color(0xFFE0F2FE);

  // Error
  static const Color error = Color(0xFFD4183D);
  static const Color errorMuted = Color(0xFFFEE2E2);

  // ============================================================
  // COMMON TEXT COLORS
  // ============================================================

  static const Color textPrimary = foreground;

  static const Color textSecondary = Color(0xFF717182);

  static const Color textDisabled = disabledBackground;

  static const Color textOnPrimary = Colors.white;

  // ============================================================
  // COMMON UI COLORS
  // ============================================================

  static const Color divider = border;

  static const Color card = surface;

  static const Color scaffold = background;

  // Prevent creating instances.
  const AppColors._();
}