import 'package:tictac_duel/lib.dart';

class TicTacToeBoardWidget extends StatelessWidget {
  const TicTacToeBoardWidget({
    super.key,
    required this.roomTheme,
    required this.isMyTurn,
    required this.values,
    this.winningIndexes = const {},
    this.onCellTap,
  });

  final List<PlayerSymbol?> values;
  final RoomTheme roomTheme;
  final bool isMyTurn;
  final Set<int> winningIndexes;
  final ValueChanged<int>? onCellTap;

  @override
  Widget build(BuildContext context) {
    const gridSpacing = Dimens.eight;
    const borderRadius = Dimens.twentyTwo;

    return AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: roomTheme.primary.withValues(alpha: 0.10),
                  blurRadius: 32,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: roomTheme.secondary.withValues(alpha: 0.05),
                  blurRadius: 18,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Padding(
              padding: Dimens.edgeInsets12,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final boardWidth = constraints.maxWidth;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: values.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: GameConstants.boardSize,
                              crossAxisSpacing: gridSpacing,
                              mainAxisSpacing: gridSpacing,
                            ),
                        itemBuilder: (context, index) {
                          return GameBoardCellWidget(
                            index: index,
                            symbol: values[index],
                            theme: roomTheme,
                            isMyTurn: isMyTurn,
                            onCellTap: onCellTap,
                          );
                        },
                      ),
                      if (winningIndexes.isNotEmpty)
                        TicTacToeWinningLineWidget(
                          winningIndexes: winningIndexes,
                          color: _winningLineColor,
                          boardSize: GameConstants.boardSize,
                          gridSpacing: gridSpacing,
                          boardWidth: boardWidth,
                          borderRadius: borderRadius,
                          boardExtension: Dimens.twentyTwo,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: AnimationConstants.medium)
        .scale(
          begin: const Offset(
            AnimationConstants.scaleSmall,
            AnimationConstants.scaleSmall,
          ),
          end: const Offset(
            AnimationConstants.scaleNormal,
            AnimationConstants.scaleNormal,
          ),
          duration: AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        );
  }

  Color get _winningLineColor {
    if (winningIndexes.isEmpty) {
      return roomTheme.primary;
    }

    final winningIndex = winningIndexes.first;

    if (winningIndex < 0 || winningIndex >= values.length) {
      return roomTheme.primary;
    }

    return PlayerSymbolX.color(values[winningIndex], roomTheme);
  }
}
