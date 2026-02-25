// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
    ),
    displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
    ),
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
    ),
    headlineLarge: GoogleFonts.spaceGrotesk(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryDark,
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryDark,
    ),
    labelLarge: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    labelMedium: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondaryDark,
    ),
    labelSmall: GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryDark,
    ),
  );

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
    ),
    displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
    ),
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
    ),
    headlineLarge: GoogleFonts.spaceGrotesk(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryLight,
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryLight,
    ),
    labelLarge: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
    labelMedium: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondaryLight,
    ),
    labelSmall: GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryLight,
    ),
  );

  // Monospace for prices
  static TextStyle priceStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
}
