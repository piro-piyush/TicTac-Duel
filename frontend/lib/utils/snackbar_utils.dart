import 'package:tictac_duel/lib.dart';

class SnackbarUtils {
  SnackbarUtils._();

  static void showInfo(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message: message,
      color: AppColors.neonCyan,
      icon: Icons.info_outline_rounded,
    );
  }

  static void showSuccess(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message: message,
      color: Colors.greenAccent,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showWarning(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message: message,
      color: AppColors.neonPurple,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void showError(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message: message,
      color: AppColors.neonPink,
      icon: Icons.error_outline_rounded,
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  static void _show(
      BuildContext context, {
        required String message,
        required Color color,
        required IconData icon,
      }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.surface,
          showCloseIcon: true,closeIconColor: AppColors.textPrimary,
          dismissDirection: DismissDirection.horizontal,
          margin: Dimens.edgeInsets8.copyWith(
            bottom: 12
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.radius12,
          ),
          elevation: 4,
          content: Row(
            spacing: 12,
            children: [
              Icon(
                icon,
                color: color,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}