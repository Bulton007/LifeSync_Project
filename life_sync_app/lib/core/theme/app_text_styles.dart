import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  );

  // ============================================================
  // TITLES
  // ============================================================

  static TextStyle get titleXL => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.30,
  );

  static TextStyle get titleL => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle get titleM => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  // ============================================================
  // BODY
  // ============================================================

  static TextStyle get bodyL => GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static TextStyle get bodyPrimary => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  // ============================================================
  // BUTTON AND ACTION
  // ============================================================

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.40,
  );

  // ============================================================
  // CAPTION
  // ============================================================

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  // ============================================================
  // MICRO AND OVERLINE
  // ============================================================

  static TextStyle get micro => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  const AppTextStyles._();
}
