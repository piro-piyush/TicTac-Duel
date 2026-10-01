import 'package:tictac_duel/lib.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.room;
      final myPlayer = controller.myPlayer;

      if (controller.isLoading && room == null) {
        return const RoomStateWidget.connecting();
      }

      if (room == null) {
        return const RoomStateWidget.notFound();
      }

      if (myPlayer == null) {
        return const RoomStateWidget.playerNotFound();
      }

      final child = controller.showGame
          ? Stack(
        alignment: Alignment.center,
        children: [
          TicTacToeGameWidget(
            theme: room.theme,
            board: controller.board,
            winningIndexes: controller.winningIndexes,
            turnIndex: room.turnIndex,
            isMyTurn: controller.isMyTurn,
            onCellTap: controller.makeMove,

            playerOneBuilder: (compact) {
              return GamePlayerCardWidget.online(
                player: room.playerOne,
                isTurn: room.turnIndex == 0,
                theme: room.theme,
                compact: compact,
                isMe: controller.playerId == room.playerOne.id,
              );
            },

            playerTwoBuilder: (compact) {
              return GamePlayerCardWidget.online(
                player: room.playerTwo,
                isTurn: room.turnIndex == 1,
                theme: room.theme,
                compact: compact,
                isMe: controller.playerId == room.playerTwo.id,
              );
            },
          ),
          GameRoundAnimationWidget(
            showRoundAnimation: controller.showRoundAnimation,
            animatedRound: controller.animatedRound,
          ),
        ],
      )
          : WaitingForPlayersWidget(
        room: room,
        playerId: controller.playerId,
        waitingForNextRound: controller.waitingForNextRound,
        onStartGame: controller.startGame,
      );

      return TicTacToeGameScreen(
        title: 'ONLINE GAME',
        currentRound: room.currentRound,
        maxRounds: room.maxRounds,
        player: myPlayer,
        status: controller.isMyTurn
            ? 'Your turn'
            : 'Opponent\'s turn',
        theme: room.theme,
        child: child,
      );
    });
  }
}