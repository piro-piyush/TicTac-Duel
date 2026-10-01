import 'package:tictac_duel/lib.dart';

class MoveResultResponse {
  const MoveResultResponse({
    required this.room,
    required this.index,
    required this.symbol,
  });

  final RoomModel room;
  final int index;
  final PlayerSymbol symbol;

  factory MoveResultResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid move result response');
    }

    final roomData = json['room'];
    final moveData = json['move'];

    if (roomData is! Map) {
      throw const FormatException('Invalid room data');
    }

    if (moveData is! Map) {
      throw const FormatException('Invalid move data');
    }

    final index = moveData['index'];
    final symbolValue = moveData['symbol'];

    if (index is! int) {
      throw const FormatException('Invalid move index');
    }

    if (symbolValue is! String) {
      throw const FormatException('Invalid move symbol');
    }

    return MoveResultResponse(
      room: RoomModel.fromJson(Map<String, dynamic>.from(roomData)),
      index: index,
      symbol: PlayerSymbol.values.byName(symbolValue),
    );
  }
}
