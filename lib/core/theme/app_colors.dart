// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFFFFB300);
  static const Color primaryLight = Color(0xFFFFCC02);
  static const Color primaryDark = Color(0xFFFF8F00);

  // Dark Theme
  static const Color backgroundDark = Color(0xFF0A0A0F);
  static const Color surfaceDark = Color(0xFF13131A);
  static const Color surfaceElevatedDark = Color(0xFF1C1C27);
  static const Color borderDark = Color(0xFF2A2A3A);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);

  // Light Theme
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceElevatedLight = Color(0xFFF0F0F5);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color textPrimaryLight = Color(0xFF0A0A0F);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Semantic
  static const Color bull = Color(0xFF00C853);
  static const Color bullLight = Color(0xFF69F0AE);
  static const Color bear = Color(0xFFFF1744);
  static const Color bearLight = Color(0xFFFF8A80);
  static const Color neutral = Color(0xFFFFAB00);

  // Action overlays
  static const Color saveOverlay = Color(0xFF00C853);
  static const Color skipOverlay = Color(0xFFFF1744);
  static const Color readOverlay = Color(0xFF2979FF);

  // Source brand colors
  static const Color etMarketsColor = Color(0xFFFF6D00);
  static const Color moneyControlColor = Color(0xFF1565C0);
  static const Color livemintColor = Color(0xFF2E7D32);
  static const Color businessStandardColor = Color(0xFF6A1B9A);
  static const Color nseColor = Color(0xFF0277BD);
  static const Color bseColor = Color(0xFF37474F);

  // Sector heatmap colors (gradient from loss to gain)
  static const Color sectorBearStrong = Color(0xFFB71C1C);
  static const Color sectorBearMild = Color(0xFFEF9A9A);
  static const Color sectorNeutral = Color(0xFF37474F);
  static const Color sectorBullMild = Color(0xFFA5D6A7);
  static const Color sectorBullStrong = Color(0xFF1B5E20);

  // Shimmer
  static const Color shimmerBase = Color(0xFF1C1C27);
  static const Color shimmerHighlight = Color(0xFF2A2A3A);
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  static Color sourceColor(String source) {
    final lower = source.toLowerCase();
    if (lower.contains('economic times') || lower.contains('et markets')) {
      return etMarketsColor;
    } else if (lower.contains('moneycontrol')) {
      return moneyControlColor;
    } else if (lower.contains('livemint') || lower.contains('mint')) {
      return livemintColor;
    } else if (lower.contains('business standard')) {
      return businessStandardColor;
    } else if (lower.contains('nse')) {
      return nseColor;
    } else if (lower.contains('bse')) {
      return bseColor;
    }
    return primary;
  }
}
