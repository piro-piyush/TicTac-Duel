import 'package:tictac_duel/lib.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.room;
      final myPlayer = controller.myPlayer;

      Widget child;

      if (controller.isLoading && room == null) {
        child = const RoomStateWidget.connecting();
      } else if (room == null) {
        child = const RoomStateWidget.notFound();
      } else if (myPlayer == null) {
        child = const RoomStateWidget.playerNotFound();
      } else {
        child = controller.showGame
            ? Stack(
                alignment: Alignment.center,
                children: [
                  GameWidget(
                    room: room,
                    playerId: controller.playerId,
                    board: controller.board,
                    isMyTurn: controller.isMyTurn,
                    winningIndexes: controller.winningIndexes,
                    onCellTap: controller.makeMove,
                  ),
                  _buildRoundAnimation(room),
                ],
              )
            : WaitingForPlayersWidget(
                room: room,
                playerId: controller.playerId,
                waitingForNextRound: controller.waitingForNextRound,
                onStartGame: controller.startGame,
              );
      }

      return NeonBackgroundWidget(
        needScroll: true,
        title: 'Tic Tac Duel',
        child: child,
      );
    });
  }

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  Widget _buildRoundAnimation(RoomModel room) {
    return IgnorePointer(
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final scale = Tween<double>(begin: 0.82, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );

            final slide =
                Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: controller.showRoundAnimation
              ? Text(
                  'ROUND ${controller.animatedRound}',
                  key: ValueKey(controller.animatedRound),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 6, color: AppColors.neonPurple),
                      Shadow(blurRadius: 18, color: AppColors.neonPurple),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
