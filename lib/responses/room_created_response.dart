import 'package:tictac_duel/lib.dart';

class RoomCreatedResponse {
  const RoomCreatedResponse({required this.room});

  final RoomModel room;

  factory RoomCreatedResponse.fromJson(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid room created response');
      }

      final data = Map<String, dynamic>.from(json);

      return RoomCreatedResponse(room: RoomModel.fromJson(data));
    } catch (e) {
      rethrow;
    }
  }
}
