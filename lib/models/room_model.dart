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
  final List<OnlinePlayerModel> players;

  final String? turnPlayerId;
  final int turnIndex;
  final int boardSize;

  int get occupancy => players.length;

  OnlinePlayerModel? get turn {
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

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  OnlinePlayerModel get playerOne {
    if (players.isEmpty) {
      throw StateError('Room does not have player one');
    }

    return players[0];
  }

  OnlinePlayerModel get playerTwo {
    if (players.length < 2) {
      throw StateError('Room does not have player two');
    }

    return players[1];
  }

  factory RoomModel.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid room response');
    }

    final data = Map<String, dynamic>.from(json);

    try {
      final players = data['players'];

      if (players is! List) {
        throw const FormatException('Invalid players data');
      }

      return RoomModel(
        id: _requiredString(data, 'id'),
        roomCode: _requiredString(data, 'roomCode'),
        isPrivate: _requiredBool(data, 'isPrivate'),
        hostPlayerId: _requiredString(data, 'hostPlayerId'),
        maxPlayers: _requiredInt(data, 'maxPlayers'),
        maxRounds: _requiredInt(data, 'maxRounds'),
        currentRound: _requiredInt(data, 'currentRound'),
        roundStatus: RoundStatus.values.byName(
          _requiredString(data, 'roundStatus'),
        ),
        theme: RoomTheme.values.byName(_requiredString(data, 'theme')),
        players: players
            .map((player) => OnlinePlayerModel.fromJson(player))
            .toList(),
        turnPlayerId: _optionalString(data, 'turnPlayerId'),
        turnIndex: _requiredInt(data, 'turnIndex'),
        boardSize: _requiredInt(data, 'boardSize'),
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Invalid room response');
    }
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is! String || value.isEmpty) {
      throw FormatException('Invalid $key');
    }

    return value;
  }

  static String? _optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value == null) {
      return null;
    }

    if (value is! String || value.isEmpty) {
      throw FormatException('Invalid $key');
    }

    return value;
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is! bool) {
      throw FormatException('Invalid $key');
    }

    return value;
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is! num) {
      throw FormatException('Invalid $key');
    }

    return value.toInt();
  }


  RoomModel copyWith({
    String? id,
    String? roomCode,
    bool? isPrivate,
    String? hostPlayerId,
    int? maxPlayers,
    int? maxRounds,
    int? currentRound,
    RoundStatus? roundStatus,
    RoomTheme? theme,
    List<OnlinePlayerModel>? players,
    String? turnPlayerId,
    int? turnIndex,
    int? boardSize,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomCode: roomCode ?? this.roomCode,
      isPrivate: isPrivate ?? this.isPrivate,
      hostPlayerId: hostPlayerId ?? this.hostPlayerId,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      maxRounds: maxRounds ?? this.maxRounds,
      currentRound: currentRound ?? this.currentRound,
      roundStatus: roundStatus ?? this.roundStatus,
      theme: theme ?? this.theme,
      players: players ?? this.players,
      turnPlayerId: turnPlayerId ?? this.turnPlayerId,
      turnIndex: turnIndex ?? this.turnIndex,
      boardSize: boardSize ?? this.boardSize,
    );
  }
}
