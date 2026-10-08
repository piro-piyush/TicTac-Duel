import 'package:tictac_duel/lib.dart';

class LocalGameModel extends GameModel {
  const LocalGameModel.friend({
    required super.host,
    required this.guest,
    required super.theme,
    required super.maxRounds,
    super.boardSize = GameConstants.boardSize,
  }) : gameType = LocalGameType.friend,
        difficulty = null,
        super();

  factory LocalGameModel.computer({
    required PlayerModel playerOne,
    required RoomTheme theme,
    required int maxRounds,
    required CpuDifficulty difficulty,
    int boardSize = GameConstants.boardSize,
  }) {
    final cpuSymbol = playerOne.symbol == PlayerSymbol.x
        ? PlayerSymbol.o
        : PlayerSymbol.x;

    return LocalGameModel._(
      host: playerOne,
      guest: PlayerModel(
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
    required super.host,
    required this.guest,
    required super.theme,
    required super.maxRounds,
    required super.boardSize,
    required this.gameType,
    required this.difficulty,
  }) : super();

  final PlayerModel guest;

  final LocalGameType gameType;
  final CpuDifficulty? difficulty;

  bool get isComputerGame => gameType == LocalGameType.computer;

  bool get isFriendGame => gameType == LocalGameType.friend;
}
