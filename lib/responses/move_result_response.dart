import 'package:tictac_duel/lib.dart';

class MoveResultResponse {
  const MoveResultResponse({
    required this.index,
    required this.symbol,
    required this.playerId,
    required this.turnPlayerId,
    required this.turnIndex,
  });

  final int index;
  final PlayerSymbol symbol;
  final String playerId;
  final String turnPlayerId;
  final int turnIndex;

  factory MoveResultResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid move result response');
    }

    final index = json['index'];
    final symbolValue = json['symbol'];
    final playerId = json['playerId'];
    final turnPlayerId = json['turnPlayerId'];
    final turnIndex = json['turnIndex'];

    if (index is! int) {
      throw const FormatException('Invalid move index');
    }

    if (symbolValue is! String) {
      throw const FormatException('Invalid move symbol');
    }

    if (playerId is! String) {
      throw const FormatException('Invalid move player ID');
    }

    if (turnPlayerId is! String) {
      throw const FormatException('Invalid turn player ID');
    }

    if (turnIndex is! int) {
      throw const FormatException('Invalid turn index');
    }

    return MoveResultResponse(
      index: index,
      symbol: PlayerSymbol.values.byName(symbolValue),
      playerId: playerId,
      turnPlayerId: turnPlayerId,
      turnIndex: turnIndex,
    );
  }
}
