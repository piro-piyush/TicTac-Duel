import 'package:tictac_duel/lib.dart';

class GameDismissedResponse {
  const GameDismissedResponse({
    required this.winnerPlayerId,
    required this.exitedPlayerId,
    required this.reason,
  });

  final String winnerPlayerId;
  final String exitedPlayerId;
  final GameDismissReason reason;

  factory GameDismissedResponse.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid game dismissed response');
      }

      final winnerPlayerId = json['winnerPlayerId'];
      final exitedPlayerId = json['exitedPlayerId'];
      final reason = json['reason'];

      if (winnerPlayerId is! String || winnerPlayerId.isEmpty) {
        throw const FormatException('Invalid winner player ID');
      }

      if (exitedPlayerId is! String || exitedPlayerId.isEmpty) {
        throw const FormatException('Invalid exited player ID');
      }

      if (reason is! String || reason.isEmpty) {
        throw const FormatException('Invalid dismissal reason');
      }

      return GameDismissedResponse(
        winnerPlayerId: winnerPlayerId,
        exitedPlayerId: exitedPlayerId,
        reason: GameDismissReason.values.byName(reason),
      );
    } catch (e) {
      rethrow;
    }
  }
}
