import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends GetView<LocalGameBoardController> {
  const LocalGameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final game = controller.game;
      final currentPlayer = controller.currentPlayer;

      return TicTacToeGameScreen(
        title: 'LOCAL GAME',
        currentRound: controller.currentRound,
        maxRounds: game.maxRounds,
        player: currentPlayer,
        status: '${currentPlayer.name}\'s turn',
        theme: game.theme,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TicTacToeGameWidget(
              theme: game.theme,
              board: controller.board,
              winningIndexes: controller.winningIndexes,
              turnIndex: controller.turnIndex,
              isMyTurn: controller.canMakeMove,
              onCellTap: controller.onCellTap,
              playerOneBuilder: (compact) {
                return GamePlayerCardWidget.local(
                  player: game.playerOne,
                  points: controller.playerOnePoints,
                  isTurn: controller.turnIndex == 0,
                  theme: game.theme,
                  compact: compact,
                );
              },
              playerTwoBuilder: (compact) {
                return GamePlayerCardWidget.local(
                  player: game.playerTwo,
                  points: controller.playerTwoPoints,
                  isTurn: controller.turnIndex == 1,
                  theme: game.theme,
                  compact: compact,
                );
              },

            ),
            GameRoundAnimationWidget(
              showRoundAnimation: controller.showRoundAnimation,
              animatedRound: controller.animatedRound,
            ),
          ],
        ),
      );
    });
  }
}