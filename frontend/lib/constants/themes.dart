import 'package:flutter/material.dart';

import 'dimens.dart';

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
        primary: neonPurple,
        onPrimary: textPrimary,

        secondary: neonCyan,
        onSecondary: background,

        tertiary: neonPink,
        onTertiary: textPrimary,

        surface: surface,
        onSurface: textPrimary,

        error: neonPink,
        onError: textPrimary,

        outline: border,
        outlineVariant: border,

        surfaceContainerHighest: card,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font9Xl,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          height: 1.1,
        ),

        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font8Xl,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
          height: 1.1,
        ),

        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font7Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.15,
        ),

        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font6Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          height: 1.2,
        ),

        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font5Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          height: 1.2,
        ),

        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: Dimens.font4Xl,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),

        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: Dimens.fontXl,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          height: 1.3,
        ),

        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: Dimens.fontLg,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.3,
        ),

        titleSmall: TextStyle(
          color: textSecondary,
          fontSize: Dimens.fontMd,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          height: 1.3,
        ),

        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: Dimens.fontMd,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),

        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),

        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: Dimens.fontXs,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),

        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.2,
        ),

        labelMedium: TextStyle(
          color: textSecondary,
          fontSize: Dimens.fontXs,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          height: 1.2,
        ),

        labelSmall: TextStyle(
          color: textSecondary,
          fontSize: Dimens.font2Xs,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          height: 1.2,
        ),
      ),



      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(
            Size(double.infinity, Dimens.elevatedButtonHeight),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: Dimens.twentyFour,
              vertical: Dimens.eight,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return neonPurple.withValues(alpha: 0.8);
            }

            return neonPurple;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return textSecondary;
            }

            return textPrimary;
          }),
          overlayColor: WidgetStatePropertyAll(
            textPrimary.withValues(alpha: 0.08),
          ),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusMd),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: Dimens.fontSm,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(
            Size(double.infinity, Dimens.elevatedButtonHeight),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: Dimens.twentyFour,
              vertical: Dimens.eight,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return textPrimary;
            }

            return neonPurple;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return neonPurple.withValues(alpha: 0.12);
            }

            return Colors.transparent;
          }),
          overlayColor: WidgetStatePropertyAll(
            neonPurple.withValues(alpha: 0.08),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: disabled);
            }

            if (states.contains(WidgetState.pressed)) {
              return const BorderSide(color: neonPurple, width: 1.5);
            }

            return const BorderSide(color: border, width: 1.2);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusMd),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: Dimens.fontSm,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(
            Size(0, Dimens.elevatedButtonHeight),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: Dimens.sixteen,
              vertical: Dimens.eight,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return neonPurple;
            }

            return textSecondary;
          }),
          overlayColor: WidgetStatePropertyAll(
            neonPurple.withValues(alpha: 0.08),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusMd),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: Dimens.fontSm,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
