import 'package:tictac_duel/lib.dart';

import 'dart:math' as math;

class TicTacToeWinningLinePainter extends CustomPainter {
  const TicTacToeWinningLinePainter({
    required this.winningIndexes,
    required this.color,
    required this.boardSize,
    required this.gridSpacing,
    required this.progress,
    required this.boardWidth,
    required this.borderRadius,
    required this.boardExtension,
  });

  final Set<int> winningIndexes;
  final Color color;
  final int boardSize;
  final double gridSpacing;
  final double progress;

  /// Actual board width received from the parent.
  final double boardWidth;

  /// Board corner radius received from the parent.
  final double borderRadius;

  /// Extra distance beyond both board edges.
  final double boardExtension;

  // ===========================================================================
  // CONFIG
  // ===========================================================================

  static const double _lineWidth = 5;
  static const double _glowWidth = 14;
  static const double _glowBlur = 8;

  // ===========================================================================
  // PAINT
  // ===========================================================================

  @override
  void paint(Canvas canvas, Size size) {
    if (winningIndexes.length < 2 || boardSize < 2) {
      return;
    }

    final indexes = winningIndexes.toList()..sort();

    final firstIndex = indexes.first;
    final lastIndex = indexes.last;

    if (!_isValidIndex(firstIndex) || !_isValidIndex(lastIndex)) {
      return;
    }

    // The Tic Tac Toe board is square.
    final boardHeight = boardWidth;

    final cellSize = _calculateCellSize(boardWidth);

    final firstCenter = _cellCenter(index: firstIndex, cellSize: cellSize);

    final lastCenter = _cellCenter(index: lastIndex, cellSize: cellSize);

    final direction = lastCenter - firstCenter;
    final distance = direction.distance;

    if (distance == 0) {
      return;
    }

    final unitDirection = direction / distance;

    // -------------------------------------------------------------------------
    // Find the points where the winning line reaches the board boundary.
    // -------------------------------------------------------------------------

    final boardStart = _findBoardStart(
      point: firstCenter,
      direction: unitDirection,
      width: boardWidth,
      height: boardHeight,
    );

    final boardEnd = _findBoardEnd(
      point: lastCenter,
      direction: unitDirection,
      width: boardWidth,
      height: boardHeight,
    );

    // -------------------------------------------------------------------------
    // Extend beyond both board edges.
    // -------------------------------------------------------------------------

    final start = boardStart - unitDirection * boardExtension;

    final end = boardEnd + unitDirection * boardExtension;

    // -------------------------------------------------------------------------
    // Animate.
    // -------------------------------------------------------------------------

    final animatedEnd = Offset.lerp(start, end, progress.clamp(0.0, 1.0));

    if (animatedEnd == null) {
      return;
    }

    // -------------------------------------------------------------------------
    // Draw.
    // -------------------------------------------------------------------------

    _drawGlow(canvas, start, animatedEnd);

    _drawLine(canvas, start, animatedEnd);

    _drawLeadingGlow(canvas, animatedEnd);
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  bool _isValidIndex(int index) => index >= 0 && index < boardSize * boardSize;

  // ===========================================================================
  // GEOMETRY
  // ===========================================================================

  double _calculateCellSize(double width) {
    final totalSpacing = gridSpacing * (boardSize - 1);

    return (width - totalSpacing) / boardSize;
  }

  Offset _cellCenter({required int index, required double cellSize}) {
    final row = index ~/ boardSize;
    final column = index % boardSize;

    return Offset(
      column * (cellSize + gridSpacing) + cellSize / 2,
      row * (cellSize + gridSpacing) + cellSize / 2,
    );
  }

  // ===========================================================================
  // BOARD INTERSECTION
  // ===========================================================================

  Offset _findBoardStart({
    required Offset point,
    required Offset direction,
    required double width,
    required double height,
  }) {
    final candidates = <Offset>[];

    // Left edge.
    if (direction.dx != 0) {
      final t = -point.dx / direction.dx;

      if (t < 0) {
        final y = point.dy + direction.dy * t;

        if (y >= 0 && y <= height) {
          candidates.add(Offset(0, y));
        }
      }
    }

    // Top edge.
    if (direction.dy != 0) {
      final t = -point.dy / direction.dy;

      if (t < 0) {
        final x = point.dx + direction.dx * t;

        if (x >= 0 && x <= width) {
          candidates.add(Offset(x, 0));
        }
      }
    }

    if (candidates.isEmpty) {
      return point;
    }

    return candidates.reduce(
      (a, b) => _distanceSquared(a, point) > _distanceSquared(b, point) ? a : b,
    );
  }

  Offset _findBoardEnd({
    required Offset point,
    required Offset direction,
    required double width,
    required double height,
  }) {
    final candidates = <Offset>[];

    // Right edge.
    if (direction.dx != 0) {
      final t = (width - point.dx) / direction.dx;

      if (t > 0) {
        final y = point.dy + direction.dy * t;

        if (y >= 0 && y <= height) {
          candidates.add(Offset(width, y));
        }
      }
    }

    // Bottom edge.
    if (direction.dy != 0) {
      final t = (height - point.dy) / direction.dy;

      if (t > 0) {
        final x = point.dx + direction.dx * t;

        if (x >= 0 && x <= width) {
          candidates.add(Offset(x, height));
        }
      }
    }

    if (candidates.isEmpty) {
      return point;
    }

    return candidates.reduce(
      (a, b) => _distanceSquared(a, point) > _distanceSquared(b, point) ? a : b,
    );
  }

  double _distanceSquared(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;

    return dx * dx + dy * dy;
  }

  // ===========================================================================
  // LINE
  // ===========================================================================

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  // ===========================================================================
  // GLOW
  // ===========================================================================

  void _drawGlow(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.40)
      ..strokeWidth = _glowWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _glowBlur);

    canvas.drawLine(start, end, paint);
  }

  // ===========================================================================
  // LEADING GLOW
  // ===========================================================================

  void _drawLeadingGlow(Canvas canvas, Offset position) {
    if (progress <= 0.05 || progress >= 1.0) {
      return;
    }

    final pulse = math.sin(progress * math.pi);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.55 * pulse)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    canvas.drawCircle(position, 7, paint);
  }

  // ===========================================================================
  // REPAINT
  // ===========================================================================

  @override
  bool shouldRepaint(covariant TicTacToeWinningLinePainter oldDelegate) =>
      oldDelegate.winningIndexes != winningIndexes ||
      oldDelegate.color != color ||
      oldDelegate.boardSize != boardSize ||
      oldDelegate.gridSpacing != gridSpacing ||
      oldDelegate.progress != progress ||
      oldDelegate.boardWidth != boardWidth ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.boardExtension != boardExtension;
}
