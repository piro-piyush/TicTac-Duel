import 'package:tictac_duel/lib.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.code,
    required this.occupancy,
    required this.maxRounds,
    required this.currentRound,
    required this.theme,
    required this.players,
    required this.isPlaying,
    required this.turn,
    required this.turnIndex,
  });

  final String id;
  final String code;
  final int occupancy;
  final int maxRounds;
  final int currentRound;
  final RoomTheme theme;
  final List<PlayerModel> players;
  final bool isPlaying;
  final PlayerModel? turn;
  final int turnIndex;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'] as String,
      code: json['code'] as String,
      occupancy: json['occupancy'] as int,
      maxRounds: json['maxRounds'] as int,
      currentRound: json['currentRound'] as int,
      theme: RoomTheme.fromValue(json['theme'] as String),
      players: (json['players'] as List)
          .map(
            (player) => PlayerModel.fromJson(
          Map<String, dynamic>.from(player as Map),
        ),
      )
          .toList(),
      isPlaying: json['isPlaying'] as bool,
      turn: json['turn'] == null
          ? null
          : PlayerModel.fromJson(
        Map<String, dynamic>.from(json['turn'] as Map),
      ),
      turnIndex: json['turnIndex'] as int,
    );
  }
}

class PlayerModel {
  const PlayerModel({
    required this.name,
    required this.symbol,
    required this.socketId,
    required this.points,
  });

  final String name;
  final PlayerSymbol symbol;
  final String socketId;
  final int points;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      name: json['name'] as String,
      symbol: PlayerSymbol.fromValue(json['symbol'] as String),
      socketId: json['socketId'] as String,
      points: json['points'] as int? ?? 0,
    );
  }
}