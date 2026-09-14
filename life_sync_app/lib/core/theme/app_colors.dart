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
  // PRIMARY (LifeSync Figma Brand Blue)
  // ============================================================

  static const Color primary50 = Color(0xFFEFF6FF);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary200 = Color(0xFFBFDBFE);
  static const Color primary300 = Color(0xFF93C5FD);
  static const Color primary400 = Color(0xFF60A5FA);
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary600 = Color(0xFF2979FF);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary800 = Color(0xFF1E40AF);
  static const Color primary900 = Color(0xFF1E3A8A);

  /// Default application primary color matching Figma.
  static const Color primary = Color(0xFF2979FF);
  static const Color primaryLight = Color(0xFFE8F1FF);

  // Wellness Teal Accent
  static const Color teal50 = Color(0xFFF0FDFA);
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal = Color(0xFF0D9488);

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

/// Theme-aware semantic colors used by LifeSync feature screens.
@immutable
final class LifeSyncColors extends ThemeExtension<LifeSyncColors> {
  const LifeSyncColors({
    required this.pageBackground,
    required this.cardSurface,
    required this.elevatedSurface,
    required this.inputSurface,
    required this.primaryText,
    required this.secondaryText,
    required this.disabledText,
    required this.border,
    required this.divider,
    required this.primaryBlue,
    required this.positive,
    required this.negative,
    required this.warning,
    required this.navigationSurface,
    required this.navigationSelected,
    required this.navigationUnselected,
    required this.overlay,
    required this.chartGrid,
    required this.shadow,
    required this.glow,
  });

  static const light = LifeSyncColors(
    pageBackground: Color(0xFFF6F8FC),
    cardSurface: Color(0xFFFFFFFF),
    elevatedSurface: Color(0xFFFFFFFF),
    inputSurface: Color(0xFFF8FAFD),
    primaryText: Color(0xFF111318),
    secondaryText: Color(0xFF717887),
    disabledText: Color(0xFFA4A9B2),
    border: Color(0xFFE2E6ED),
    divider: Color(0xFFEDF0F4),
    primaryBlue: Color(0xFF4F83F7),
    positive: Color(0xFF30B66B),
    negative: Color(0xFFE34A5F),
    warning: Color(0xFFE7A43B),
    navigationSurface: Color(0xD9FFFFFF),
    navigationSelected: Color(0xCCE9EDF5),
    navigationUnselected: Color(0xFF7A8190),
    overlay: Color(0x66000000),
    chartGrid: Color(0xFFDDE2EA),
    shadow: Color(0x240D1525),
    glow: Color(0x334F83F7),
  );

  static const dark = LifeSyncColors(
    pageBackground: Color(0xFF202020),
    cardSurface: Color(0xFF18191D),
    elevatedSurface: Color(0xFF242529),
    inputSurface: Color(0xFF212226),
    primaryText: Color(0xFFF5F6F8),
    secondaryText: Color(0xFF999CA5),
    disabledText: Color(0xFF666971),
    border: Color(0xFF383A40),
    divider: Color(0xFF2B2D32),
    primaryBlue: Color(0xFF4F83F7),
    positive: Color(0xFF45C779),
    negative: Color(0xFFFF5267),
    warning: Color(0xFFF0A84B),
    navigationSurface: Color(0xB85E6066),
    navigationSelected: Color(0xA682858C),
    navigationUnselected: Color(0xFFA0A3AA),
    overlay: Color(0x99000000),
    chartGrid: Color(0xFF4A4C52),
    shadow: Color(0x99000000),
    glow: Color(0x594F83F7),
  );

  final Color pageBackground;
  final Color cardSurface;
  final Color elevatedSurface;
  final Color inputSurface;
  final Color primaryText;
  final Color secondaryText;
  final Color disabledText;
  final Color border;
  final Color divider;
  final Color primaryBlue;
  final Color positive;
  final Color negative;
  final Color warning;
  final Color navigationSurface;
  final Color navigationSelected;
  final Color navigationUnselected;
  final Color overlay;
  final Color chartGrid;
  final Color shadow;
  final Color glow;

  @override
  LifeSyncColors copyWith({
    Color? pageBackground,
    Color? cardSurface,
    Color? elevatedSurface,
    Color? inputSurface,
    Color? primaryText,
    Color? secondaryText,
    Color? disabledText,
    Color? border,
    Color? divider,
    Color? primaryBlue,
    Color? positive,
    Color? negative,
    Color? warning,
    Color? navigationSurface,
    Color? navigationSelected,
    Color? navigationUnselected,
    Color? overlay,
    Color? chartGrid,
    Color? shadow,
    Color? glow,
  }) {
    return LifeSyncColors(
      pageBackground: pageBackground ?? this.pageBackground,
      cardSurface: cardSurface ?? this.cardSurface,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      inputSurface: inputSurface ?? this.inputSurface,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      disabledText: disabledText ?? this.disabledText,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      primaryBlue: primaryBlue ?? this.primaryBlue,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      navigationSurface: navigationSurface ?? this.navigationSurface,
      navigationSelected: navigationSelected ?? this.navigationSelected,
      navigationUnselected: navigationUnselected ?? this.navigationUnselected,
      overlay: overlay ?? this.overlay,
      chartGrid: chartGrid ?? this.chartGrid,
      shadow: shadow ?? this.shadow,
      glow: glow ?? this.glow,
    );
  }

  @override
  LifeSyncColors lerp(covariant LifeSyncColors? other, double t) {
    if (other == null) return this;
    return LifeSyncColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      inputSurface: Color.lerp(inputSurface, other.inputSurface, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      navigationSurface: Color.lerp(
        navigationSurface,
        other.navigationSurface,
        t,
      )!,
      navigationSelected: Color.lerp(
        navigationSelected,
        other.navigationSelected,
        t,
      )!,
      navigationUnselected: Color.lerp(
        navigationUnselected,
        other.navigationUnselected,
        t,
      )!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
    );
  }
}

extension LifeSyncColorContext on BuildContext {
  LifeSyncColors get lifeSyncColors =>
      Theme.of(this).extension<LifeSyncColors>() ?? LifeSyncColors.light;
}
