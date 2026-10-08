import 'package:tictac_duel/lib.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
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
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',

      colorScheme: colorScheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),

      textTheme: const TextTheme(
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
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, Dimens.elevatedButtonHeight),
          ),
          padding: const WidgetStatePropertyAll(
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
          textStyle: const WidgetStatePropertyAll(
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
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, Dimens.elevatedButtonHeight),
          ),
          padding: const WidgetStatePropertyAll(
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
          textStyle: const WidgetStatePropertyAll(
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
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimens.elevatedButtonHeight),
          ),
          padding: const WidgetStatePropertyAll(
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
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: Dimens.fontSm,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.sixteen,
          vertical: Dimens.fourteen,
        ),

        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
        ),

        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w500,
        ),

        floatingLabelStyle: const TextStyle(
          color: AppColors.neonPurple,
          fontSize: Dimens.fontSm,
          fontWeight: FontWeight.w600,
        ),

        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.border, width: 1.2),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.border, width: 1.2),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.neonPurple, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.neonPink, width: 1.2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.neonPink, width: 1.5),
        ),

        errorStyle: const TextStyle(
          color: AppColors.neonPink,
          fontSize: Dimens.fontXs,
          fontWeight: FontWeight.w500,
        ),

        counterStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: Dimens.fontXs,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.neonCyan,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd),
          side: const BorderSide(color: AppColors.neonCyan, width: 1.2),
        ),
        iconSize: Dimens.twentyFour,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.twentyFour,
          vertical: Dimens.twentyFour,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.radius16,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: Dimens.twenty,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: Dimens.sixteen,
          height: 1.5,
        ),
      ),
    );
  }
}
