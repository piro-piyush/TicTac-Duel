import 'package:tictac_duel/lib.dart';

class GameBoardCellWidget extends StatelessWidget {
  const GameBoardCellWidget({
    super.key,
    required this.index,
    required this.isMyTurn,
    required this.theme,
    required this.values,
    this.onCellTap,
  });

  final int index;
  final RoomTheme theme;
  final List<PlayerSymbol?> values;
  final bool isMyTurn;
  final ValueChanged<int>? onCellTap;

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final symbol = values[index];
    final color = PlayerSymbolX.color(symbol,theme);

    final isEmpty = symbol == null;
    final isInteractive = isMyTurn && isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isInteractive
          ? () {
        onCellTap?.call(index);
        LoggerUtils.debug('Cell tapped: $index');
      }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isEmpty
              ? AppColors.card
              : color.withValues(alpha: 0.07),
          borderRadius: Dimens.radius12,
          border: Border.all(
            color: isEmpty
                ? theme.primary.withValues(alpha: 0.08)
                : color.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(
                alpha: isEmpty ? 0.03 : 0.10,
              ),
              blurRadius: isEmpty ? 8 : 14,
              spreadRadius: isEmpty ? 0 : 1,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: isEmpty
                ? const SizedBox.shrink()
                : Icon(
              symbol.icon,
              key: ValueKey(symbol),
              color: color,
              size: Dimens.icon3Xl,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.80),
                  blurRadius: 18,
                ),
                Shadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}