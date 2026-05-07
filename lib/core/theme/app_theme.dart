import 'package:flutter/material.dart';

class AppTheme {
  static const Color cinematicGold = Color(0xFFFFC107);
  static const Color deepBackground = Color(0xFF121212);
  static const Color surfaceGrey = Color(0xFF1E1E1E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.dark(
        primary: cinematicGold,
        secondary: cinematicGold,
        tertiary: cinematicGold,
        background: deepBackground,
        surface: surfaceGrey,
        onPrimary: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white70,
      ),
      
      scaffoldBackgroundColor: deepBackground,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: surfaceGrey,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cinematicGold,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
