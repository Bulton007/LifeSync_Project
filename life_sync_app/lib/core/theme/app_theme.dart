import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      // ============================================================
      // GLOBAL COLORS
      // ============================================================

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary500,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // ============================================================
      // GLOBAL FONT
      // ============================================================

      fontFamily: GoogleFonts.poppins().fontFamily,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.hero,
        headlineLarge: AppTextStyles.titleXL,
        headlineMedium: AppTextStyles.titleL,
        titleLarge: AppTextStyles.titleM,
        bodyLarge: AppTextStyles.bodyL,
        bodyMedium: AppTextStyles.bodyPrimary,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.micro,
      ),

      // ============================================================
      // APP BAR
      // ============================================================

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleM,
        iconTheme: const IconThemeData(
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
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      // ============================================================
      // DIVIDERS
      // ============================================================

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

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.md,
          ),
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
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.md,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),

      // ============================================================
      // OUTLINED BUTTON
      // ============================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
          side: const BorderSide(
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.md,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),

      // ============================================================
      // TEXT BUTTON
      // ============================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),

      // ============================================================
      // FLOATING ACTION BUTTON
      // ============================================================

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(
          color: AppColors.border,
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return Colors.transparent;
          },
        ),
      ),

      // ============================================================
      // SWITCH
      // ============================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return AppColors.disabled;
          },
        ),
      ),

      // ============================================================
      // DIALOG
      // ============================================================

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
        ),
      ),

      // ============================================================
      // BOTTOM SHEET
      // ============================================================

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),
    );
  }

  const AppTheme._();
}