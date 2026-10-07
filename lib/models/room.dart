import 'package:tictac_duel/lib.dart';

class Room {
  const Room({
    required this.roomCode,
    required this.host,
    required this.guest,
    required this.turnPlayerId,
    required this.currentRound,
    required this.maxRounds,
    required this.status,
    required this.theme,
    required this.isPrivate,
  });

  final String roomCode;
  final PlayerModel host;
  final PlayerModel? guest;

  final String? turnPlayerId;
  final int currentRound;
  final int maxRounds;
  final RoomStatus status;
  final RoomTheme theme;
  final bool isPrivate;

  Room copyWith({
    String? roomCode,
    PlayerModel? host,
    PlayerModel? guest,
    String? turnPlayerId,
    int? currentRound,
    int? maxRounds,
    RoomStatus? status,
    RoomTheme? theme,
    bool? isPrivate,
    bool clearGuest = false,
    bool clearTurnPlayerId = false,
  }) {
    return Room(
      roomCode: roomCode ?? this.roomCode,
      host: host ?? this.host,
      guest: clearGuest ? null : guest ?? this.guest,
      turnPlayerId: clearTurnPlayerId
          ? null
          : turnPlayerId ?? this.turnPlayerId,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      status: status ?? this.status,
      theme: theme ?? this.theme,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  factory Room.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid room response');
    }

    final data = Map<String, dynamic>.from(json);

    final roomCode = data['roomCode'];
    final host = data['host'];
    final guest = data['guest'];
    final turnPlayerId = data['turnPlayerId'];
    final currentRound = data['currentRound'];
    final maxRounds = data['maxRounds'];
    final status = data['status'];
    final theme = data['theme'];
    final isPrivate = data['isPrivate'];

    if (roomCode is! String || roomCode.trim().isEmpty) {
      throw const FormatException('Invalid room code');
    }

    if (host != null &&  host is! Map) {
      throw const FormatException('Invalid room host');
    }

    if (guest != null && guest is! Map) {
      throw const FormatException('Invalid room guest');
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

    return Room(
      roomCode: roomCode,
      host: PlayerModel.fromJson(host),
      guest: guest == null ? null : PlayerModel.fromJson(guest),
      turnPlayerId: turnPlayerId,
      currentRound: currentRound,
      maxRounds: maxRounds,
      status: RoomStatus.values.byName(status),
      theme: RoomTheme.values.byName(theme),
      isPrivate: isPrivate,
    );
  }
}

// class RoomPlayer {
// const RoomPlayer({
// required this.id,
// required this.name,
// required this.symbol,
// });
//
// final String id;
// final String name;
// final PlayerSymbol symbol;
//
// RoomPlayer copyWith({
// String? id,
// String? name,
// PlayerSymbol? symbol,
// }) {
// return RoomPlayer(
// id: id ?? this.id,
// name: name ?? this.name,
// symbol: symbol ?? this.symbol,
// );
// }
//
// factory RoomPlayer.fromJson(dynamic json) {
// if (json is! Map) {
// throw const FormatException('Invalid room player');
// }
//
// final data = Map<String, dynamic>.from(json);
//
// final id = data['id'];
// final name = data['name'];
// final symbol = data['symbol'];
//
// if (id is! String || id.isEmpty) {
// throw const FormatException('Invalid player ID');
// }
//
// if (name is! String || name.isEmpty) {
// throw const FormatException('Invalid player name');
// }
//
// if (symbol is! String) {
// throw const FormatException('Invalid player symbol');
// }
//
// return RoomPlayer(
// id: id,
// name: name,
// symbol: PlayerSymbol.values.byName(symbol),
// );
// }
// }
