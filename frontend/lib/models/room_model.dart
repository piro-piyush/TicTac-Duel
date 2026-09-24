import 'package:tictac_duel/lib.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.code,
    required this.occupancy,
    required this.maxRounds,
    required this.currentRound,
    required this.roundStatus,
    required this.theme,
    required this.players,
    // required this.isPlaying,
    required this.turn,
    required this.turnIndex,
    required this.boardSize,
  });

  final String id;
  final String code;
  final int occupancy;
  final int maxRounds;
  final int currentRound;
  final RoomTheme theme;
  final List<PlayerModel> players;
  // final bool isPlaying;
  final PlayerModel? turn;
  final RoundStatus roundStatus;
  final int turnIndex;
  final int boardSize;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    try {
      return RoomModel(
        id: json['_id'] as String,
        code: json['code'] as String,
        occupancy: json['occupancy'] as int,
        maxRounds: json['maxRounds'] as int,
        currentRound: json['currentRound'] as int,
        theme: RoomTheme.values.byName(json['theme'] as String),
        roundStatus: RoundStatus.values.byName(json['roundStatus'] as String),
        players: (json['players'] as List)
            .map(
              (player) => PlayerModel.fromJson(
                Map<String, dynamic>.from(player as Map),
              ),
            )
            .toList(),
        // isPlaying: json['isPlaying'] as bool,
        turn: json['turn'] == null
            ? null
            : PlayerModel.fromJson(
                Map<String, dynamic>.from(json['turn'] as Map),
              ),
        turnIndex: json['turnIndex'] as int,
        boardSize: json['boardSize'] as int,
      );
    } catch (e) {
      rethrow;
    }
  }
}
