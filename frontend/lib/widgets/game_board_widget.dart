import 'package:tictac_duel/lib.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
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
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Themes.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Themes.border, width: 1.5),
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
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GameBoardCellWidget(
                  index: index,
                  values: values,
                  theme: roomTheme,
                  isMyTurn: isMyTurn,
                  onCellTap: onCellTap,
                );
              },
            ),

            if (winningIndexes.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: WinningLinePainter(
                      winningIndexes: winningIndexes,
                      color: roomTheme.primary,
                      boardSize: 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  const WinningLinePainter({
    required this.winningIndexes,
    required this.color,
    required this.boardSize,
  });

  final Set<int> winningIndexes;
  final Color color;
  final int boardSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (winningIndexes.isEmpty) {
      return;
    }

    final sortedIndexes = winningIndexes.toList()..sort();

    final firstIndex = sortedIndexes.first;
    final lastIndex = sortedIndexes.last;

    final firstRow = firstIndex ~/ boardSize;
    final firstColumn = firstIndex % boardSize;

    final lastRow = lastIndex ~/ boardSize;
    final lastColumn = lastIndex % boardSize;

    final cellWidth = size.width / boardSize;
    final cellHeight = size.height / boardSize;

    Offset center(int row, int column) {
      return Offset(
        column * cellWidth + cellWidth / 2,
        row * cellHeight + cellHeight / 2,
      );
    }

    final start = center(firstRow, firstColumn);
    final end = center(lastRow, lastColumn);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawLine(start, end, glowPaint);
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) {
    return oldDelegate.winningIndexes != winningIndexes ||
        oldDelegate.color != color ||
        oldDelegate.boardSize != boardSize;
  }
}