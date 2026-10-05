import 'package:share_plus/share_plus.dart';
import 'package:tictac_duel/constants/extensions/game_reaction_extension.dart';
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
                      reactionEvent: controller.reactionEvent,
                      showRoundAnimation: controller.showRoundAnimation,
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
          floatingActionButton: room.roundStatus == RoundStatus.playing
              ? _buildReactionButton(context)
              : null,
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

  // ===========================================================================
  // REACTION
  // ===========================================================================

  Widget _buildReactionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showReactionPicker(context),
      tooltip: 'Send reaction',
      child: const Icon(Icons.emoji_emotions_rounded),
    );
  }

  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      showDragHandle: false,
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              Dimens.spaceBtwSections,
              Dimens.spaceBtwItems,
              Dimens.spaceBtwSections,
              Dimens.spaceBtwSections,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Dimens.cornerRadius16,
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: Dimens.twenty,
                  offset: const Offset(0, -Dimens.eight),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReactionHandle(theme),
                const SizedBox(height: Dimens.spaceBtwItems),
                _buildReactionTitle(theme),
                const SizedBox(height: Dimens.spaceBtwItems),
                _buildReactionGrid(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReactionHandle(ThemeData theme) {
    return Container(
      width: Dimens.forty,
      height: Dimens.four,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
        borderRadius: Dimens.radius10,
      ),
    );
  }

  Widget _buildReactionTitle(ThemeData theme) {
    return Text(
      'SEND A REACTION',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReactionGrid(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Dimens.spaceBtwItems,
      runSpacing: Dimens.spaceBtwItems,
      children: [
        for (final reaction in GameReaction.values)
          _reactionButton(context, reaction),
      ],
    );
  }

  Widget _reactionButton(BuildContext context, GameReaction reaction) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controller.sendReaction(reaction);
        },
        borderRadius: Dimens.radius10,
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Ink(
          width: Dimens.fifty,
          height: Dimens.fifty,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: Dimens.radius10,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Center(
            child: Lottie.network(
              reaction.animation,
              width: Dimens.forty,
              height: Dimens.forty,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
              frameRate: FrameRate.max,
            ),
          ),
        ),
      ),
    );
  }
}
