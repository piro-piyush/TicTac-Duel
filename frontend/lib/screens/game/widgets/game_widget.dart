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
  final List<PlayerSymbol?> board;
  final bool isMyTurn;
  final Set<int> winningIndexes;
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
              GameRoundIndicatorWidget(room: room, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildPlayers(room, playerId, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildBoard(room, isWide: isWide),
              SizedBox(height: sectionSpacing),
              GameStatusWidget(
                room: room,
                playerId: playerId,
                compact: isCompact,
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  Widget _buildPlayers(
    RoomModel room,
    String playerId, {
    required bool compact,
  }) {
    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget(
            player: room.players[0],
            isTurn: room.turnIndex == 0,
            theme: room.theme,
            compact: compact,
            isMe: playerId == room.players[0].id,
          ),
        ),
        VersusWidget(compact: compact),
        Expanded(
          child: GamePlayerCardWidget(
            player: room.players[1],
            isTurn: room.turnIndex == 1,
            theme: room.theme,
            compact: compact,
            isMe: playerId == room.players[1].id,
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
          values: board,
          isMyTurn: isMyTurn,
          winningIndexes: winningIndexes,
          onCellTap: onCellTap,
        ),
      ),
    );
  }
}
