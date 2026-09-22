import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService._();

  static final RoomSocketService instance = RoomSocketService._();

  final SocketService _socket = SocketService.instance;

  void createRoom({
    required String playerName,
    required PlayerSymbol symbol,
    required RoomTheme theme,
  }) {
    _socket.off(RoomSocketEvents.roomCreated);

    _socket.on(RoomSocketEvents.roomCreated, (response) {
      final room = _parseRoom(response);

      if (room == null) {
        return;
      }

      _socket.off(RoomSocketEvents.roomCreated);
    });

    _socket.emit(RoomSocketEvents.createRoom, {
      'playerName': playerName,
      'symbol': symbol.value,
      'theme': theme.value,
    });
  }

  void joinRoom({required String roomCode, required String playerName}) {
    _socket.emit(RoomSocketEvents.joinRoom, {
      'roomCode': roomCode,
      'playerName': playerName,
    });
  }

  void leaveRoom({required String roomCode}) {
    _socket.emit(RoomSocketEvents.leaveRoom, {'roomCode': roomCode});
  }

  void onRoomCreated(void Function(RoomModel room) callback) {
    _socket.on(RoomSocketEvents.roomCreated, (response) {
      final room = _parseRoom(response);
      if (room != null) {
        callback(room);
      }
    });
  }

  void onRoomJoined(void Function(RoomModel room) callback) {
    _socket.on(RoomSocketEvents.roomJoined, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void onRoomUpdated(void Function(RoomModel room) callback) {
    _socket.on(RoomSocketEvents.roomUpdated, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void onPlayerJoined(void Function(RoomModel room) callback) {
    _socket.on(RoomSocketEvents.playerJoined, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void onPlayerLeft(void Function(RoomModel room) callback) {
    _socket.on(RoomSocketEvents.playerLeft, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void onRoomError(void Function(String message) callback) {
    _socket.on(RoomSocketEvents.roomError, (response) {
      if (response is! Map) {
        callback('Something went wrong.');
        return;
      }

      callback(response['message']?.toString() ?? 'Something went wrong.');
    });
  }

  RoomModel? _parseRoom(dynamic response) {
    if (response is! Map) {
      return null;
    }

    if (response['success'] != true) {
      return null;
    }

    final data = response['room'];

    if (data is! Map) {
      return null;
    }

    try {
      return RoomModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _socket.off(RoomSocketEvents.roomCreated);
    _socket.off(RoomSocketEvents.roomJoined);
    _socket.off(RoomSocketEvents.roomUpdated);
    _socket.off(RoomSocketEvents.playerJoined);
    _socket.off(RoomSocketEvents.playerLeft);
    _socket.off(RoomSocketEvents.roomError);
  }
}
