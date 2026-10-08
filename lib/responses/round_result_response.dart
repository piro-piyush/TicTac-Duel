import 'package:tictac_duel/lib.dart';

class RoundResultResponse {
  const RoundResultResponse({
    required this.winnerId,
    required this.status,
    required this.winningIndexes,
    required this.gameFinished,
  });

  final String? winnerId;
  final RoomStatus status;
  final List<int> winningIndexes;
  final bool gameFinished;

  factory RoundResultResponse.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid round result response');
      }
      final winnerId = json['winnerId'];
      final status = json['status'];
      final winningIndexes = json['winningIndexes'];
      final gameFinished = json['gameFinished'];
      if (winnerId != null && winnerId is! String) {
        throw const FormatException('Invalid winner ID');
      }
      if (status != null && status is! String) {
        throw const FormatException('Invalid round status');
      }
      if (winningIndexes is! List ||
          winningIndexes.any((index) => index is! int)) {
        throw const FormatException('Invalid winning indexes');
      }
      if (gameFinished is! bool) {
        throw const FormatException('Invalid game finished value');
      }
      return RoundResultResponse(
        winnerId: winnerId as String?,
        status: RoomStatus.values.byName(status),
        winningIndexes: List<int>.from(winningIndexes),
        gameFinished: gameFinished,
      );
    } catch (e) {
      rethrow;
    }
  }
}
