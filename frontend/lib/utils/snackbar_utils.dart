import 'package:tictac_duel/lib.dart';

class SnackbarUtils {
  SnackbarUtils._();

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
  // HIDE
  // ===========================================================================

  static void hide() {
    Get.closeCurrentSnackbar();
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
    Get.closeCurrentSnackbar();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: Dimens.edgeInsets8.copyWith(bottom: 12),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      showProgressIndicator: false,
      icon: Icon(icon, color: color),
      titleText: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
