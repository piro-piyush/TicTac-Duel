import 'package:tictac_duel/lib.dart';

final publicRoomsProvider =
    NotifierProvider.autoDispose<PublicRoomsNotifier, PublicRoomsState>(
      PublicRoomsNotifier.new,
    );

class PublicRoomsNotifier extends Notifier<PublicRoomsState> {
  late final RoomApiService _roomApiService;
  late final RoomSocketService _roomSocketService;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  @override
  PublicRoomsState build() {
    _roomApiService = ref.read(roomApiServiceProvider);
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _navigation = ref.read(appNavigationProvider);
    _gameDialog = ref.read(gameDialogProvider);

    Future.microtask(fetchPublicRooms);

    return const PublicRoomsState();
  }

  Future<void> fetchPublicRooms() async {
    if (state.isFetchingRooms) return;

    state = state.copyWith(isFetchingRooms: true);

    try {
      final rooms = await _roomApiService.getRooms();

      state = state.copyWith(rooms: rooms, isFetchingRooms: false);
    } catch (error) {
      final message = error.toString();

      state = state.copyWith(
        isJoining: false,
        isFetchingRooms: false,
        errorMessage: message,
      );

      PopupUtils.showError(message);
      LoggerUtils.error('Public rooms error: $message');
    }
  }

  Future<void> refreshRooms() => fetchPublicRooms();

  Future<void> showJoinDialog(RoomModel room) async {
    final name = await _gameDialog.show<String>(
      barrierDismissible: false,
      child: const JoinPublicRoomDialogWidget(),
    );

    if (name == null || name.isEmpty) return;

    await joinPublicRoom(room, name);
  }

  Future<void> joinPublicRoom(RoomModel room, String name) async {
    if (state.isJoining || state.isFetchingRooms) return;

    state = state.copyWith(isJoining: true);

    try {
      await _roomSocketService.connect();

      _roomSocketService.joinRoom(
        roomCode: room.roomCode,
        name: name,
        onJoined: (response) {
          state = state.copyWith(isJoining: false);
          _navigation.pushGame(response.room);
        },
        onError: (message) {
          state = state.copyWith(isJoining: false, errorMessage: message);

          PopupUtils.showError(message);
        },
      );
    } catch (error) {
      final message = error.toString();

      state = state.copyWith(
        isJoining: false,
        isFetchingRooms: false,
        errorMessage: message,
      );

      PopupUtils.showError(message);
      LoggerUtils.error('Public rooms error: $message');
    }
  }
}
