import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends GetView<LocalGameBoardController> {
  const LocalGameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await GameDialogUtils.confirmQuit();

        if (shouldQuit) {
          controller.quitGame();
        }
      },
      child: Obx(() {
        final game = controller.game;
        final currentPlayer = controller.currentPlayer;

        return TicTacToeGameTemplateWidget(
          currentRound: controller.currentRound,
          maxRounds: game.maxRounds,
          player: currentPlayer,
          isMe: (id) => id == controller.playerId,
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
                playerOne: game.playerOne,
                playerTwo: game.playerTwo,
                isOnline: false,
              ),
              GameRoundAnimationWidget(
                showRoundAnimation: controller.showRoundAnimation,
                animatedRound: controller.animatedRound,
              ),
            ],
          ),
        );
      }),
    );
  }
}
