import 'package:tictac_duel/lib.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({
    super.key,
    required this.roomTheme,
    this.onCellTap,
  });

  final RoomTheme roomTheme;
  final ValueChanged<int>? onCellTap;

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  final List<PlayerSymbol?> _board = List<PlayerSymbol?>.filled(9, null);

  @override
  Widget build(BuildContext context) {
    final theme = widget.roomTheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Themes.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Themes.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.10),
              blurRadius: 32,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: theme.secondary.withValues(alpha: 0.05),
              blurRadius: 18,
              spreadRadius: -2,
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return _buildCell(index, theme);
          },
        ),
      ),
    );
  }

  Widget _buildCell(
      int index,
      RoomTheme theme,
      ) {
    final symbol = _board[index];

    final color = symbol == null
        ? Themes.textSecondary
        : symbol == PlayerSymbol.x
        ? theme.primary
        : theme.secondary;

    return GestureDetector(
      onTap: () => _handleCellTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: symbol == null
              ? Themes.card
              : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: symbol == null
                ? theme.primary.withValues(alpha: 0.08)
                : color.withValues(alpha: 0.45),
          ),
          boxShadow: symbol == null
              ? [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.03),
              blurRadius: 8,
            ),
          ]
              : [
            BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: symbol == null
                ? const SizedBox.shrink()
                : _buildSymbol(
              symbol,
              color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbol(
      PlayerSymbol symbol,
      Color color,
      ) {
    return Icon(
      symbol == PlayerSymbol.x
          ? Icons.close_rounded
          : Icons.circle_outlined,
      key: ValueKey(symbol),
      color: color,
      size: 48,
      shadows: [
        Shadow(
          color: color.withValues(alpha: 0.8),
          blurRadius: 18,
        ),
        Shadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 32,
        ),
      ],
    );
  }

  void _handleCellTap(int index) {
    if (_board[index] != null) {
      return;
    }

    // Temporary local testing.
    // Replace with the actual multiplayer move logic.
    setState(() {
      _board[index] = index.isEven
          ? PlayerSymbol.x
          : PlayerSymbol.o;
    });

    widget.onCellTap?.call(index);
  }
}