import 'package:tictac_duel/lib.dart';

class PopupUtils {
  PopupUtils._();

  // ===========================================================================
  // INFO
  // ===========================================================================

  static void showInfo(String message) {
    _show(
      title: 'Info',
      message: message,
      color: AppColors.neonCyan,
      icon: Icons.info_outline_rounded,
    );
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================

  static void showSuccess(String message) {
    _show(
      title: 'Success',
      message: message,
      color: Colors.greenAccent,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  // ===========================================================================
  // WARNING
  // ===========================================================================

  static void showWarning(String message) {
    _show(
      title: 'Warning',
      message: message,
      color: AppColors.neonPurple,
      icon: Icons.warning_amber_rounded,
    );
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  static void showError(String message) {
    _show(
      title: 'Error',
      message: message,
      color: AppColors.neonPink,
      icon: Icons.error_outline_rounded,
    );
  }

  // ===========================================================================
  // TOAST
  // ===========================================================================

  static void showToast(String message) {
    final messenger = AppPages.rootScaffoldMessengerKey.currentState;

    if (messenger == null) {
      return;
    }

    final context = AppPages.rootNavigatorKey.currentContext;

    if (context == null) {
      return;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: Dimens.edgeInsets12,
            margin: Dimens.edgeInsets30_0,
            decoration: BoxDecoration(
              borderRadius: Dimens.radius6,
              color: isDarkMode
                  ? AppColors.darkerGrey.withValues(alpha: 0.9)
                  : AppColors.grey.withValues(alpha: 0.9),
            ),
            child: Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ),
      );
  }

  // ===========================================================================
  // HIDE
  // ===========================================================================

  static void hide() {
    AppPages.rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  // ===========================================================================
  // PRIVATE
  // ===========================================================================

  static void _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    final messenger = AppPages.rootScaffoldMessengerKey.currentState;

    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: Dimens.edgeInsets8.copyWith(bottom: 12),
          content: Container(
            padding: Dimens.edgeInsets12,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: Dimens.radius12,
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
