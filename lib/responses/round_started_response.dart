import 'package:tictac_duel/lib.dart';

class RoundStartedResponse {
  const RoundStartedResponse({
    required this.room,
    required this.playerOneReady,
    required this.playerTwoReady,
    required this.turnPlayerId,
    required this.turnIndex,
  });

  final RoomModel room;
  final bool playerOneReady;
  final bool playerTwoReady;
  final String turnPlayerId;
  final int turnIndex;

  factory RoundStartedResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid round started response');
    }

    final roomData = json['room'];
    final playerOneReady = json['playerOneReady'];
    final playerTwoReady = json['playerTwoReady'];
    final turnPlayerId = json['turnPlayerId'];
    final turnIndex = json['turnIndex'];

    if (roomData is! Map) {
      throw const FormatException('Invalid room data');
    }

    if (playerOneReady is! bool) {
      throw const FormatException('Invalid player one ready state');
    }

    if (playerTwoReady is! bool) {
      throw const FormatException('Invalid player two ready state');
    }

    if (turnPlayerId is! String) {
      throw const FormatException('Invalid turn player ID');
    }

    if (turnIndex is! int) {
      throw const FormatException('Invalid turn index');
    }

    return RoundStartedResponse(
      room: RoomModel.fromJson(roomData),
      playerOneReady: playerOneReady,
      playerTwoReady: playerTwoReady,
      turnPlayerId: turnPlayerId,
      turnIndex: turnIndex,
    );
  }
}