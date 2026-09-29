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
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.theme.colorScheme.onSurface),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                onConfirm?.call();
              },
              child: const Text('OK'),
            ),
          ],
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
}
