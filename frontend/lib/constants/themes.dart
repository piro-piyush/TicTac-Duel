import 'package:flutter/material.dart';

class Themes {
  Themes._();

  // Background Colors
  static const Color background = Color(0xFF080B14);
  static const Color surface = Color(0xFF121827);
  static const Color card = Color(0xFF1A2235);

  // Neon Colors
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color neonPink = Color(0xFFFF2E93);
  static const Color neonGreen = Color(0xFF39FF14);

  // Player Colors
  static const Color playerX = neonCyan;
  static const Color playerO = neonPink;

  // Text Colors
  static const Color textPrimary = Color(0xFFF5F7FF);
  static const Color textSecondary = Color(0xFF929BB0);

  // UI Colors
  static const Color border = Color(0xFF29334A);
  static const Color disabled = Color(0xFF454D60);

  // Game Status Colors
  static const Color win = neonGreen;
  static const Color draw = Color(0xFFFFD166);

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'Poppins',

      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPurple,
        surface: surface,
        error: neonPink,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPurple,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }
}
