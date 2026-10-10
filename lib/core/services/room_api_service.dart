import 'package:tictac_duel/lib.dart';

class RoomApiService {
  RoomApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // GET PUBLIC ROOMS
  // ===========================================================================

  Future<List<RoomModel>> getRooms() async {
    final rooms = await _httpService.get<List<dynamic>>('/rooms/public');

    return rooms
        .map(
          (room) => RoomModel.fromJson(Map<String, dynamic>.from(room as Map)),
        )
        .toList();
  }
}
