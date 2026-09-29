import 'package:tictac_duel/lib.dart';

class RoomApiService {
  RoomApiService(this._httpService);

  final HttpService _httpService;

  // ===========================================================================
  // GET PUBLIC ROOMS
  // ===========================================================================

  Future<List<RoomModel>> getRooms() async {
    final rooms = await _httpService.get<List<dynamic>>(
      '/rooms/public',
    );

    return rooms
        .map(
          (room) => RoomModel.fromJson(
        Map<String, dynamic>.from(room as Map),
      ),
    )
        .toList();
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  Future<RoomModel> createRoom({
    required String playerId,
    required String playerName,
    required PlayerSymbol symbol,
    required RoomTheme theme,
    required int maxRounds,
    required bool isPrivate,
  }) async {
    final room = await _httpService.post<Map<String, dynamic>>(
      '/rooms',
      data: {
        'playerId': playerId,
        'playerName': playerName.trim(),
        'symbol': symbol.value,
        'theme': theme.value,
        'maxRounds': maxRounds,
        'isPrivate': isPrivate,
      },
    );

    return RoomModel.fromJson(room);
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  Future<RoomModel> joinRoom({
    required String playerId,
    required String playerName,
    required String roomCode,
  }) async {
    final room = await _httpService.post<Map<String, dynamic>>(
      '/rooms/join',
      data: {
        'playerId': playerId,
        'playerName': playerName.trim(),
        'roomCode': roomCode.trim().toUpperCase(),
      },
    );

    return RoomModel.fromJson(room);
  }
}