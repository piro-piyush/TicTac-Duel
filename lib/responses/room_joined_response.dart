import 'package:tictac_duel/lib.dart';

class RoomJoinedResponse {
  const RoomJoinedResponse({required this.room});

  final Room room;

  factory RoomJoinedResponse.fromJson(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid room joined response');
      }

      final data = Map<String, dynamic>.from(json);

      return RoomJoinedResponse(room: Room.fromJson(data));
    } catch (e) {
      rethrow;
    }
  }
}
