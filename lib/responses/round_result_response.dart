import 'package:tictac_duel/lib.dart';

class RoundResultResponse {
  const RoundResultResponse({
    required this.winnerId,
    required this.status,
    required this.winningIndexes,
    required this.gameFinished,
    required this.turnPlayerId,
    required this.turnIndex,
  });

  final String? winnerId;
  final RoomStatus? status;
  final List<int> winningIndexes;
  final bool gameFinished;
  final String turnPlayerId;
  final int turnIndex;

  factory RoundResultResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid round result response');
    }

    final winnerId = json['winnerId'];
    final status = json['status'];
    final winningIndexesData = json['winningIndexes'];
    final gameFinished = json['gameFinished'];
    final turnPlayerId = json['turnPlayerId'];
    final turnIndex = json['turnIndex'];

    if (winnerId != null && winnerId is! String) {
      throw const FormatException('Invalid winner ID');
    }

    if (status != null && status is! String) {
      throw const FormatException('Invalid status');
    }

    if (winningIndexesData is! List) {
      throw const FormatException('Invalid winning indexes');
    }

    if (winningIndexesData.any((index) => index is! int)) {
      throw const FormatException('Winning indexes must contain only integers');
    }

    if (gameFinished is! bool) {
      throw const FormatException('Invalid game finished value');
    }

    if (turnPlayerId is! String) {
      throw const FormatException('Invalid turn player ID');
    }

    if (turnIndex is! int || turnIndex < 0) {
      throw const FormatException('Invalid turn index');
    }

    return RoundResultResponse(
      winnerId: winnerId as String?,
      status: status != null
          ? RoomStatus.values.byName(status)
          : null,
      winningIndexes: List<int>.from(winningIndexesData),
      gameFinished: gameFinished,
      turnPlayerId: turnPlayerId,
      turnIndex: turnIndex,
    );
  }
}
