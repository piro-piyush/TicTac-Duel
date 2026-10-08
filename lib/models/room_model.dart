import 'package:tictac_duel/lib.dart';

class RoomModel extends GameModel {
  const RoomModel({
    required this.roomCode,
    required super.host,
    required this.guest,
    required this.hostPoints,
    required this.guestPoints,
    required this.hostReady,
    required this.guestReady,
    required this.turnPlayerId,
    required this.currentRound,
    required super.maxRounds,
    required this.status,
    required super.theme,
    required this.isPrivate,
    super.boardSize = GameConstants.boardSize,
  });

  final String roomCode;

  final PlayerModel? guest;
  final int hostPoints;
  final int guestPoints;
  final bool hostReady;
  final bool guestReady;
  final String? turnPlayerId;
  final int currentRound;
  final RoomStatus status;
  final bool isPrivate;

  RoomModel copyWith({
    String? roomCode,
    PlayerModel? host,
    PlayerModel? guest,
    int? hostPoints,
    int? guestPoints,
    bool? hostReady,
    bool? guestReady,
    String? turnPlayerId,
    String? nextTurnPlayerId,
    int? currentRound,
    int? maxRounds,
    RoomStatus? status,
    RoomTheme? theme,
    bool? isPrivate,
    bool clearGuest = false,
    bool clearTurnPlayerId = false,
  }) {
    return RoomModel(
      roomCode: roomCode ?? this.roomCode,
      host: host ?? this.host,
      guest: clearGuest ? null : guest ?? this.guest,
      hostPoints: hostPoints ?? this.hostPoints,
      guestPoints: guestPoints ?? this.guestPoints,
      hostReady: hostReady ?? this.hostReady,
      guestReady: guestReady ?? this.guestReady,
      turnPlayerId: clearTurnPlayerId
          ? null
          : turnPlayerId ?? this.turnPlayerId,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      status: status ?? this.status,
      theme: theme ?? this.theme,
      isPrivate: isPrivate ?? this.isPrivate,
      boardSize: boardSize,
    );
  }

  factory RoomModel.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid online game response');
      }
      final data = Map<String, dynamic>.from(json);
      final roomCode = data['roomCode'];
      final host = data['host'];
      final guest = data['guest'];
      final hostPoints = data['hostPoints'];
      final guestPoints = data['guestPoints'];
      final hostReady = data['hostReady'];
      final guestReady = data['guestReady'];
      final turnPlayerId = data['turnPlayerId'];

      final currentRound = data['currentRound'];
      final maxRounds = data['maxRounds'];
      final status = data['status'];
      final theme = data['theme'];
      final isPrivate = data['isPrivate'];
      if (roomCode is! String || roomCode.trim().isEmpty) {
        throw const FormatException('Invalid room code');
      }
      if (host is! Map) {
        throw const FormatException('Invalid room host');
      }
      if (guest != null && guest is! Map) {
        throw const FormatException('Invalid room guest');
      }
      if (hostPoints is! int) {
        throw const FormatException('Invalid host points');
      }
      if (guestPoints is! int) {
        throw const FormatException('Invalid guest points');
      }
      if (hostReady is! bool) {
        throw const FormatException('Invalid host ready state');
      }
      if (guestReady is! bool) {
        throw const FormatException('Invalid guest ready state');
      }
      if (turnPlayerId != null && turnPlayerId is! String) {
        throw const FormatException('Invalid turn player ID');
      }
      if (currentRound is! int) {
        throw const FormatException('Invalid current round');
      }
      if (maxRounds is! int) {
        throw const FormatException('Invalid max rounds');
      }
      if (status is! String) {
        throw const FormatException('Invalid room status');
      }
      if (theme is! String) {
        throw const FormatException('Invalid room theme');
      }
      if (isPrivate is! bool) {
        throw const FormatException('Invalid private room status');
      }
      return RoomModel(
        roomCode: roomCode,
        host: PlayerModel.fromJson(Map<String, dynamic>.from(host)),
        guest: guest == null
            ? null
            : PlayerModel.fromJson(Map<String, dynamic>.from(guest)),
        hostPoints: hostPoints,
        guestPoints: guestPoints,
        hostReady: hostReady,
        guestReady: guestReady,
        turnPlayerId: turnPlayerId,
        currentRound: currentRound,
        maxRounds: maxRounds,
        status: RoomStatus.values.byName(status),
        theme: RoomTheme.values.byName(theme),
        isPrivate: isPrivate,
      );
    } catch (e) {
      rethrow;
    }
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    try {
      return RoomModel(
        roomCode: json['roomCode'] as String,
        host: PlayerModel.fromJson(Map<String, dynamic>.from(json['host'])),
        guest: json['guest'] == null
            ? null
            : PlayerModel.fromJson(Map<String, dynamic>.from(json['guest'])),
        hostPoints: json['hostPoints'],
        guestPoints: json['guestPoints'],
        hostReady: json['hostReady'],
        guestReady: json['guestReady'],
        turnPlayerId: json['turnPlayerId'],
        currentRound: json['currentRound'],
        maxRounds: json['maxRounds'],
        status: RoomStatus.values.byName(json['status']),
        theme: RoomTheme.values.byName(json['theme']),
        isPrivate: json['isPrivate'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
