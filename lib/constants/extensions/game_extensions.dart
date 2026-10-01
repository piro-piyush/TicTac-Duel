import 'package:tictac_duel/lib.dart';

extension GameModeX on GameMode {
  String get displayName => switch (this) {
    GameMode.classic => 'Classic',
    GameMode.blitz => 'Blitz',
  };
  String get value => name;
}

extension GameResultX on GameResult {
  String get displayName => switch (this) {
    GameResult.xWins => 'X Wins',
    GameResult.oWins => 'O Wins',
    GameResult.draw => 'Draw',
    GameResult.inProgress => 'In Progress',
  };

  String get message => switch (this) {
    GameResult.xWins => 'Player X wins the round!',
    GameResult.oWins => 'Player O wins the round!',
    GameResult.draw => 'The round ended in a draw!',
    GameResult.inProgress => 'The game is still ongoing.',
  };
  String get value => name;
  bool get isFinished => this != GameResult.inProgress;

  bool get hasWinner => switch (this) {
    GameResult.xWins || GameResult.oWins => true,
    GameResult.draw || GameResult.inProgress => false,
  };

  PlayerSymbol? get winner => switch (this) {
    GameResult.xWins => PlayerSymbol.x,
    GameResult.oWins => PlayerSymbol.o,
    GameResult.draw || GameResult.inProgress => null,
  };
}