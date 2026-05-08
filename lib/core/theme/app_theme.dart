import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import '../constants/app_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGold,
        secondary: AppColors.goldVariant,
        tertiary: AppColors.goldDark,
        surface: AppColors.deepBackground,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
      ),
      
      scaffoldBackgroundColor: AppColors.deepBackground,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryGold),
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surfaceGrey,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingS,
          ),
        ),
      ),
      
      textTheme: AppStyles.semanticTextTheme,
    );
  }
  
  // Backward compatibility aliases if needed
  static const Color cinematicGold = AppColors.primaryGold;
  static const Color deepBackground = AppColors.deepBackground;
  static const Color surfaceGrey = AppColors.surfaceGrey;
}
