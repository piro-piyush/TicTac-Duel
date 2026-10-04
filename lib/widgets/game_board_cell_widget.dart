import 'package:tictac_duel/lib.dart';

class GameBoardCellWidget extends StatelessWidget {
  const GameBoardCellWidget({
    super.key,
    required this.index,
    required this.symbol,
    required this.isMyTurn,
    required this.theme,
    this.onCellTap,
  });

  final int index;
  final PlayerSymbol? symbol;
  final bool isMyTurn;
  final RoomTheme theme;
  final ValueChanged<int>? onCellTap;

  @override
  Widget build(BuildContext context) {
    final isEmpty = symbol == null;
    final isInteractive = isMyTurn && isEmpty;
    final symbolColor = PlayerSymbolX.color(symbol, theme);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isInteractive ? () => onCellTap?.call(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isEmpty ? AppColors.card : symbolColor.withValues(alpha: 0.07),
          borderRadius: Dimens.radius12,
          border: Border.all(
            color: isEmpty
                ? theme.primary.withValues(alpha: 0.08)
                : symbolColor.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: symbolColor.withValues(alpha: isEmpty ? 0.03 : 0.10),
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
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: isEmpty
                ? const SizedBox.shrink()
                : Icon(
                    symbol!.icon,
                    key: ValueKey(symbol),
                    color: symbolColor,
                    size: Dimens.icon3Xl,
                    shadows: [
                      Shadow(
                        color: symbolColor.withValues(alpha: 0.80),
                        blurRadius: 18,
                      ),
                      Shadow(
                        color: symbolColor.withValues(alpha: 0.35),
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
