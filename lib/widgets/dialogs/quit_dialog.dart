import 'package:tictac_duel/lib.dart';

class QuitDialog extends StatelessWidget {
  const QuitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quit Game?'),
      content: const Text('Are you sure you want to quit the current game?'),
      actions: [
        Row(
          spacing: Dimens.twelve,
          children: [
            Expanded(
              child: NeonOutlinedButtonWidget(
                onPressed: () => context.pop(),
                label: 'CANCEL',
              ),
            ),
            Expanded(
              child: NeonElevatedButton(
                onPressed: () => context.pop(true),
                label: 'QUIT',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
