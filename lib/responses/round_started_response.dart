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

  factory RoundStartedResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid round started response');
    }

    return RoundStartedResponse(
      currentRound: json['currentRound'] as int,
      status: RoomStatus.values.byName(json['status'] as String),
      hostReady: json['hostReady'] as bool,
      guestReady: json['guestReady'] as bool,
      turnPlayerId: json['turnPlayerId'] as String,
    );
  }
}
