import 'package:tictac_duel/lib.dart';

class RoundStartedResponse {
  const RoundStartedResponse({
    required this.currentRound,
    required this.status,
    required this.hostReady,
    required this.guestReady,
    required this.turnPlayerId,
  });

  final int currentRound;
  final RoomStatus status;
  final bool hostReady;
  final bool guestReady;
  final String turnPlayerId;

  factory RoundStartedResponse.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid round started response');
      }

      final currentRound = json['currentRound'];
      final status = json['status'];
      final hostReady = json['hostReady'];
      final guestReady = json['guestReady'];
      final turnPlayerId = json['turnPlayerId'];

      if (currentRound is! int || currentRound < 1) {
        throw const FormatException('Invalid current round');
      }

      if (status is! String || status.isEmpty) {
        throw const FormatException('Invalid room status');
      }

      if (hostReady is! bool) {
        throw const FormatException('Invalid host ready state');
      }

      if (guestReady is! bool) {
        throw const FormatException('Invalid guest ready state');
      }

      if (turnPlayerId is! String || turnPlayerId.isEmpty) {
        throw const FormatException('Invalid turn player ID');
      }

      return RoundStartedResponse(
        currentRound: currentRound,
        status: RoomStatus.values.byName(status),
        hostReady: hostReady,
        guestReady: guestReady,
        turnPlayerId: turnPlayerId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
