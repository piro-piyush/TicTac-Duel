import 'package:tictac_duel/lib.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.roomCode,
    required this.isPrivate,
    required this.hostPlayerId,
    required this.maxPlayers,
    required this.maxRounds,
    required this.currentRound,
    required this.roundStatus,
    required this.theme,
    required this.players,
    required this.turnPlayerId,
    required this.turnIndex,
    required this.boardSize,
  });

  final String id;
  final String roomCode;
  final bool isPrivate;
  final String hostPlayerId;
  final int maxPlayers;
  final int maxRounds;
  final int currentRound;
  final RoundStatus roundStatus;
  final RoomTheme theme;
  final List<PlayerModel> players;
  final String? turnPlayerId;
  final int turnIndex;
  final int boardSize;

  /// Number of players currently in the room.
  int get occupancy => players.length;

  /// Current player's turn.
  PlayerModel? get turn {
    final playerId = turnPlayerId;

    if (playerId == null) {
      return null;
    }

    for (final player in players) {
      if (player.id == playerId) {
        return player;
      }
    }

    return null;
  }

  factory RoomModel.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid room response');
    }

    final id = json['id'];
    final roomCode = json['roomCode'];
    final isPrivate = json['isPrivate'];
    final hostPlayerId = json['hostPlayerId'];
    final maxPlayers = json['maxPlayers'];
    final maxRounds = json['maxRounds'];
    final currentRound = json['currentRound'];
    final roundStatus = json['roundStatus'];
    final theme = json['theme'];
    final players = json['players'];
    final turnPlayerId = json['turnPlayerId'];
    final turnIndex = json['turnIndex'];
    final boardSize = json['boardSize'];

    if (id is! String || id.isEmpty) {
      throw const FormatException('Invalid room ID');
    }

    if (roomCode is! String || roomCode.isEmpty) {
      throw const FormatException('Invalid room code');
    }

    if (isPrivate is! bool) {
      throw const FormatException('Invalid room privacy value');
    }

    if (hostPlayerId is! String || hostPlayerId.isEmpty) {
      throw const FormatException('Invalid host player ID');
    }

    if (maxPlayers is! num) {
      throw const FormatException('Invalid maximum players value');
    }

    if (maxRounds is! num) {
      throw const FormatException('Invalid maximum rounds value');
    }

    if (currentRound is! num) {
      throw const FormatException('Invalid current round value');
    }

    if (roundStatus is! String) {
      throw const FormatException('Invalid round status');
    }

    if (theme is! String) {
      throw const FormatException('Invalid room theme');
    }

    if (players is! List) {
      throw const FormatException('Invalid players data');
    }

    if (turnPlayerId != null &&
        (turnPlayerId is! String || turnPlayerId.isEmpty)) {
      throw const FormatException('Invalid turn player ID');
    }

    if (turnIndex is! num) {
      throw const FormatException('Invalid turn index');
    }

    if (boardSize is! num) {
      throw const FormatException('Invalid board size');
    }

    late final RoundStatus parsedRoundStatus;
    late final RoomTheme parsedTheme;

    try {
      parsedRoundStatus = RoundStatus.values.byName(roundStatus);
    } catch (_) {
      throw const FormatException('Invalid round status');
    }

    try {
      parsedTheme = RoomTheme.values.byName(theme);
    } catch (_) {
      throw const FormatException('Invalid room theme');
    }

    final parsedPlayers = <PlayerModel>[];

    for (final player in players) {
      if (player is! Map) {
        throw const FormatException('Invalid player data');
      }

      try {
        parsedPlayers.add(
          PlayerModel.fromJson(Map<String, dynamic>.from(player)),
        );
      } catch (_) {
        throw const FormatException('Invalid player data');
      }
    }

    return RoomModel(
      id: id,
      roomCode: roomCode,
      isPrivate: isPrivate,
      hostPlayerId: hostPlayerId,
      maxPlayers: maxPlayers.toInt(),
      maxRounds: maxRounds.toInt(),
      currentRound: currentRound.toInt(),
      roundStatus: parsedRoundStatus,
      theme: parsedTheme,
      players: parsedPlayers,
      turnPlayerId: turnPlayerId as String?,
      turnIndex: turnIndex.toInt(),
      boardSize: boardSize.toInt(),
    );
  }
}
