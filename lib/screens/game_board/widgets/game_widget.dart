import 'package:tictac_duel/lib.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
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

  final GameModel localGame;

  // Board state.
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  // Turn and round state.
  final PlayerModel currentPlayer;
  final int currentRound;
  final int turnIndex;
  final int playerOnePoints;
  final int playerTwoPoints;

  // Interaction.
  final bool canMakeMove;
  final ValueChanged<int> onCellTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final availableWidth = constraints.maxWidth;
        final isCompact = availableWidth < Dimens.threeHundredEighty;
        final isWide = availableWidth >= Dimens.sixHundred;

        final horizontalPadding = isCompact ? Dimens.four : Dimens.twelve;
        final sectionSpacing = isCompact ? Dimens.twelve : Dimens.eighteen;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            Dimens.eight,
            horizontalPadding,
            Dimens.sixteen,
          ),
          child: Column(
            children: [
              GameRoundIndicatorWidget(
                compact: isCompact,
                currentRound: currentRound,
                maxRounds: localGame.maxRounds,
              ),
              SizedBox(height: sectionSpacing),
              Row(
                spacing: isCompact ? Dimens.six : Dimens.ten,
                children: [
                  Expanded(
                    child: GamePlayerCardWidget(
                      player: localGame.playerOne,
                      points: playerOnePoints,
                      isTurn: turnIndex == 0,
                      theme: localGame.theme,
                      compact: isCompact,
                    ),
                  ),
                  VersusWidget(compact: isCompact),
                  Expanded(
                    child: GamePlayerCardWidget(
                      player: localGame.playerTwo,
                      points: playerTwoPoints,
                      isTurn: turnIndex == 1,
                      theme: localGame.theme,
                      compact: isCompact,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sectionSpacing),
              Align(
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
              ),
              SizedBox(height: sectionSpacing),
              GameStatusWidget(
                compact: isCompact,
                player: currentPlayer,
                status: '${currentPlayer.name}\'s turn',
                theme: localGame.theme,
              ),
            ],
          ),
        );
      },
    );
  }
}
