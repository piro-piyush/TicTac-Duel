import 'package:tictac_duel/lib.dart';

final publicRoomsProvider =
    NotifierProvider<PublicRoomsNotifier, PublicRoomsState>(
      PublicRoomsNotifier.new,
    );

class PublicRoomsNotifier extends Notifier<PublicRoomsState> {
  late final RoomApiService _roomApiService;
  late final PlayerNotifier _playerNotifier;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  @override
  PublicRoomsState build() {
    _roomApiService = ref.read(roomApiServiceProvider);
    _playerNotifier = ref.read(playerProvider.notifier);
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

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  void generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(offset: name.length);

    playerNameFocusNode.requestFocus();
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

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

  // ===========================================================================
  // JOIN PUBLIC ROOM
  // ===========================================================================

  void showJoinDialog(RoomModel room) {
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

  Future<void> joinPublicRoom(RoomModel room) async {
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
      final joinedRoom = await _roomApiService.joinRoom(
        playerId: _playerNotifier.playerId,
        playerName: playerName,
        roomCode: room.roomCode,
      );

      _clearForm();

      _navigation.pushGame(joinedRoom.roomCode);
    } catch (error, stackTrace) {
      _handleError(error, 'Failed to join room.', stackTrace);
    } finally {
      state = state.copyWith(isJoining: false);
    }
  }

  // ===========================================================================
  // CLEAR FORM
  // ===========================================================================

  void _clearForm() {
    playerNameController.clear();
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  void _handleError(
    Object error,
    String fallbackMessage,
    StackTrace stackTrace,
  ) {
    final message = error is ApiException ? error.message : fallbackMessage;

    if (error is! ApiException) {
      LoggerUtils.error('PublicRoomsNotifier', error, stackTrace);
    }

    state = state.copyWith(errorMessage: message);

    PopupUtils.showError(message);

    LoggerUtils.error('Public rooms error: $message');

    clearError();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
