import 'package:tictac_duel/lib.dart';

class LocalGameModel {
  const LocalGameModel.friend({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
    this.boardSize = 3,
  }) : gameType = LocalGameType.friend,
       difficulty = null;

  factory LocalGameModel.computer({
    required PlayerModel playerOne,
    required RoomTheme theme,
    required int maxRounds,
    required CpuDifficulty difficulty,
    int boardSize = 3,
  }) {
    final cpuSymbol = playerOne.symbol == PlayerSymbol.x
        ? PlayerSymbol.o
        : PlayerSymbol.x;

    return LocalGameModel._(
      playerOne: playerOne,
      playerTwo: PlayerModel(
        id: GameConstants.localCpuId,
        name: GameConstants.localCpuName,
        symbol: cpuSymbol,
      ),
      theme: theme,
      maxRounds: maxRounds,
      boardSize: boardSize,
      gameType: LocalGameType.computer,
      difficulty: difficulty,
    );
  }

  const LocalGameModel._({
    required this.playerOne,
    required this.playerTwo,
    required this.theme,
    required this.maxRounds,
    required this.boardSize,
    required this.gameType,
    required this.difficulty,
  });

  final PlayerModel playerOne;
  final PlayerModel playerTwo;

  final RoomTheme theme;
  final int maxRounds;
  final int boardSize;
  final LocalGameType gameType;
  final CpuDifficulty? difficulty;

  bool get isComputerGame => gameType == LocalGameType.computer;

  bool get isFriendGame => gameType == LocalGameType.friend;
}
