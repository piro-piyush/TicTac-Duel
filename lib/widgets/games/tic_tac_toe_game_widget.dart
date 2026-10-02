import 'package:tictac_duel/lib.dart';

class TicTacToeGameWidget extends StatelessWidget {
  const TicTacToeGameWidget({
    super.key,
    required this.theme,
    required this.playerId,
    required this.board,
    required this.winningIndexes,
    required this.turnIndex,
    required this.isMyTurn,
    required this.onCellTap,
    required this.boardSize,
    required this.playerOne,
    required this.playerTwo,
    required this.playerOnePoints,
    required this.playerTwoPoints,
     this.playerOneReady,
     this.playerTwoReady,
  });

  final RoomTheme theme;

  // Current player
  final String playerId;

  // Players
  final PlayerModel playerOne;
  final PlayerModel playerTwo;

  // Player state
  final int playerOnePoints;
  final int playerTwoPoints;
  final bool? playerOneReady;
  final bool? playerTwoReady;

  // Board
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;
  final int boardSize;

  // Turn
  final int turnIndex;
  final bool isMyTurn;

  // Interaction
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlayers(
                compact: isCompact,
              ),
              SizedBox(height: sectionSpacing),
              _buildBoard(
                isWide: isWide,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayers({
    required bool compact,
  }) {
    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget(
            player: playerOne,
            points: playerOnePoints,
            isMe: _isMe,
            isTurn: turnIndex == 0,
            theme: theme,
            compact: compact,
            isOnline: true,
          ),
        ),
        VersusWidget(
          compact: compact,
        ),
        Expanded(
          child: GamePlayerCardWidget(
            player: playerTwo,
            points: playerTwoPoints,
            isMe: _isMe,
            isTurn: turnIndex == 1,
            theme: theme,
            compact: compact,
            isOnline: true,
          ),
        ),
      ],
    );
  }

  bool _isMe(String id) {
    return playerId == id;
  }

  Widget _buildBoard({
    required bool isWide,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isWide ? 460 : 420,
      ),
      child: TicTacToeBoardWidget(
        roomTheme: theme,
        values: board,
        isMyTurn: isMyTurn,
        winningIndexes: winningIndexes,
        onCellTap: onCellTap,
        boardSize: boardSize,
      ),
    );
  }
}