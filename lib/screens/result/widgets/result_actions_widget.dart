import 'package:tictac_duel/lib.dart';

class ResultActionsWidget extends StatelessWidget {
  const ResultActionsWidget({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.sixteen,
      children: [
        const Expanded(
          child: NeonOutlinedButtonWidget(
            label: 'HOME',
            onPressed: AppNavigation.goToHome,
          ),
        ),
        Expanded(
          child: NeonElevatedButton(
            label: isOnline ? 'NEW ROOM' : 'NEW GAME',
            onPressed: _onNewGame,
          ),
        ),
      ],
    );
  }

  void _onNewGame() {
    if (isOnline) {
      AppNavigation.goToCreateRoom();
      return;
    }

    AppNavigation.goToLocalGame();
  }
}
