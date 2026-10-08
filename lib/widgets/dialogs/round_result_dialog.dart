import 'package:tictac_duel/lib.dart';

class RoundResultDialog extends StatelessWidget {
  const RoundResultDialog({
    required this.result,
    required this.mySymbol,
    this.onConfirm,
    super.key,
  });

  final GameResult result;
  final PlayerSymbol mySymbol;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
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
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
            onConfirm?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
