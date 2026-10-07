import 'package:tictac_duel/lib.dart';

class RoomCreatedResponse {
  const RoomCreatedResponse({required this.room});

  final Room room;

  factory RoomCreatedResponse.fromJson(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid room created response');
      }

      final data = Map<String, dynamic>.from(json);

      return RoomCreatedResponse(room: Room.fromJson(data));
    } catch (e) {
      rethrow;
    }
  }
}
