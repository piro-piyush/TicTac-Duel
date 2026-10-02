import 'package:tictac_duel/lib.dart';

class PlayerJoinedResponse {
  const PlayerJoinedResponse({
    required this.player,
    required this.points,
    required this.isReady,
  });

  final OnlinePlayerModel player;
  final int points;
  final bool isReady;

  factory PlayerJoinedResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid player joined response');
    }

    final data = Map<String, dynamic>.from(json);

    final points = data['points'];
    final isReady = data['isReady'];

    if (points is! int) {
      throw const FormatException('Invalid player points');
    }

    if (isReady is! bool) {
      throw const FormatException('Invalid player ready status');
    }

    return PlayerJoinedResponse(
      player: OnlinePlayerModel.fromJson(data),
      points: points,
      isReady: isReady,
    );
  }
}