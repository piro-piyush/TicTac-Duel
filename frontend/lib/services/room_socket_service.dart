import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService._();

  static final RoomSocketService instance = RoomSocketService._();

  final SocketService _socket = SocketService.instance;

  // ---------------------------------------------------------------------------
  // Requests
  // ---------------------------------------------------------------------------

  void createRoom({
    required String playerName,
    required PlayerSymbol symbol,
    required RoomTheme theme,
  }) {
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

  // ---------------------------------------------------------------------------
  // Room Events
  // ---------------------------------------------------------------------------

  void onRoomCreated(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomCreated, callback);
  }

  void onRoomJoined(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomJoined, callback);
  }

  void onRoomUpdated(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomUpdated, callback);
  }

  // ---------------------------------------------------------------------------
  // Player Events
  // ---------------------------------------------------------------------------

  void onPlayerJoined(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.playerJoined, callback);
  }

  void onPlayerLeft(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.playerLeft, callback);
  }

  // ---------------------------------------------------------------------------
  // Error Events
  // ---------------------------------------------------------------------------

  void onRoomError(void Function(String message) callback) {
    _socket.off(RoomSocketEvents.roomError);

    _socket.on(RoomSocketEvents.roomError, (response) {
      if (response is! Map) {
        callback('Something went wrong.');
        return;
      }

      final message = response['message']?.toString();

      callback(
        message == null || message.isEmpty ? 'Something went wrong.' : message,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _listenToRoomEvent(
    String event,
    void Function(RoomModel room) callback,
  ) {
    _socket.off(event);

    _socket.on(event, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  RoomModel? _parseRoom(dynamic response) {
    if (response is! Map) {
      return null;
    }

    if (response['success'] != true) {
      return null;
    }

    final data = response['data'];

    if (data is! Map) {
      return null;
    }

    try {
      return RoomModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    _socket.off(RoomSocketEvents.roomCreated);
    _socket.off(RoomSocketEvents.roomJoined);
    _socket.off(RoomSocketEvents.roomUpdated);
    _socket.off(RoomSocketEvents.playerJoined);
    _socket.off(RoomSocketEvents.playerLeft);
    _socket.off(RoomSocketEvents.roomError);
  }
}
