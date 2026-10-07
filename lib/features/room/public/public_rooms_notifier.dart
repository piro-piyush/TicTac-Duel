import 'package:tictac_duel/lib.dart';

final publicRoomsProvider =
    NotifierProvider<PublicRoomsNotifier, PublicRoomsState>(
      PublicRoomsNotifier.new,
    );

class PublicRoomsNotifier extends Notifier<PublicRoomsState> {
  late final RoomApiService _roomApiService;
  late final RoomSocketService _roomSocketService;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  @override
  PublicRoomsState build() {
    _roomApiService = ref.read(roomApiServiceProvider);
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _navigation = ref.read(appNavigationProvider);
    _gameDialog = ref.read(gameDialogProvider);

    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();

    ref.onDispose(() {
      playerNameController.dispose();
      playerNameFocusNode.dispose();
    });

    Future.microtask(fetchPublicRooms);

    return const PublicRoomsState();
  }

  void generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(offset: name.length);

    playerNameFocusNode.requestFocus();
  }

  Future<void> fetchPublicRooms() async {
    if (state.isFetchingRooms) {
      return;
    }

    state = state.copyWith(isFetchingRooms: true, clearError: true);

    try {
      final rooms = await _roomApiService.getRooms();

      state = state.copyWith(rooms: rooms);
    } catch (error, stackTrace) {
      _handleError(error, 'Failed to fetch public rooms.', stackTrace);
    } finally {
      state = state.copyWith(isFetchingRooms: false);
    }
  }

  Future<void> refreshRooms() {
    return fetchPublicRooms();
  }

  void showJoinDialog(Room room) {
    _gameDialog.show<void>(
      barrierDismissible: false,
      child: JoinPublicRoomDialogWidget(
        playerNameController: playerNameController,
        playerNameFocusNode: playerNameFocusNode,
        onGenerateRandomName: generateRandomName,
        onCancel: _gameDialog.closeOpenDialog,
        onJoin: () {
          _gameDialog.closeOpenDialog();
          joinPublicRoom(room);
        },
      ),
    );
  }

  Future<void> joinPublicRoom(Room room) async {
    if (state.isJoining || state.isFetchingRooms) {
      return;
    }

    final playerName = playerNameController.text.trim();

    if (playerName.isEmpty) {
      playerNameFocusNode.requestFocus();
      return;
    }

    state = state.copyWith(isJoining: true, clearError: true);

    try {
      await _roomSocketService.connect();

      _roomSocketService.joinRoom(
        roomCode: room.roomCode,
        name: playerName,
        onJoined: _handleRoomJoined,
        onError: _handleSocketError,
      );
    } catch (error, stackTrace) {
      _handleError(error, 'Failed to join room.', stackTrace);
    }
  }

  void _handleRoomJoined(RoomJoinedResponse response) {
    state = state.copyWith(isJoining: false);

    _clearForm();
    _navigation.pushGame(response.room);
  }

  void _handleSocketError(String message) {
    state = state.copyWith(isJoining: false, errorMessage: message);

    PopupUtils.showError(message);
  }

  void _clearForm() {
    playerNameController.clear();
    playerNameFocusNode.unfocus();

    state = state.copyWith(clearError: true);
  }

  void _handleError(
    Object error,
    String fallbackMessage,
    StackTrace stackTrace,
  ) {
    final message = error is ApiException ? error.message : fallbackMessage;

    if (error is! ApiException) {
      LoggerUtils.error('PublicRoomsNotifier', error, stackTrace);
    }

    state = state.copyWith(
      isJoining: false,
      isFetchingRooms: false,
      errorMessage: message,
    );

    PopupUtils.showError(message);

    LoggerUtils.error('Public rooms error: $message');

    clearError();
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }

    state = state.copyWith(clearError: true);
  }
}
