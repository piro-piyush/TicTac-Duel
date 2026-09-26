import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF080B14);
  static const Color surface = Color(0xFF121827);
  static const Color card = Color(0xFF1A2235);

  // Neon
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color neonPink = Color(0xFFFF2E93);
  static const Color neonGreen = Color(0xFF39FF14);

  // Players
  static const Color playerX = neonCyan;
  static const Color playerO = neonPink;

  // Text
  static const Color textPrimary = Color(0xFFF5F7FF);
  static const Color textSecondary = Color(0xFF929BB0);

  // UI
  static const Color border = Color(0xFF29334A);
  static const Color disabled = Color(0xFF454D60);

  // Game Status
  static const Color win = neonGreen;
  static const Color draw = Color(0xFFFFD166);
}
