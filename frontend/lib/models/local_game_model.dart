import 'package:tictac_duel/lib.dart';

class LocalGameModel {
  const LocalGameModel({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
    required this.gameType,
    this.difficulty,
    this.currentRound = 0,
    this.turnIndex = 0,
  });

  final PlayerModel playerOne;
  final PlayerModel playerTwo;

  final RoomTheme theme;

  final int maxRounds;
  final int currentRound;
  final int turnIndex;

  final LocalGameType gameType;
  final CpuDifficulty? difficulty;

  PlayerModel get currentPlayer {
    return turnIndex == 0 ? playerOne : playerTwo;
  }

  PlayerModel get opponentPlayer {
    return turnIndex == 0 ? playerTwo : playerOne;
  }

  PlayerSymbol get currentSymbol {
    return currentPlayer.symbol;
  }
}
