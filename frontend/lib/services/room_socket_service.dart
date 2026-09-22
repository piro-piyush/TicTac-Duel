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
    _socket.emit('create_room', {
      'playerName': playerName,
      'symbol': symbol.value,
      'theme': theme.value,
    });
  }

  void joinRoom({required String roomCode, required String playerName}) {
    _socket.emit('join_room', {'roomCode': roomCode, 'playerName': playerName});
  }

  void leaveRoom({required String roomCode}) {
    _socket.emit('leave_room', {'roomCode': roomCode});
  }

  void onRoomCreated(void Function(dynamic data) callback) {
    _socket.on('room_created', callback);
  }

  void onRoomJoined(void Function(dynamic data) callback) {
    _socket.on('room_joined', callback);
  }

  void onRoomUpdated(void Function(dynamic data) callback) {
    _socket.on('room_updated', callback);
  }

  void onPlayerJoined(void Function(dynamic data) callback) {
    _socket.on('player_joined', callback);
  }

  void onPlayerLeft(void Function(dynamic data) callback) {
    _socket.on('player_left', callback);
  }

  void onRoomError(void Function(dynamic data) callback) {
    _socket.on('room_error', callback);
  }

  void dispose() {
    _socket.off('room_created');
    _socket.off('room_joined');
    _socket.off('room_updated');
    _socket.off('player_joined');
    _socket.off('player_left');
    _socket.off('room_error');
  }
}
