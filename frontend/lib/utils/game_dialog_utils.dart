import 'package:tictac_duel/lib.dart';

class GameDialogUtils {
  GameDialogUtils._();

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  static Future<void> showGameResult({
    required GameResult result,
    required PlayerSymbol mySymbol,
    required RoomTheme theme,
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
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.radius16,
            side: BorderSide(color: theme.primary.withValues(alpha: 0.4)),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.w800),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary),
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
    required RoomModel room,
    required PlayerSymbol mySymbol,
    required RoomTheme theme,
  }) {
    final playerOne = room.players[0];
    final playerTwo = room.players[1];

    final isDraw = playerOne.points == playerTwo.points;

    final overallWinner = isDraw
        ? null
        : playerOne.points > playerTwo.points
        ? playerOne
        : playerTwo;

    final hasWon = overallWinner?.symbol == mySymbol;

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
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.radius16,
            side: BorderSide(color: theme.primary.withValues(alpha: 0.4)),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDraw
                    ? 'The game ended in a draw.'
                    : '${overallWinner!.name} wins the game!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              _buildScoreRow(playerOne),
              const SizedBox(height: 8),
              _buildScoreRow(playerTwo),
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
            SizedBox(height: Dimens.four),
            ElevatedButton(
              onPressed: () {
                Get.back();
                AppNavigation.goToCreateRoom();
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
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.radius16,
            side: BorderSide(color: AppColors.neonPink.withValues(alpha: 0.4)),
          ),
          title: const Text(
            'Room Closed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.neonPink,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            reason,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary),
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
            SizedBox(height: Dimens.four),
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

  static Future<void> showGameDismissed({
    required String reason,
    required RoomTheme theme,
  }) {
    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.radius16,
            side: BorderSide(color: theme.primary.withValues(alpha: 0.4)),
          ),
          title: Text(
            'Game Dismissed',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.w800),
          ),
          content: Text(
            reason,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary),
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
            SizedBox(height: Dimens.four),
            ElevatedButton(
              onPressed: () {
                Get.back();
                AppNavigation.goToCreateRoom();
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
  // SCORE
  // ===========================================================================

  static Widget _buildScoreRow(PlayerModel player) {
    return Row(
      children: [
        Expanded(
          child: Text(
            player.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${player.points}',
          style: const TextStyle(
            color: AppColors.neonCyan,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
