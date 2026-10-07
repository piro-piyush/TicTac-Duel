import 'package:share_plus/share_plus.dart';
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await gameDialog.confirmQuit();

        if (!shouldQuit || !context.mounted) {
          return;
        }

        notifier.quitGame();
        navigation.back();
      },
      child: _buildContent(context, state, notifier),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OnlineGameState state,
    OnlineGameNotifier notifier,
  ) {
    final room = state.room;

    // if (state.isLoading && room == null) {
    //   return const NeonBackgroundWidget(
    //     needScroll: false,
    //     child: RoomStateWidget.connecting(),
    //   );
    // }
    //
    // if (room == null) {
    //   return const NeonBackgroundWidget(
    //     needScroll: false,
    //     child: RoomStateWidget.notFound(),
    //   );
    // }

    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: notifier.showGame
          ? Stack(
              key: const ValueKey('game'),
              alignment: Alignment.center,
              children: [
                TicTacToeGameWidget(
                  theme: room.theme,
                  board: state.board,
                  winningIndexes: state.winningIndexes,
                  turnPlayerId: state.room.turnPlayerId,
                  isMyTurn: notifier.isMyTurn,
                  onCellTap: notifier.makeMove,
                  playerId: notifier.playerId,
                  host: notifier.host,
                  guest: notifier.guest!,
                  hostPoints: state.room.hostPoints,
                  guestPoints: state.room.guestPoints,

                  isOnline: true,
                  reactionEvent: state.reactionEvent,
                  showRoundAnimation: state.showRoundAnimation,
                ),
                GameRoundAnimationWidget(
                  showRoundAnimation: state.showRoundAnimation,
                  animatedRound: state.room.currentRound,
                ),
              ],
            )
          : WaitingForPlayersWidget(
              key: const ValueKey('waiting'),
              guest: notifier.guest,
              hostReady: notifier.room.hostReady,
              playerId: notifier.playerId,
              roomCode: room.roomCode,
              status: room.status,
              host: state.room.host,
              guestReady: state.room.guestReady,
              onStartGame: notifier.startGame,
            ),
    );

    return TicTacToeGameTemplateWidget(
      currentRound: room.currentRound,
      maxRounds: room.maxRounds,
      floatingActionButton: room.status == RoomStatus.playing
          ? _buildReactionButton(context, notifier)
          : null,
      actions: notifier.isWaitingForPlayers
          ? [
              IconButton(
                onPressed: () => _shareRoomCode(room.roomCode),
                icon: const Icon(Icons.share_rounded),
                tooltip: 'Share room',
              ),
            ]
          : null,
      turnPlayerId: notifier.turnPlayerId,
      isOnline: true,
      showGameStatus: notifier.showGame,
      theme: room.theme,
      child: child,
      isMe: (id) => id == notifier.playerId,
    );
  }

  Future<void> _shareRoomCode(String roomCode) async {
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

  Widget _buildReactionButton(
    BuildContext context,
    OnlineGameNotifier notifier,
  ) {
    return FloatingActionButton(
      onPressed: () => _showReactionPicker(context, notifier),
      tooltip: 'Send reaction',
      child: const Icon(Icons.emoji_emotions_rounded),
    );
  }

  void _showReactionPicker(BuildContext context, OnlineGameNotifier notifier) {
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
                _buildReactionGrid(context, notifier),
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

  Widget _buildReactionGrid(BuildContext context, OnlineGameNotifier notifier) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Dimens.spaceBtwItems,
      runSpacing: Dimens.spaceBtwItems,
      children: [
        for (final reaction in GameReaction.values)
          _reactionButton(context, notifier, reaction),
      ],
    );
  }

  Widget _reactionButton(
    BuildContext context,
    OnlineGameNotifier notifier,
    GameReaction reaction,
  ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          notifier.sendReaction(reaction);
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
