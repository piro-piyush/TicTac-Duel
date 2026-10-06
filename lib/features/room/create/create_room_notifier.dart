import 'package:tictac_duel/lib.dart';

final createRoomProvider =
NotifierProvider<CreateRoomNotifier, CreateRoomState>(
  CreateRoomNotifier.new,
);

class CreateRoomNotifier extends Notifier<CreateRoomState> {
  late final RoomApiService _roomApiService;
  late final PlayerState _playerState;
  late final AppNavigation _navigation;

  late final GlobalKey<FormState> createFormKey;

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  @override
  CreateRoomState build() {
    _roomApiService = ref.read(roomApiServiceProvider);
    _playerState = ref.read(playerProvider);
    _navigation = ref.read(appNavigationProvider);

    createFormKey = GlobalKey<FormState>();

    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();

    ref.onDispose(() {
      playerNameController.dispose();
      playerNameFocusNode.dispose();
    });

    return const CreateRoomState();
  }

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  void generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(
        offset: name.length,
      );

    playerNameFocusNode.requestFocus();

    createFormKey.currentState?.validate();
  }

  // ===========================================================================
  // ROOM OPTIONS
  // ===========================================================================

  void setSelectedSymbol(PlayerSymbol symbol) {
    state = state.copyWith(
      selectedSymbol: symbol,
    );
  }

  void setSelectedTheme(RoomTheme theme) {
    state = state.copyWith(
      selectedTheme: theme,
    );
  }

  void setSelectedMaxRounds(int rounds) {
    state = state.copyWith(
      selectedMaxRounds: rounds,
    );
  }

  void setIsPrivateRoom(bool isPrivate) {
    state = state.copyWith(
      isRoomPrivate: isPrivate,
    );
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  Future<void> createRoom() async {
    if (state.isCreating) {
      return;
    }

    if (!(createFormKey.currentState?.validate() ?? false)) {
      playerNameFocusNode.requestFocus();
      return;
    }

    state = state.copyWith(
      isCreating: true,
      clearError: true,
    );

    try {
      final room = await _roomApiService.createRoom(
        playerId: _playerState.playerId!,
        playerName: playerNameController.text.trim(),
        symbol: state.selectedSymbol,
        theme: state.selectedTheme,
        maxRounds: state.selectedMaxRounds,
        isPrivate: state.isRoomPrivate,
      );

      _clearForm();

      _navigation.pushGame(room.roomCode);
    } catch (error, stackTrace) {
      _handleError(
        error,
        'Failed to create room.',
        stackTrace,
      );
    } finally {
      state = state.copyWith(
        isCreating: false,
      );
    }
  }

  // ===========================================================================
  // CLEAR FORM
  // ===========================================================================

  void _clearForm() {
    playerNameController.clear();
    createFormKey.currentState?.reset();
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  void _handleError(
      Object error,
      String fallbackMessage,
      StackTrace stackTrace,
      ) {
    final message = error is ApiException
        ? error.message
        : fallbackMessage;

    if (error is! ApiException) {
      LoggerUtils.error(
        'CreateRoomNotifier.createRoom',
        error,
        stackTrace,
      );
    }

    state = state.copyWith(
      errorMessage: message,
    );

    PopupUtils.showError(message);

    LoggerUtils.error(
      'Create room error: $message',
    );

    clearError();
  }

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }
}