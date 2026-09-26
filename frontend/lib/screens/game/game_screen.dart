import 'package:tictac_duel/lib.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.room;

      if (controller.isLoading && room == null) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.neonCyan),
          ),
        );
      }

      if (room == null) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Text(
              'Room not found',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        );
      }

      final myPlayer = controller.myPlayer;

      if (myPlayer == null) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Text(
              'Player not found',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        );
      }

      return NeonBackgroundWidget(
        needScroll: true,
        title: 'Tic Tac Duel',
        child: controller.showGame
            ? Stack(
                alignment: Alignment.center,
                children: [_buildGame(room), _buildRoundAnimation(room)],
              )
            : WaitingForPlayersWidget(
                room: room,
                waitingForNextRound: controller.waitingForNextRound,
              ),
      );
    });
  }

  // ===========================================================================
  // GAME
  // ===========================================================================

  Widget _buildGame(RoomModel room) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 380;
        final isWide = width >= 600;

        final horizontalPadding = isCompact ? 4.0 : 12.0;
        final sectionSpacing = isCompact ? 12.0 : 18.0;

        final mySocketId = controller.socketId!;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            16,
          ),
          child: Column(
            children: [
              GameRoundIndicatorWidget(room: room, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildPlayers(room, mySocketId, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildBoard(room, isWide: isWide),
              SizedBox(height: sectionSpacing),
              GameStatusWidget(
                room: room,
                webSocketId: mySocketId,
                compact: isCompact,
              ),
            ],
          ),
        );
      },
    );
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

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  Widget _buildPlayers(
    RoomModel room,
    String mySocketId, {
    required bool compact,
  }) {
    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget(
            webSocketId: mySocketId,
            player: room.players[0],
            isTurn: room.turnIndex == 0,
            theme: room.theme,
            compact: compact,
            isMe: mySocketId == room.players[0].socketId,
          ),
        ),
        VersusWidget(compact: compact),
        Expanded(
          child: GamePlayerCardWidget(
            webSocketId: mySocketId,
            player: room.players[1],
            isTurn: room.turnIndex == 1,
            theme: room.theme,
            compact: compact,
            isMe: mySocketId == room.players[1].socketId,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BOARD
  // ===========================================================================

  Widget _buildBoard(RoomModel room, {required bool isWide}) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 460 : 420),
        child: GameBoardWidget(
          roomTheme: room.theme,
          values: controller.board,
          isMyTurn: controller.isMyTurn,
          winningIndexes: controller.winningIndexes,
          onCellTap: controller.makeMove,
        ),
      ),
    );
  }
}
