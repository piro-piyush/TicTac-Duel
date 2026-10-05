import 'package:tictac_duel/lib.dart';

class GameDialogUtils {
  GameDialogUtils._();

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  static Future<void> showGameResult({
    required GameResult result,
    required PlayerSymbol mySymbol,
    VoidCallback? onConfirm,
  }) {
    final isDraw = result == GameResult.draw;
    final hasWon = result.winner == mySymbol;

    final title = isDraw
        ? 'Draw'
        : hasWon
        ? 'You Won!'
        : 'You Lose';

    final message = isDraw
        ? 'The round ended in a draw.'
        : hasWon
        ? 'You won this round!'
        : 'Your opponent won this round.';

    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: _dialogShape,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Get.theme.colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.sixteen,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurface,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onConfirm?.call();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // ROOM CLOSED
  // ===========================================================================

  static Future<void> showRoomClosed({required String reason}) {
    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: _dialogShape,
          title: Text(
            'Room Closed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.sixteen,
            children: [
              Text(
                reason,
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.colorScheme.onSurface),
              ),
              Row(
                spacing: Dimens.twelve,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        AppNavigation.goToHome();
                      },
                      child: const Text('BACK HOME'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        AppNavigation.replaceCreateRoom();
                      },
                      child: const Text('NEW GAME'),
                    ),
                  ),
                ],
              ),
            ],
          ),

          actionsAlignment: MainAxisAlignment.center,
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // GAME DISMISSED
  // ===========================================================================

  static Future<void> showGameDismissed({
    required GameDismissedResponse response,
  }) {
    final reason = response.reason;

    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: _dialogShape,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          icon: Icon(reason.icon, color: reason.color, size: 48),
          title: Text(
            'Game Dismissed',
            textAlign: TextAlign.center,
            style: TextStyle(color: reason.color, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Text(
                reason.message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.colorScheme.onSurface),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        AppNavigation.goToHome();
                      },
                      child: const Text('BACK HOME'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        AppNavigation.replaceCreateRoom();
                      },
                      child: const Text('NEW GAME'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  static RoundedRectangleBorder get _dialogShape => RoundedRectangleBorder(
    borderRadius: Dimens.radius16,
    side: BorderSide(
      color: Get.theme.colorScheme.primary.withValues(alpha: 0.4),
    ),
  );

  // ===========================================================================
  // QUIT CONFIRMATION
  // ===========================================================================

  static Future<bool> confirmQuit() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Quit Game?'),
        content: const Text('Are you sure you want to quit the current game?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('QUIT'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result == true;
  }
}
