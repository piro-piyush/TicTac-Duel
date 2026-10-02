import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends GetView<LocalGameBoardController> {
  const LocalGameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final game = controller.game;
      final currentPlayer = controller.currentPlayer;

      return TicTacToeGameTemplateWidget(
        title: 'LOCAL GAME',
        currentRound: controller.currentRound,
        maxRounds: game.maxRounds,
        player: currentPlayer,
        isMe: (id) => currentPlayer.id == id,
        theme: game.theme,
        isOnline: false,
        showGameStatus: true,
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
              playerOnePoints: controller.playerOnePoints,
              playerTwoPoints: controller.playerTwoPoints,
              playerId: currentPlayer.id,
              playerOne: controller.currentPlayer,
              playerTwo: controller.opponentPlayer,
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
