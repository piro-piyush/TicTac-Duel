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

  @override
  Widget build(BuildContext context) {
    final symbol = values[index];

    final color = switch (symbol) {
      PlayerSymbol.x => theme.primary,
      PlayerSymbol.o => theme.secondary,
      null => Themes.textSecondary,
    };

    return GestureDetector(
      onTap: isMyTurn && symbol == null ? () => onCellTap?.call(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: symbol == null ? Themes.card : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: symbol == null
                ? theme.primary.withValues(alpha: 0.08)
                : color.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: symbol == null ? 0.03 : 0.10),
              blurRadius: symbol == null ? 8 : 14,
              spreadRadius: symbol == null ? 0 : 1,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: symbol == null
                ? const SizedBox.shrink()
                : _buildSymbol(symbol, color),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbol(PlayerSymbol symbol, Color color) {
    return Icon(
      symbol == PlayerSymbol.x ? Icons.close_rounded : Icons.circle_outlined,
      key: ValueKey(symbol),
      color: color,
      size: 48,
      shadows: [
        Shadow(color: color.withValues(alpha: 0.8), blurRadius: 18),
        Shadow(color: color.withValues(alpha: 0.35), blurRadius: 32),
      ],
    );
  }
}
