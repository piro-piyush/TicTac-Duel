import 'package:tictac_duel/lib.dart';

class TicTacToeGameWidget extends StatelessWidget {
  const TicTacToeGameWidget({
    super.key,
    required this.theme,
    required this.board,
    required this.winningIndexes,
    required this.turnIndex,
    required this.isMyTurn,
    required this.onCellTap,
    // required this.playerOne,
    // required this.playerTwo,
    required this.playerOneBuilder, required this.playerTwoBuilder,
  });

  final RoomTheme theme;

  // Players
  // final Widget playerOne;
  // final Widget playerTwo;

  // Board
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  // Turn
  final int turnIndex;
  final bool isMyTurn;

  // Interaction
  final ValueChanged<int> onCellTap;

  final Widget Function(bool compact) playerOneBuilder;
  final Widget Function(bool compact) playerTwoBuilder;

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
          child: playerOneBuilder(compact),
        ),
        VersusWidget(
          compact: compact,
        ),
        Expanded(
          child: playerTwoBuilder(compact),
        ),
      ],
    );
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
      ),
    );
  }
}