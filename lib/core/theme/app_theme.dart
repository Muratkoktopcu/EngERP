import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

/// 🎨 ENG ERP Ana Tema Tanımı
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryLighter,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.grey600,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorBackground,
        onErrorContainer: AppColors.error,
        surface: AppColors.white,
        onSurface: AppColors.textOnSurface,
        surfaceContainerHighest: AppColors.backgroundLight,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: AppShadows.appBarElevation,
        centerTitle: false,
        titleTextStyle: AppTypography.appBarTitle,
      ),

      cardTheme: CardTheme(
        elevation: AppShadows.cardElevation,
        shape: AppRadius.cardBorder,
        color: AppColors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.grey300,
          foregroundColor: AppColors.textOnSurface,
          elevation: AppShadows.buttonElevation,
          shape: AppRadius.buttonBorder,
          textStyle: AppTypography.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: AppRadius.outlineInputBorder,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        hintStyle: AppTypography.hintText,
        labelStyle: AppTypography.labelMedium,
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
  }
}
