import 'dart:math';

import 'package:tictac_duel/lib.dart';

class GameLogicUtils {
  GameLogicUtils._();

  static final Random _random = Random();

  // ─────────────────────────────────────────────────────────────
  // Game Result
  // ─────────────────────────────────────────────────────────────

  static GameResult checkWinner(List<PlayerSymbol?> board) {
    final size = sqrt(board.length).toInt();

    if (size == 0 || size * size != board.length) {
      return GameResult.inProgress;
    }

    for (var index = 0; index < size; index++) {
      // Row
      final rowStart = index * size;
      final rowSymbol = board[rowStart];

      if (rowSymbol != null &&
          _isWinningLine(
            board,
            start: rowStart,
            step: 1,
            length: size,
            symbol: rowSymbol,
          )) {
        return _resultFor(rowSymbol);
      }

      // Column
      final columnSymbol = board[index];

      if (columnSymbol != null &&
          _isWinningLine(
            board,
            start: index,
            step: size,
            length: size,
            symbol: columnSymbol,
          )) {
        return _resultFor(columnSymbol);
      }
    }

    // Main diagonal
    final diagonalSymbol = board[0];

    if (diagonalSymbol != null &&
        _isWinningLine(
          board,
          start: 0,
          step: size + 1,
          length: size,
          symbol: diagonalSymbol,
        )) {
      return _resultFor(diagonalSymbol);
    }

    // Anti-diagonal
    final antiDiagonalSymbol = board[size - 1];

    if (antiDiagonalSymbol != null &&
        _isWinningLine(
          board,
          start: size - 1,
          step: size - 1,
          length: size,
          symbol: antiDiagonalSymbol,
        )) {
      return _resultFor(antiDiagonalSymbol);
    }

    // Draw
    if (!board.contains(null)) {
      return GameResult.draw;
    }

    return GameResult.inProgress;
  }

  static bool _isWinningLine(
    List<PlayerSymbol?> board, {
    required int start,
    required int step,
    required int length,
    required PlayerSymbol symbol,
  }) {
    for (var index = 0; index < length; index++) {
      if (board[start + (index * step)] != symbol) {
        return false;
      }
    }

    return true;
  }

  static GameResult _resultFor(PlayerSymbol symbol) {
    return symbol == PlayerSymbol.x ? GameResult.xWins : GameResult.oWins;
  }

  // ─────────────────────────────────────────────────────────────
  // Winning Cells
  // ─────────────────────────────────────────────────────────────

  static Set<int> getWinningIndexes(List<PlayerSymbol?> board) {
    final size = sqrt(board.length).toInt();

    if (size == 0 || size * size != board.length) {
      return {};
    }

    for (var index = 0; index < size; index++) {
      // Row
      final rowStart = index * size;
      final rowSymbol = board[rowStart];

      if (rowSymbol != null &&
          _isWinningLine(
            board,
            start: rowStart,
            step: 1,
            length: size,
            symbol: rowSymbol,
          )) {
        return {for (var i = 0; i < size; i++) rowStart + i};
      }

      // Column
      final columnSymbol = board[index];

      if (columnSymbol != null &&
          _isWinningLine(
            board,
            start: index,
            step: size,
            length: size,
            symbol: columnSymbol,
          )) {
        return {for (var i = 0; i < size; i++) index + (i * size)};
      }
    }

    // Main diagonal
    final diagonalSymbol = board[0];

    if (diagonalSymbol != null &&
        _isWinningLine(
          board,
          start: 0,
          step: size + 1,
          length: size,
          symbol: diagonalSymbol,
        )) {
      return {for (var i = 0; i < size; i++) i * (size + 1)};
    }

    // Anti-diagonal
    final antiDiagonalSymbol = board[size - 1];

    if (antiDiagonalSymbol != null &&
        _isWinningLine(
          board,
          start: size - 1,
          step: size - 1,
          length: size,
          symbol: antiDiagonalSymbol,
        )) {
      return {for (var i = 0; i < size; i++) (size - 1) + (i * (size - 1))};
    }

    return {};
  }

  // ─────────────────────────────────────────────────────────────
  // CPU
  // ─────────────────────────────────────────────────────────────

