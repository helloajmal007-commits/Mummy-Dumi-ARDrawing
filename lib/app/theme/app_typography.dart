import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _displayBase => GoogleFonts.plusJakartaSans(
    color: AppColors.ink,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );

  static TextStyle get _bodyBase =>
      GoogleFonts.sora(color: AppColors.ink, fontWeight: FontWeight.w400);

  static TextStyle get h1 => _displayBase.copyWith(fontSize: 28, height: 1.2);

  static TextStyle get h2 => _displayBase.copyWith(fontSize: 22, height: 1.25);

  static TextStyle get h3 =>
      _displayBase.copyWith(fontSize: 17, height: 1.3, letterSpacing: -0.2);

  static TextStyle get bodyLarge =>
      _bodyBase.copyWith(fontSize: 16, height: 1.45);

  static TextStyle get body => _bodyBase.copyWith(fontSize: 14, height: 1.45);

  static TextStyle get bodySmall => _bodyBase.copyWith(
    fontSize: 12.5,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  static TextStyle get label => GoogleFonts.sora(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.inkMuted,
  );

  static TextStyle get caption => GoogleFonts.sora(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.inkFaint,
  );

  static TextStyle get button => GoogleFonts.sora(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}