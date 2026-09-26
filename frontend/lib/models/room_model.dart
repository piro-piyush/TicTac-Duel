import 'package:tictac_duel/lib.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.code,
    required this.hostPlayerId,
    required this.occupancy,
    required this.maxRounds,
    required this.currentRound,
    required this.roundStatus,
    required this.theme,
    required this.players,
    required this.turn,
    required this.turnIndex,
    required this.boardSize,
  });

  final String id;
  final String hostPlayerId;
  final String code;
  final int occupancy;
  final int maxRounds;
  final int currentRound;
  final RoomTheme theme;
  final List<PlayerModel> players;
  final PlayerModel? turn;
  final RoundStatus roundStatus;
  final int turnIndex;
  final int boardSize;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    try {
      return RoomModel(
        id: json['id'] as String,
        code: json['code'] as String,
        hostPlayerId: json['hostPlayerId'] as String,
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

  static List<RoomModel> publicRooms = [
    RoomModel(
      id: 'public-room-1',
      hostPlayerId: 'mock-alex',
      code: 'ALEX01',
      occupancy: 1,
      maxRounds: 3,
      currentRound: 0,
      roundStatus: RoundStatus.waiting,
      theme: RoomTheme.classic,
      players: [
        PlayerModel(
          id: 'mock-alex',
          name: 'Alex',
          symbol: PlayerSymbol.x,
          socketId: 'mock-alex',
          points: 0,
          isReady: false,
        ),
      ],
      turn: null,
      turnIndex: 0,
      boardSize: 9,
    ),
    RoomModel(
      id: 'public-room-2',
      hostPlayerId: 'mock-shadow',
      code: 'SHDW01',
      occupancy: 1,
      maxRounds: 5,
      currentRound: 0,
      roundStatus: RoundStatus.waiting,
      theme: RoomTheme.inferno,
      players: [
        PlayerModel(
          id: 'mock-shadow',
          name: 'Shadow',
          symbol: PlayerSymbol.x,
          socketId: 'mock-shadow',
          points: 0,
          isReady: false,
        ),
      ],
      turn: null,
      turnIndex: 0,
      boardSize: 9,
    ),
    RoomModel(
      id: 'public-room-3',
      hostPlayerId: 'mock-nova',
      code: 'NOVA01',
      occupancy: 1,
      maxRounds: 7,
      currentRound: 0,
      roundStatus: RoundStatus.waiting,
      theme: RoomTheme.classic,
      players: [
        PlayerModel(
          id: 'mock-nova',
          name: 'Nova',
          symbol: PlayerSymbol.o,
          socketId: 'mock-nova',
          points: 0,
          isReady: false,
        ),
      ],
      turn: null,
      turnIndex: 0,
      boardSize: 9,
    ),
  ];
}
