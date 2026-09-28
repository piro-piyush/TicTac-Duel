

class GameDismissedResponse {
  const GameDismissedResponse({
    required this.winnerPlayerId,
    required this.disconnectedPlayerId,
    required this.reason,
  });

  final String winnerPlayerId;
  final String disconnectedPlayerId;
  final String reason;

  factory GameDismissedResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid game dismissed response');
    }

    final winnerPlayerId = json['winnerPlayerId'];
    final disconnectedPlayerId = json['disconnectedPlayerId'];
    final reason = json['reason'];

    if (winnerPlayerId is! String || winnerPlayerId.isEmpty) {
      throw const FormatException('Invalid winner player ID');
    }

    if (disconnectedPlayerId is! String || disconnectedPlayerId.isEmpty) {
      throw const FormatException('Invalid disconnected player ID');
    }

    if (reason is! String || reason.isEmpty) {
      throw const FormatException('Invalid dismissal reason');
    }

    return GameDismissedResponse(
      winnerPlayerId: winnerPlayerId,
      disconnectedPlayerId: disconnectedPlayerId,
      reason: reason,
    );
  }
}
