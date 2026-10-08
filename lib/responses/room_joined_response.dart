import 'package:tictac_duel/lib.dart';

class RoomJoinedResponse {
  const RoomJoinedResponse({required this.room});

  final RoomModel room;

  factory RoomJoinedResponse.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid room joined response');
      }

      final data = Map<String, dynamic>.from(json);

      return RoomJoinedResponse(room: RoomModel.fromJson(data));
    } catch (e) {
      rethrow;
    }
  }
}
