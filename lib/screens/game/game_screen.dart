import 'package:tictac_duel/lib.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.room;
      final myPlayer = controller.myPlayer;

      if (controller.isLoading && room == null) {
        return const NeonBackgroundWidget(
          needScroll: false,
          child: RoomStateWidget.connecting(),
        );
      }

      if (room == null) {
        return const NeonBackgroundWidget(
          needScroll: false,
          child: RoomStateWidget.notFound(),
        );
      }

      if (myPlayer == null) {
        return const NeonBackgroundWidget(
          needScroll: false,
          child: RoomStateWidget.playerNotFound(),
        );
      }

      final child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: () {
          if (!controller.showGame) {
            return WaitingForPlayersWidget(
              key: const ValueKey('waiting'),
              room: room,
              playerId: controller.playerId,
              waitingForNextRound: controller.waitingForNextRound,
              onStartGame: controller.startGame,
            );
          }

          return Stack(
            key: const ValueKey('game'),
            alignment: Alignment.center,
            children: [
              TicTacToeGameWidget(
                theme: room.theme,
                board: controller.board,
                winningIndexes: controller.winningIndexes,
                turnIndex: room.turnIndex,
                isMyTurn: controller.isMyTurn,
                onCellTap: controller.makeMove,
                boardSize: room.boardSize,
                playerId: controller.playerId,
                playerOne: room.playerOne,
                playerTwo: room.playerTwo,
                playerOnePoints: controller.playerOnePoints,
                playerOneReady: controller.playerOneReady,
                playerTwoPoints: controller.playerTwoPoints,
                playerTwoReady: controller.playerTwoReady,
              ),
              GameRoundAnimationWidget(
                showRoundAnimation: controller.showRoundAnimation,
                animatedRound: controller.animatedRound,
              ),
            ],
          );
        }(),
      );

      return TicTacToeGameTemplateWidget(
        currentRound: room.currentRound,
        maxRounds: room.maxRounds,
        player: myPlayer,
        isOnline: true,
        showGameStatus: controller.showGame,
        isMe: (id) => id == controller.playerId,
        theme: room.theme,
        child: child,
      );
    });
  }
}
