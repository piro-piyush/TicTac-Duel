import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends ConsumerWidget {
  const LocalGameBoardScreen({super.key, required this.game});

  final LocalGameModel game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameBoardProvider(game));
    final notifier = ref.read(localGameBoardProvider(game).notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await ref.read(gameDialogProvider).confirmQuit();

        if (shouldQuit) {
          notifier.quitGame();
        }
      },
      child: TicTacToeGameTemplateWidget(
        currentRound: state.currentRound,
        maxRounds: game.maxRounds,
        turnPlayerId: state.currentPlayer.id,
        isMe: (id) => id == notifier.playerId,
        theme: game.theme,
        isOnline: false,
        showGameStatus: true,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TicTacToeGameWidget(
              theme: game.theme,
              board: state.board,
              winningIndexes: state.winningIndexes,
              turnIndex: state.turnIndex,
              isMyTurn: state.canMakeMove,
              onCellTap: notifier.onCellTap,
              playerOnePoints: state.playerOnePoints,
              playerTwoPoints: state.playerTwoPoints,
              playerId: notifier.playerId,
              playerOne: game.playerOne,
              playerTwo: game.playerTwo,
              isOnline: false,
              reactionEvent: state.reactionEvent,
              showRoundAnimation: state.showRoundAnimation,
            ),
            GameRoundAnimationWidget(
              showRoundAnimation: state.showRoundAnimation,
              animatedRound: state.animatedRound,
            ),
          ],
        ),
      ),
    );
  }
}
