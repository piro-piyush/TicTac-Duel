import 'package:share_plus/share_plus.dart';
import 'package:tictac_duel/lib.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await GameDialogUtils.confirmQuit();

        if (!shouldQuit || !context.mounted) {
          return;
        }

        controller.quitGame();

        AppNavigation.back();
      },
      child: Obx(() {
        final room = controller.room;

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

        final child = AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: controller.showGame
              ? Stack(
                  key: const ValueKey('game'),
                  alignment: Alignment.center,
                  children: [
                    TicTacToeGameWidget(
                      theme: room.theme,
                      board: controller.board,
                      winningIndexes: controller.winningIndexes,
                      turnIndex: controller.turnIndex,
                      isMyTurn: controller.isMyTurn,
                      onCellTap: controller.makeMove,
                      playerId: controller.playerId,
                      playerOne: controller.playerOne,
                      playerTwo: controller.playerTwo!,
                      playerOnePoints: controller.playerOnePoints,
                      playerOneReady: controller.playerOneReady,
                      playerTwoPoints: controller.playerTwoPoints,
                      playerTwoReady: controller.playerTwoReady,
                      isOnline: true,
                    ),
                    GameRoundAnimationWidget(
                      showRoundAnimation: controller.showRoundAnimation,
                      animatedRound: controller.animatedRound,
                    ),
                  ],
                )
              : WaitingForPlayersWidget(
                  key: const ValueKey('waiting'),
                  playerOne: controller.playerOne,
                  playerTwo: controller.playerTwo,
                  playerId: controller.playerId,
                  roomCode: room.roomCode,
                  roomStatus: room.roundStatus,
                  playerOneReady: controller.playerOneReady,
                  playerTwoReady: controller.playerTwoReady,
                  onStartGame: controller.startGame,
                ),
        );

        return TicTacToeGameTemplateWidget(
          currentRound: room.currentRound,
          maxRounds: room.maxRounds,
          actions: controller.isWaitingForPlayers
              ? [
                  IconButton(
                    onPressed: () => _shareRoomCode(room.roomCode),
                    icon: const Icon(Icons.share_rounded),
                    tooltip: 'Share room',
                  ),
                ]
              : null,
          player: controller.currentPlayer,
          isOnline: true,
          showGameStatus: controller.showGame,
          theme: room.theme,
          child: child,
          isMe: (id) => id == controller.playerId,
        );
      }),
    );
  }

  void _shareRoomCode(String roomCode) async {
    await SharePlus.instance.share(
      ShareParams(
        text: GameConstants.getRoomShareText(roomCode),
        subject: GameConstants.appName,
      ),
    );
  }
}
