import 'package:tictac_duel/lib.dart';

class PlayerJoinedResponse {
  const PlayerJoinedResponse({
    required this.player,
    this.points = 0,
    this.isReady = false,
  });

  final PlayerModel player;
  final int points;
  final bool isReady;

  factory PlayerJoinedResponse.fromSocket(dynamic data) {
    try {
      if (data is! Map) {
        throw const FormatException('Invalid player joined response');
      }

      final json = Map<String, dynamic>.from(data);

      final player = json['player'];
      final points = json['points'];
      final isReady = json['isReady'];

      if (player is! Map) {
        throw const FormatException('Invalid player');
      }

      if (points is! int) {
        throw const FormatException('Invalid player points');
      }

      if (isReady is! bool) {
        throw const FormatException('Invalid player ready status');
      }

      return PlayerJoinedResponse(
        player: PlayerModel.fromSocket(player),
        points: points,
        isReady: isReady,
      );
    } catch (e) {
      rethrow;
    }
  }
}
