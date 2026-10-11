import 'package:tictac_duel/lib.dart';

abstract class GameModel {
  const GameModel({
    required this.host,
    required this.theme,
    required this.maxRounds,
    this.boardSize = GameConstants.boardSize,
  });

  final PlayerModel host;

  final RoomTheme theme;
  final int maxRounds;
  final int boardSize;
}
