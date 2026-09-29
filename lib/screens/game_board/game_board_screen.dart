import 'package:tictac_duel/lib.dart';

class GameBoardScreen extends GetView<GameBoardController> {
  const GameBoardScreen({super.key});

  Future<bool> _confirmQuit() async {
    final shouldQuit = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Quit Game?'),
        content: const Text('Are you sure you want to quit the current game?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('QUIT'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return shouldQuit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await _confirmQuit();

        if (shouldQuit) {
          AppNavigation.goToHome();
        }
      },
      child: Obx(
        () => NeonBackgroundWidget(
          title: '',
          needScroll: false,
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
      ),
    );
  }
}
