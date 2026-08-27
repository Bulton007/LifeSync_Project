import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Global typography system.
///
/// Do not create unrelated GoogleFonts styles inside pages.
/// Reuse these styles and use copyWith only when necessary.
abstract final class AppTextStyles {
  // ============================================================
  // HERO
  // ============================================================

  static TextStyle get hero => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // TITLES
  // ============================================================

  static TextStyle get titleXL => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.30,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleL => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleM => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.40,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // BODY
  // ============================================================

  static TextStyle get bodyL => GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyPrimary => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // BUTTON AND ACTION
  // ============================================================

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.40,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // CAPTION
  // ============================================================

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textSecondary,
      );

  // ============================================================
  // MICRO AND OVERLINE
  // ============================================================

  static TextStyle get micro => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.40,
        color: AppColors.textSecondary,
      );

  const AppTextStyles._();
}