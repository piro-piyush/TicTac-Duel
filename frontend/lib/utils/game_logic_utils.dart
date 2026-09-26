import 'dart:math';

import 'package:tictac_duel/lib.dart';

class GameLogicUtils {
  static GameResult checkWinner(List<PlayerSymbol?> board) {

    final size = sqrt(board.length).toInt();

    if (size == 0 || size * size != board.length) {
      return GameResult.inProgress;
    }

    for (var i = 0; i < size; i++) {
      // Row
      final rowSymbol = board[i * size];

      if (rowSymbol != null &&
          List.generate(
            size,
            (j) => board[i * size + j],
          ).every((cell) => cell == rowSymbol)) {
        return rowSymbol == PlayerSymbol.x
            ? GameResult.xWins
            : GameResult.oWins;
      }

      // Column
      final columnSymbol = board[i];

      if (columnSymbol != null &&
          List.generate(
            size,
            (j) => board[j * size + i],
          ).every((cell) => cell == columnSymbol)) {
        return columnSymbol == PlayerSymbol.x
            ? GameResult.xWins
            : GameResult.oWins;
      }
    }

    // Main diagonal
    final diagonalSymbol = board[0];

    if (diagonalSymbol != null &&
        List.generate(
          size,
          (i) => board[i * size + i],
        ).every((cell) => cell == diagonalSymbol)) {
      return diagonalSymbol == PlayerSymbol.x
          ? GameResult.xWins
          : GameResult.oWins;
    }

    // Anti-diagonal
    final antiDiagonalSymbol = board[size - 1];

    if (antiDiagonalSymbol != null &&
        List.generate(
          size,
          (i) => board[i * size + (size - 1 - i)],
        ).every((cell) => cell == antiDiagonalSymbol)) {
      return antiDiagonalSymbol == PlayerSymbol.x
          ? GameResult.xWins
          : GameResult.oWins;
    }

    // Draw
    if (board.every((cell) => cell != null)) {
      return GameResult.draw;
    }

    return GameResult.inProgress;
  }

  static Set<int> getWinningIndexes(List<PlayerSymbol?> board) {

    final size = sqrt(board.length).toInt();

    if (size == 0 || size * size != board.length) {
      return {};
    }

    for (var i = 0; i < size; i++) {
      // Row
      final rowStart = i * size;
      final rowSymbol = board[rowStart];

      if (rowSymbol != null &&
          List.generate(
            size,
            (j) => board[rowStart + j],
          ).every((cell) => cell == rowSymbol)) {
        return {for (var j = 0; j < size; j++) rowStart + j};
      }

      // Column
      final columnSymbol = board[i];

      if (columnSymbol != null &&
          List.generate(
            size,
            (j) => board[j * size + i],
          ).every((cell) => cell == columnSymbol)) {
        return {for (var j = 0; j < size; j++) j * size + i};
      }
    }

    // Main diagonal
    final diagonalSymbol = board[0];

    if (diagonalSymbol != null &&
        List.generate(
          size,
          (i) => board[i * size + i],
        ).every((cell) => cell == diagonalSymbol)) {
      return {for (var i = 0; i < size; i++) i * size + i};
    }

    // Anti-diagonal
    final antiDiagonalSymbol = board[size - 1];

    if (antiDiagonalSymbol != null &&
        List.generate(
          size,
          (i) => board[i * size + (size - 1 - i)],
        ).every((cell) => cell == antiDiagonalSymbol)) {
      return {for (var i = 0; i < size; i++) i * size + (size - 1 - i)};
    }

    return {};
  }
}
