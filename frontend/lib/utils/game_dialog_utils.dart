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
  // GAME FINISHED
  // ===========================================================================

  static Future<void> showGameFinished({
    required String playerOneName,
    required PlayerSymbol playerOneSymbol,
    required int playerOneScore,
    required String playerTwoName,
    required PlayerSymbol playerTwoSymbol,
    required int playerTwoScore,
    required PlayerSymbol mySymbol,
  }) {
    final isDraw = playerOneScore == playerTwoScore;

    final winnerName = isDraw
        ? null
        : playerOneScore > playerTwoScore
        ? playerOneName
        : playerTwoName;

    final winnerSymbol = isDraw
        ? null
        : playerOneScore > playerTwoScore
        ? playerOneSymbol
        : playerTwoSymbol;

    final hasWon = winnerSymbol == mySymbol;

    final title = isDraw
        ? 'Game Draw'
        : hasWon
        ? 'You Won!'
        : 'You Lose';

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDraw
                    ? 'The game ended in a draw.'
                    : '$winnerName wins the game!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _buildScoreRow(
                playerOneName,
                playerOneScore,
              ),
              const SizedBox(height: 8),
              _buildScoreRow(
                playerTwoName,
                playerTwoScore,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                AppNavigation.goToHome();
              },
              child: const Text('Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                AppNavigation.pushLocalGame();
              },
              child: const Text('New Game'),
            ),
          ],
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
          content: Text(
            reason,
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.theme.colorScheme.onSurface),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                AppNavigation.replaceHome();
              },
              child: const Text('Back Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                AppNavigation.replaceCreateRoom();
              },
              child: const Text('Create Room'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // GAME DISMISSED
  // ===========================================================================

  static Future<void> showGameDismissed({required String reason}) {
    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: _dialogShape,
          title: Text(
            'Game Dismissed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            reason,
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.theme.colorScheme.onSurface),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
                AppNavigation.goToHome();
              },
              child: const Text('Back Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                AppNavigation.replaceCreateRoom();
              },
              child: const Text('New Game'),
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

  static Widget _buildScoreRow(
      String playerName,
      int score,
      ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            playerName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Get.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '$score',
          style: TextStyle(
            color: Get.theme.colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
