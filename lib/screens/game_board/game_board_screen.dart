import 'package:tictac_duel/lib.dart';

class GameBoardScreen extends GetView<GameBoardController> {
  const GameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NeonBackgroundWidget(
        title: 'LOCAL GAME',
        child: Stack(
          alignment: Alignment.center,
          children: [
            GameWidget(
              localGame: controller.game,

              // Board
              board: controller.board,
              winningIndexes: controller.winningIndexes,

              // Turn
              currentPlayer: controller.currentPlayer,
              turnIndex: controller.turnIndex,

              // Round
              currentRound: controller.currentRound,

              // Interaction
              canMakeMove: controller.canMakeMove,
              onCellTap: controller.onCellTap,

              // Points
              playerOnePoints: controller.playerOnePoints,
              playerTwoPoints: controller.playerTwoPoints,
            ),

            GameRoundAnimationWidget(
              showRoundAnimation: controller.showRoundAnimation,
              animatedRound: controller.animatedRound,
            ),
          ],
        ),
      ),
    );
  }
}
