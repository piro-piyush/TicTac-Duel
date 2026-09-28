import 'package:tictac_duel/lib.dart';

class LocalGameWidget extends StatelessWidget {
  const LocalGameWidget({
    super.key,
    required this.localGame,
    required this.playerId,
    required this.board,
    required this.isMyTurn,
    required this.winningIndexes,
    required this.onCellTap,
  });

  final LocalGameModel localGame;
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
              GameRoundIndicatorWidget(
                compact: isCompact,
                currentRound: localGame.currentRound,
                maxRounds: localGame.maxRounds,
                color: AppColors.neonCyan,
              ),
              SizedBox(height: sectionSpacing),
              _buildPlayers(
                localGame,
                compact: isCompact,
              ),
              SizedBox(height: sectionSpacing),
              _buildBoard(localGame, isWide: isWide),
              SizedBox(height: sectionSpacing),
              GameStatusWidget(

                compact: isCompact,
                player: localGame.currentPlayer,
                isMyTurn: isMyTurn,
                theme: localGame.theme,
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
      LocalGameModel game, {
        required bool compact,
      }) {
    final controller = Get.find<LocalGameBoardController>();

    final isComputerGame = game.gameType == LocalGameType.computer;

    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget(
            player: game.playerOne,
            isTurn: controller.turnIndex == 0,
            theme: game.theme,
            compact: compact,
            isMe: true,
          ),
        ),
        VersusWidget(
          compact: compact,
        ),
        Expanded(
          child: GamePlayerCardWidget(
            player: game.playerTwo,
            isTurn: controller.turnIndex == 1,
            theme: game.theme,
            compact: compact,
            isMe: isComputerGame ? false : true,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BOARD
  // ===========================================================================

  Widget _buildBoard(
      LocalGameModel game, {
        required bool isWide,
      }) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWide ? 460 : 420,
        ),
        child: GameBoardWidget(
          roomTheme: game.theme,
          values: board,
          isMyTurn: true,
          winningIndexes: winningIndexes,
          onCellTap: onCellTap,
        ),
      ),
    );
  }
}
