import 'package:tictac_duel/lib.dart';

class JoinRoomNotifier extends Notifier<JoinRoomState> {
  late final RoomSocketService _roomSocket;

  @override
  JoinRoomState build() {
    _roomSocket = RoomSocketService.instance;

    _roomSocket.onRoomJoined(_handleRoomJoined);
    _roomSocket.onRoomError(_handleRoomError);

    return const JoinRoomState();
  }

  void joinRoom({required String playerName, required String roomCode}) {
    state = state.copyWith(isJoining: true, clearError: true);

    _roomSocket.joinRoom(playerName: playerName, roomCode: roomCode);
  }

  void _handleRoomJoined(RoomModel room) {
    state = state.copyWith(isJoining: false);

    ref.read(roomProvider.notifier).setRoom(room);

    Routes.replaceToGame();
  }

  void _handleRoomError(String message) {
    state = state.copyWith(isJoining: false, errorMessage: message);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final joinRoomProvider = NotifierProvider<JoinRoomNotifier, JoinRoomState>(
  JoinRoomNotifier.new,
);
