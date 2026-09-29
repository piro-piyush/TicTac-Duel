import 'package:tictac_duel/lib.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.room,
    required this.playerId,
    required this.board,
    required this.isMyTurn,
    required this.winningIndexes,
    required this.onCellTap,
  });

  final RoomModel room;
  final String playerId;

  // Board state
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  // Turn state
  final bool isMyTurn;

  // Actions
  final ValueChanged<int> onCellTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isCompact = width < 380;
        final isWide = width >= 600;

        final horizontalPadding = isCompact ? 4.0 : 12.0;
        final sectionSpacing = isCompact ? 12.0 : 18.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            16,
          ),
          child: Column(
            children: [
              _buildRoundIndicator(compact: isCompact),
              SizedBox(height: sectionSpacing),

              _buildPlayers(compact: isCompact),
              SizedBox(height: sectionSpacing),

              _buildBoard(isWide: isWide),
              SizedBox(height: sectionSpacing),

              _buildStatus(compact: isCompact),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // ROUND
  // ===========================================================================

  Widget _buildRoundIndicator({required bool compact}) {
    return GameRoundIndicatorWidget(
      currentRound: room.currentRound,
      maxRounds: room.maxRounds,
      color: room.theme.primary,
      compact: compact,
    );
  }

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  Widget _buildPlayers({required bool compact}) {
    final players = room.players;

    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget.online(
            player: room.playerOne,
            isTurn: room.turnIndex == 0,
            theme: room.theme,
            compact: compact,
            isMe: playerId == players[0].id,
          ),
        ),

        VersusWidget(compact: compact),

        Expanded(
          child: GamePlayerCardWidget.online(
            player: room.playerTwo,
            isTurn: room.turnIndex == 1,
            theme: room.theme,
            compact: compact,
            isMe: playerId == players[1].id,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BOARD
  // ===========================================================================

  Widget _buildBoard({required bool isWide}) {
    return Align(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 460 : 420),
        child: GameBoardWidget(
          roomTheme: room.theme,
          values: board,
          isMyTurn: isMyTurn,
          winningIndexes: winningIndexes,
          onCellTap: onCellTap,
        ),
      ),
    );
  }

  // ===========================================================================
  // STATUS
  // ===========================================================================

  Widget _buildStatus({required bool compact}) {
    final currentPlayer = room.players[room.turnIndex];

    return GameStatusWidget(
      player: currentPlayer,
      status: isMyTurn ? 'Your turn' : '${currentPlayer.name}\'s turn',
      theme: room.theme,
      compact: compact,
    );
  }
}