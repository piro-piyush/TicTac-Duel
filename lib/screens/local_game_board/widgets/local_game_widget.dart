import 'package:tictac_duel/lib.dart';

class LocalGameWidget extends StatelessWidget {
  const LocalGameWidget({
    super.key,
    required this.localGame,
    required this.board,
    required this.winningIndexes,
    required this.currentPlayer,
    required this.currentRound,
    required this.turnIndex,
    required this.canMakeMove,
    required this.onCellTap,
    required this.playerOnePoints,
    required this.playerTwoPoints,
  });

  final LocalGameModel localGame;

  // Board state
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  // Turn / round state
  final PlayerModel currentPlayer;
  final int turnIndex;
  final int currentRound;
  final int playerOnePoints;
  final int playerTwoPoints;

  // Interaction
  final bool canMakeMove;
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
      compact: compact,
      currentRound: currentRound,
      maxRounds: localGame.maxRounds,
      color: AppColors.neonCyan,
    );
  }

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  Widget _buildPlayers({required bool compact}) {
    // final isComputerGame = localGame.gameType == LocalGameType.computer;

    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget.local(
            player: localGame.playerOne,
            points: playerOnePoints,
            isTurn: turnIndex == 0,
            theme: localGame.theme,
            compact: compact,
          ),
        ),

        VersusWidget(compact: compact),

        Expanded(
          child: GamePlayerCardWidget.local(
            player: localGame.playerTwo,
            points: playerTwoPoints,

            isTurn: turnIndex == 1,
            theme: localGame.theme,
            compact: compact,
            // isMe: isComputerGame ? false : true,
            // isOnline: false,
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
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 460 : 420),
        child: GameBoardWidget(
          roomTheme: localGame.theme,
          values: board,
          isMyTurn: canMakeMove,
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
    return GameStatusWidget(
      compact: compact,
      player: currentPlayer,
      status: '${currentPlayer.name}\'s turn',
      theme: localGame.theme,
    );
  }
}
