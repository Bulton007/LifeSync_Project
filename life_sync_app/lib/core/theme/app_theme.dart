import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light, LifeSyncColors.light);

  static ThemeData get dark => _build(Brightness.dark, LifeSyncColors.dark);

  static ThemeData _build(Brightness brightness, LifeSyncColors colors) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF243A68)
          : const Color(0xFFDCE7FF),
      onPrimaryContainer: isDark
          ? const Color(0xFFDCE7FF)
          : const Color(0xFF153769),
      secondary: colors.primaryBlue,
      onSecondary: Colors.white,
      error: colors.negative,
      onError: Colors.white,
      surface: colors.cardSurface,
      onSurface: colors.primaryText,
      outline: colors.border,
      shadow: colors.shadow,
      scrim: colors.overlay,
    );
    final textTheme = TextTheme(
      displayLarge: AppTextStyles.hero,
      headlineLarge: AppTextStyles.titleXL,
      headlineMedium: AppTextStyles.titleL,
      titleLarge: AppTextStyles.titleM,
      bodyLarge: AppTextStyles.bodyL,
      bodyMedium: AppTextStyles.bodyPrimary,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelSmall: AppTextStyles.micro,
    ).apply(bodyColor: colors.primaryText, displayColor: colors.primaryText);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: colors.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      scaffoldBackgroundColor: colors.pageBackground,
      canvasColor: colors.pageBackground,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: colors.pageBackground,
        foregroundColor: colors.primaryText,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.titleM.copyWith(
          color: colors.primaryText,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: colors.pageBackground,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: colors.pageBackground,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.cardSurface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerColor: colors.divider,
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputSurface,
        hintStyle: AppTextStyles.bodyPrimary.copyWith(
          color: colors.secondaryText,
        ),
        labelStyle: AppTextStyles.bodyPrimary.copyWith(
          color: colors.secondaryText,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: colors.negative),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.primaryBlue, width: 1.5),
        ),
        disabledBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.divider),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.negative),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.negative, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.divider,
          disabledForegroundColor: colors.disabledText,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.divider,
          disabledForegroundColor: colors.disabledText,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryBlue,
          disabledForegroundColor: colors.disabledText,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 48),
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryBlue,
          disabledForegroundColor: colors.disabledText,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.primaryText,
          disabledForegroundColor: colors.disabledText,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: colors.primaryBlue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      iconTheme: IconThemeData(color: colors.primaryText),
      checkboxTheme: CheckboxThemeData(
        shape: const CircleBorder(),
        side: BorderSide(color: colors.border),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) return colors.divider;
          if (states.contains(WidgetState.selected)) return colors.primaryBlue;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) return colors.disabledText;
          if (states.contains(WidgetState.selected)) return colors.primaryBlue;
          return colors.secondaryText;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) return colors.primaryBlue;
          return colors.divider;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primaryBlue,
        linearTrackColor: colors.divider,
        circularTrackColor: colors.divider,
      ),
      chipTheme: ChipThemeData(
        elevation: 0,
        backgroundColor: colors.inputSurface,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colors.divider,
        labelStyle: AppTextStyles.caption.copyWith(color: colors.primaryText),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.secondaryText,
        textColor: colors.primaryText,
        contentPadding: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: colors.elevatedSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: AppTextStyles.titleM.copyWith(
          color: colors.primaryText,
        ),
        contentTextStyle: AppTextStyles.bodyPrimary.copyWith(
          color: colors.secondaryText,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        modalElevation: 0,
        backgroundColor: colors.elevatedSurface,
        modalBackgroundColor: colors.elevatedSurface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.elevatedSurface,
        contentTextStyle: AppTextStyles.bodyPrimary.copyWith(
          color: colors.primaryText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.border),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  const AppTheme._();
}
