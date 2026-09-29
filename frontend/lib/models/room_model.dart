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

  int get occupancy => players.length;

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

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  PlayerModel get playerOne {
    if (players.isEmpty) {
      throw StateError('Room does not have player one');
    }

    return players[0];
  }

  PlayerModel get playerTwo {
    if (players.length < 2) {
      throw StateError('Room does not have player two');
    }

    return players[1];
  }

}
