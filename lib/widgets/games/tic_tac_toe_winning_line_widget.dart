import 'package:tictac_duel/lib.dart';

class TicTacToeWinningLineWidget extends StatefulWidget {
  const TicTacToeWinningLineWidget({
    super.key,
    required this.winningIndexes,
    required this.color,
    required this.boardSize,
    required this.boardWidth,
    required this.borderRadius,
    required this.gridSpacing,
    required this.boardExtension,
  });

  final Set<int> winningIndexes;
  final Color color;
  final int boardSize;

  /// Width of the actual Tic Tac Toe board.
  final double boardWidth;

  /// Border radius of the actual Tic Tac Toe board.
  final double borderRadius;

  final double gridSpacing;

  /// Extra line length beyond both board edges.
  final double boardExtension;

  @override
  State<TicTacToeWinningLineWidget> createState() =>
      _TicTacToeWinningLineWidgetState();
}

class _TicTacToeWinningLineWidgetState extends State<TicTacToeWinningLineWidget>
    with SingleTickerProviderStateMixin {
  // ===========================================================================
  // CONFIG
  // ===========================================================================

  static const Duration _animationDuration =
      GameConstants.winningLineAnimationDuration;

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  late final AnimationController _controller;

  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant TicTacToeWinningLineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final winningIndexesChanged =
        oldWidget.winningIndexes != widget.winningIndexes;

    final colorChanged = oldWidget.color != widget.color;

    if (winningIndexesChanged || colorChanged) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) => CustomPaint(
          painter: TicTacToeWinningLinePainter(
            winningIndexes: widget.winningIndexes,
            color: widget.color,
            boardSize: widget.boardSize,
            gridSpacing: widget.gridSpacing,
            progress: _progress.value,
            boardWidth: widget.boardWidth,
            borderRadius: widget.borderRadius,
            boardExtension: widget.boardExtension,
          ),
        ),
      ),
    ),
  );
}
