import 'package:tictac_duel/lib.dart';

class GameRoundResultModel {
  const GameRoundResultModel({
    required this.result,
    required this.theme,
    required this.mySymbol,
    required this.winningIndexes,
  });

  final GameResult result;
  final RoomTheme theme;
  final PlayerSymbol mySymbol;
  final Set<int> winningIndexes;
}
