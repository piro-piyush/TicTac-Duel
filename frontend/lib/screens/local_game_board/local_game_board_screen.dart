import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends GetView<LocalGameBoardController> {
  const LocalGameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => NeonBackgroundWidget(
        title: 'LOCAL GAME',
        child: Stack(
          alignment: Alignment.center,
          children: [
            LocalGameWidget(
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