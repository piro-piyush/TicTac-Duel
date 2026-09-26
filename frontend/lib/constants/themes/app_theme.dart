import 'package:tictac_duel/lib.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonPurple,
        onPrimary: AppColors.textPrimary,

        secondary: AppColors.neonCyan,
        onSecondary: AppColors.background,

        tertiary: AppColors.neonPink,
        onTertiary: AppColors.textPrimary,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,

        error: AppColors.neonPink,
        onError: AppColors.textPrimary,

        outline: AppColors.border,
        outlineVariant: AppColors.border,

        surfaceContainerHighest: AppColors.card,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font9Xl,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font8Xl,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
          height: 1.1,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font7Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.15,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font6Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font5Xl,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          height: 1.2,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.font4Xl,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.fontXl,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.fontLg,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontMd,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.fontMd,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontXs,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.2,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontXs,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          height: 1.2,
        ),
        labelSmall: TextStyle(
          color: AppColors.textSecondary,
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
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.neonPurple.withValues(alpha: 0.8);
            }

            return AppColors.neonPurple;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary;
            }

            return AppColors.textPrimary;
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.textPrimary.withValues(alpha: 0.08),
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
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.textPrimary;
            }

            return AppColors.neonPurple;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.neonPurple.withValues(alpha: 0.12);
            }

            return Colors.transparent;
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.neonPurple.withValues(alpha: 0.08),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: AppColors.disabled);
            }

            if (states.contains(WidgetState.pressed)) {
              return const BorderSide(color: AppColors.neonPurple, width: 1.5);
            }

            return const BorderSide(color: AppColors.border, width: 1.2);
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
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.neonPurple;
            }

            return AppColors.textSecondary;
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.neonPurple.withValues(alpha: 0.08),
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
