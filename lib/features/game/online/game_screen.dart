import 'package:tictac_duel/lib.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.room});

  final RoomModel room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onlineGameProvider(room));
    final notifier = ref.read(onlineGameProvider(room).notifier);
    final navigation = ref.read(appNavigationProvider);
    final gameDialog = ref.read(gameDialogProvider);

    final currentRoom = state.room;
    final showGame = notifier.showGame;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldQuit = await gameDialog.confirmQuit();

        if (!shouldQuit || !context.mounted) return;

        notifier.quitGame();
        navigation.back();
      },
      child: TicTacToeGameTemplateWidget(
        currentRound: currentRoom.currentRound,
        maxRounds: currentRoom.maxRounds,
        floatingActionButton: currentRoom.status == RoomStatus.playing
            ? GameReactionButtonWidget(onSendReaction: notifier.sendReaction)
            : null,
        actions: notifier.isWaitingForPlayers
            ? [
                IconButton(
                  onPressed: () => notifier.share(currentRoom.roomCode),
                  icon: const Icon(Icons.share_rounded),
                  tooltip: 'Share room',
                ),
              ]
            : null,
        turnPlayerId: notifier.turnPlayerId,
        isOnline: true,
        showGameStatus: showGame,
        theme: currentRoom.theme,
        isMe: (id) => id == notifier.playerId,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: showGame
              ? Stack(
                  key: const ValueKey('game'),
                  alignment: Alignment.center,
                  children: [
                    TicTacToeGameWidget(
                      theme: currentRoom.theme,
                      board: state.board,
                      winningIndexes: state.winningIndexes,
                      turnPlayerId: currentRoom.turnPlayerId,
                      isMyTurn: notifier.isMyTurn,
                      onCellTap: notifier.makeMove,
                      playerId: notifier.playerId,
                      host: currentRoom.host,
                      guest: currentRoom.guest!,
                      hostPoints: currentRoom.hostPoints,
                      guestPoints: currentRoom.guestPoints,
                      isOnline: true,
                      reactionEvent: state.reactionEvent,
                      showRoundAnimation: state.showRoundAnimation,
                    ),
                    GameRoundAnimationWidget(
                      showRoundAnimation: state.showRoundAnimation,
                      animatedRound: currentRoom.currentRound,
                    ),
                  ],
                )
              : WaitingForPlayersWidget(
                  key: const ValueKey('waiting'),
                  guest: currentRoom.guest,
                  hostReady: currentRoom.hostReady,
                  playerId: notifier.playerId,
                  roomCode: currentRoom.roomCode,
                  status: currentRoom.status,
                  host: currentRoom.host,
                  guestReady: currentRoom.guestReady,
                  onStartGame: notifier.startGame,
                ),
        ),
      ),
    );
  }
}
