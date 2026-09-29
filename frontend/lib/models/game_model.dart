import 'package:tictac_duel/lib.dart';

class GameModel {
  const GameModel.friend({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
  }) : gameType = LocalGameType.friend,
       difficulty = null;

  factory GameModel.computer({
    required PlayerModel playerOne,
    required RoomTheme theme,
    required int maxRounds,
    required CpuDifficulty difficulty,
  }) {
    final cpuSymbol = playerOne.symbol == PlayerSymbol.x
        ? PlayerSymbol.o
        : PlayerSymbol.x;

    return GameModel._(
      playerOne: playerOne,
      playerTwo: PlayerModel(
        id: GameConstants.localCpuId,
        name: GameConstants.localCpuName,
        symbol: cpuSymbol,
      ),
      theme: theme,
      maxRounds: maxRounds,
      gameType: LocalGameType.computer,
      difficulty: difficulty,
    );
  }

  const GameModel._({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
    required this.gameType,
    required this.difficulty,
  });

  final PlayerModel playerOne;
  final PlayerModel playerTwo;
  final RoomTheme theme;
  final int maxRounds;
  final LocalGameType gameType;
  final CpuDifficulty? difficulty;

  bool get isComputerGame => gameType == LocalGameType.computer;
}