  static int? getBestMove({
    required List<PlayerSymbol?> board,
    required CpuDifficulty difficulty,
    required PlayerSymbol cpuSymbol,
    required PlayerSymbol opponentSymbol,
  }) {
    final availableMoves = _getAvailableMoves(board);

    if (availableMoves.isEmpty) {
      return null;
    }

    switch (difficulty) {
      case CpuDifficulty.easy:
        return _getRandomMove(availableMoves);

      case CpuDifficulty.medium:
        return _getMediumMove(
          board: board,
          availableMoves: availableMoves,
          cpuSymbol: cpuSymbol,
          opponentSymbol: opponentSymbol,
        );

      case CpuDifficulty.hard:
        return _getHardMove(
          board: board,
          availableMoves: availableMoves,
          cpuSymbol: cpuSymbol,
          opponentSymbol: opponentSymbol,
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Easy CPU
  // ─────────────────────────────────────────────────────────────

  static int _getRandomMove(List<int> availableMoves) {
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  // ─────────────────────────────────────────────────────────────
  // Medium CPU
  // ─────────────────────────────────────────────────────────────

  static int _getMediumMove({
    required List<PlayerSymbol?> board,
    required List<int> availableMoves,
    required PlayerSymbol cpuSymbol,
    required PlayerSymbol opponentSymbol,
  }) {
    // Try to win.
    final winningMove = _findWinningMove(
      board: board,
      symbol: cpuSymbol,
      availableMoves: availableMoves,
    );

    if (winningMove != null) {
      return winningMove;
    }

    // Block the opponent.
    final blockingMove = _findWinningMove(
      board: board,
      symbol: opponentSymbol,
      availableMoves: availableMoves,
    );

    if (blockingMove != null) {
      return blockingMove;
    }

    // Take center.
    final center = board.length ~/ 2;

    if (board[center] == null) {
      return center;
    }

    // Otherwise choose randomly.
    return _getRandomMove(availableMoves);
  }

  static int? _findWinningMove({
    required List<PlayerSymbol?> board,
    required PlayerSymbol symbol,
    required List<int> availableMoves,
  }) {
    for (final index in availableMoves) {
      board[index] = symbol;

      final result = checkWinner(board);

      board[index] = null;

      if (result.winner == symbol) {
        return index;
      }
    }

    return null;
  }

  // ─────────────────────────────────────────────────────────────
  // Hard CPU - Minimax
  // ─────────────────────────────────────────────────────────────

  static int _getHardMove({
    required List<PlayerSymbol?> board,
    required List<int> availableMoves,
    required PlayerSymbol cpuSymbol,
    required PlayerSymbol opponentSymbol,
  }) {
    var bestScore = -1000;
    var bestMove = availableMoves.first;

    for (final index in availableMoves) {
      board[index] = cpuSymbol;

      final score = _minimax(
        board: board,
        isMaximizing: false,
        cpuSymbol: cpuSymbol,
        opponentSymbol: opponentSymbol,
      );

      board[index] = null;

      if (score > bestScore) {
        bestScore = score;
        bestMove = index;
      }
    }

    return bestMove;
  }

  static int _minimax({
    required List<PlayerSymbol?> board,
    required bool isMaximizing,
    required PlayerSymbol cpuSymbol,
    required PlayerSymbol opponentSymbol,
  }) {
    final result = checkWinner(board);

    // CPU wins.
    if (result.winner == cpuSymbol) {
      return 10;
    }

    // Opponent wins.
    if (result.winner == opponentSymbol) {
      return -10;
    }

    // Draw.
    if (result == GameResult.draw) {
      return 0;
    }

    final availableMoves = _getAvailableMoves(board);

    if (isMaximizing) {
      var bestScore = -1000;

      for (final index in availableMoves) {
        board[index] = cpuSymbol;

        final score = _minimax(
          board: board,
          isMaximizing: false,
          cpuSymbol: cpuSymbol,
          opponentSymbol: opponentSymbol,
        );

        board[index] = null;

        bestScore = max(bestScore, score);
      }

      return bestScore;
    }

    var bestScore = 1000;

    for (final index in availableMoves) {
      board[index] = opponentSymbol;

      final score = _minimax(
        board: board,
        isMaximizing: true,
        cpuSymbol: cpuSymbol,
        opponentSymbol: opponentSymbol,
      );

      board[index] = null;

      bestScore = min(bestScore, score);
    }

    return bestScore;
  }

  // ─────────────────────────────────────────────────────────────
  // Board Helpers
  // ─────────────────────────────────────────────────────────────

  static List<int> _getAvailableMoves(List<PlayerSymbol?> board) {
    final moves = <int>[];

    for (var index = 0; index < board.length; index++) {
      if (board[index] == null) {
        moves.add(index);
      }
    }

    return moves;
  }
}
