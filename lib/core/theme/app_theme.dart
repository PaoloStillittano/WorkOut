import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryBlue,
      surface: AppColors.background,
    ),
    cardColor: AppColors.cardBackgroundLight,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      headlineMedium: AppTypography.headlineMedium,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.bodyLarge,
      labelMedium: AppTypography.labelMedium,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryBlue,
      surface: AppColors.background,
      error: AppColors.stopRed,
    ),
    cardColor: AppColors.cardBackground,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      headlineMedium: AppTypography.headlineMedium,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.bodyLarge,
      labelMedium: AppTypography.labelMedium,
    ),
  );
}
