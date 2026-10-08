import 'package:tictac_duel/lib.dart';

final createRoomProvider =
    NotifierProvider<CreateRoomNotifier, CreateRoomState>(
      CreateRoomNotifier.new,
    );

class CreateRoomNotifier extends Notifier<CreateRoomState> {
  late final RoomSocketService _roomSocketService;
  late final AppNavigation _navigation;

  late final GlobalKey<FormState> createFormKey;
  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  @override
  CreateRoomState build() {
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _navigation = ref.read(appNavigationProvider);

    createFormKey = GlobalKey<FormState>();
    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();

    ref.onDispose(_dispose);

    return const CreateRoomState();
  }

  void _dispose() {
    playerNameController.dispose();
    playerNameFocusNode.dispose();
  }

  // ===========================================================================
  // FORM
  // ===========================================================================

  void generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(offset: name.length);

    playerNameFocusNode.requestFocus();
    createFormKey.currentState?.validate();
  }

  // ===========================================================================
  // ROOM OPTIONS
  // ===========================================================================

  void setSelectedSymbol(PlayerSymbol symbol) =>
      state = state.copyWith(selectedSymbol: symbol);

  void setSelectedTheme(RoomTheme theme) =>
      state = state.copyWith(selectedTheme: theme);

  void setSelectedMaxRounds(int rounds) =>
      state = state.copyWith(selectedMaxRounds: rounds);

  void setIsPrivateRoom(bool isPrivate) =>
      state = state.copyWith(isRoomPrivate: isPrivate);

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

    final name = playerNameController.text.trim();

    state = state.copyWith(isCreating: true, clearError: true);

    try {
      await _roomSocketService.connect();

      _roomSocketService.createRoom(
        name: name,
        symbol: state.selectedSymbol,
        maxRounds: state.selectedMaxRounds,
        theme: state.selectedTheme,
        isPrivate: state.isRoomPrivate,
        onCreated: _handleRoomCreated,
        onError: _handleCreateError,
      );
    } catch (error, stackTrace) {
      _handleSocketError(error, stackTrace);
    }
  }

  void _handleRoomCreated(RoomCreatedResponse response) {
    state = state.copyWith(isCreating: false);

    _clearForm();
    _navigation.pushGame(response.room);
  }

  // ===========================================================================
  // ERROR HANDLING
  // ===========================================================================

  void _handleSocketError(Object error, StackTrace stackTrace) {
    final message = error is SocketException
        ? error.message
        : 'Failed to connect to the server.';

    if (error is! SocketException) {
      LoggerUtils.error('CreateRoomNotifier.createRoom', error, stackTrace);
    }

    state = state.copyWith(isCreating: false, errorMessage: message);

    PopupUtils.showError(message);
  }

  void _handleCreateError(String message) {
    state = state.copyWith(isCreating: false, errorMessage: message);

    PopupUtils.showError(message);
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  void _clearForm() {
    playerNameController.clear();
    createFormKey.currentState?.reset();
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }

    state = state.copyWith(clearError: true);
  }
}
