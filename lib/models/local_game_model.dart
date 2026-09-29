import 'package:tictac_duel/lib.dart';

class LocalGameModel {
  const LocalGameModel.friend({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
  })  : gameType = LocalGameType.friend,
        difficulty = null;

  factory LocalGameModel.computer({
    required LocalPlayerModel playerOne,
    required RoomTheme theme,
    required int maxRounds,
    required CpuDifficulty difficulty,
  }) {
    final cpuSymbol = playerOne.symbol == PlayerSymbol.x
        ? PlayerSymbol.o
        : PlayerSymbol.x;

    return LocalGameModel._(
      playerOne: playerOne,
      playerTwo: LocalPlayerModel(
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

  const LocalGameModel._({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
    required this.gameType,
    required this.difficulty,
  });

  final LocalPlayerModel playerOne;
  final LocalPlayerModel playerTwo;

  final RoomTheme theme;
  final int maxRounds;

  final LocalGameType gameType;
  final CpuDifficulty? difficulty;

  bool get isComputerGame => gameType == LocalGameType.computer;

  bool get isFriendGame => gameType == LocalGameType.friend;
}