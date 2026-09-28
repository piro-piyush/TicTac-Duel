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
              playerId: controller.game.playerOne.id,
              board: controller.board,
              isMyTurn: controller.turnIndex == 0,
              winningIndexes: controller.winningIndexes,
              onCellTap: controller.onCellTap,
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
