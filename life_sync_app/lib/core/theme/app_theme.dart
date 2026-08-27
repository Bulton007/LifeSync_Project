import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';

import 'app_colors.dart';
import 'app_radius.dart';
abstract final class AppTheme {
  static ThemeData get light {
    final baseTextTheme = TextTheme(
      displayLarge: AppTextStyles.hero,
      headlineLarge: AppTextStyles.titleXL,
      headlineMedium: AppTextStyles.titleL,
      titleLarge: AppTextStyles.titleM,
      bodyLarge: AppTextStyles.bodyL,
      bodyMedium: AppTextStyles.bodyPrimary,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelSmall: AppTextStyles.micro,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ============================================================
      // GLOBAL COLORS
      // ============================================================

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primary100,
        onPrimaryContainer: AppColors.primary700,
        secondary: AppColors.primary500,
        onSecondary: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnError,
        outline: AppColors.border,
      ),

      // ============================================================
      // TYPOGRAPHY
      // ============================================================

      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: baseTextTheme,

      // ============================================================
      // APP BAR
      // ============================================================

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleM,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      // ============================================================
      // CARDS
      // ============================================================

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      // ============================================================
      // DIVIDERS
      // ============================================================

      dividerColor: AppColors.border,

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ============================================================
      // INPUT FIELDS
      // ============================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.bodyPrimary.copyWith(
          color: AppColors.textSecondary,
        ),
        labelStyle: AppTextStyles.bodyPrimary,
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.disabled,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ============================================================
      // ELEVATED BUTTON
      // ============================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.textSecondary,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // ============================================================
      // OUTLINED BUTTON
      // ============================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          side: const BorderSide(
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // ============================================================
      // TEXT BUTTON
      // ============================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      // ============================================================
      // ICON BUTTON
      // ============================================================

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          disabledForegroundColor: AppColors.textDisabled,
        ),
      ),

      // ============================================================
      // FLOATING ACTION BUTTON
      // ============================================================

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: CircleBorder(),
      ),

      // ============================================================
      // ICONS
      // ============================================================

      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
      ),

      // ============================================================
      // CHECKBOX
      // ============================================================

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        side: const BorderSide(
          color: AppColors.border,
        ),
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return Colors.transparent;
          },
        ),
        checkColor: const WidgetStatePropertyAll<Color>(
          AppColors.textOnPrimary,
        ),
      ),

      // ============================================================
      // RADIO
      // ============================================================

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabledBackground;
            }

            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.textSecondary;
          },
        ),
      ),

      // ============================================================
      // SWITCH
      // ============================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabledBackground;
            }

            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.disabled;
          },
        ),
        trackOutlineColor:
            const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),

      // ============================================================
      // PROGRESS INDICATORS
      // ============================================================

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.disabled,
        circularTrackColor: AppColors.disabled,
      ),

      // ============================================================
      // CHIPS
      // ============================================================

      chipTheme: ChipThemeData(
        elevation: 0,
        backgroundColor: AppColors.accent,
        selectedColor: AppColors.primary100,
        disabledColor: AppColors.disabled,
        labelStyle: AppTextStyles.caption,
        secondaryLabelStyle: AppTextStyles.caption.copyWith(
          color: AppColors.primary700,
        ),
        side: const BorderSide(
          color: AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      // ============================================================
      // LIST TILES
      // ============================================================

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        contentPadding: EdgeInsets.zero,
      ),

      // ============================================================
      // DIALOG
      // ============================================================

      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: AppTextStyles.titleM,
        contentTextStyle: AppTextStyles.bodyPrimary,
      ),

      // ============================================================
      // BOTTOM SHEET
      // ============================================================

      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        modalElevation: 0,
        backgroundColor: AppColors.surface,
        modalBackgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),

      // ============================================================
      // SNACKBAR
      // ============================================================

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.foreground,
        contentTextStyle: AppTextStyles.bodyPrimary.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  const AppTheme._();
}
