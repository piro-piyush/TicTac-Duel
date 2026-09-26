import 'package:tictac_duel/lib.dart';

class GameDialogUtils {
  GameDialogUtils._();

  static Future<void> showGameResult({
    required BuildContext context,
    required GameResult result,
    required PlayerSymbol mySymbol,
    required RoomTheme theme,
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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

        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showGameFinished({
    required BuildContext context,
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

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: theme.primary.withValues(alpha: 0.4),
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDraw
                    ? 'The game ended in a draw.'
                    : '${overallWinner!.name} wins the game!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
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
                Navigator.of(context).pop();
                Routes.goToHome();
              },
              child: const Text('Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Routes.goToCreateRoom();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

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
