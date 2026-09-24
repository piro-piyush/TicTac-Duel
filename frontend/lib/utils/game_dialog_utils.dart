import 'package:tictac_duel/lib.dart';

class GameDialogUtils {
  GameDialogUtils._();

  static Future<void> showGameResult({
    required BuildContext context,
    required GameResult result,
    required PlayerSymbol mySymbol,
    required RoomTheme theme,
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
          backgroundColor: Themes.surface,
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
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Themes.textPrimary,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                // context.read<RoomDataProvider>().clearBoard();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}