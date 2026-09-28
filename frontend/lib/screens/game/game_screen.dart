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
                  GameRoundAnimationWidget(
                    showRoundAnimation: controller.showRoundAnimation,
                    animatedRound: controller.animatedRound,

                  )
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
        title: 'Tic Tac Duel',
        child: child,
      );
    });
  }


}
