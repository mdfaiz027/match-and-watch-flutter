import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppStyles {
  // Semantic Text Theme - Follows Brand Tokens
  static const TextTheme semanticTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textMain,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textMain,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textMain,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textMain,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.textMain,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AppColors.textMuted,
    ),
  );

  // Common Decorations
  static InputDecoration inputDecoration({
    required String label,
    required double borderRadius,
  }) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primaryGold),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryGold),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      );
}
