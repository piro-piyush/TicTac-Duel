import 'package:tictac_duel/lib.dart';

class RoomApiService {
  RoomApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // GET PUBLIC ROOMS
  // ===========================================================================

  Future<List<Room>> getRooms() async {
    final rooms = await _httpService.get<List<dynamic>>('/rooms/public');

    return rooms
        .map(
          (room) => Room.fromJson(Map<String, dynamic>.from(room as Map)),
        )
        .toList();
  }

}
