import 'package:tictac_duel/lib.dart';

final createRoomProvider =
    NotifierProvider.autoDispose<CreateRoomNotifier, CreateRoomState>(
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

    return CreateRoomState.initial();
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
    state = state.copyWith(isCreating: true);
    try {
      _roomSocketService.createRoom(
        name: playerNameController.text.trim(),
        symbol: state.selectedSymbol,
        maxRounds: state.selectedMaxRounds,
        theme: state.selectedTheme,
        isPrivate: state.isRoomPrivate,
        onCreated: onRoomCreated,
        onError: onCreateRoomError,
      );
    } catch (error) {
      state = state.copyWith(isCreating: false);
      PopupUtils.showError(error.toString());
    }
  }

  void onRoomCreated(RoomCreatedResponse response) {
    _roomSocketService.offCreateRoomListeners();
    state = CreateRoomState.initial();
    playerNameController.clear();
    _navigation.pushGame(response.room);
  }

  void onCreateRoomError(String error) {
    _roomSocketService.offCreateRoomListeners();
    state = state.copyWith(isCreating: false);
    PopupUtils.showToast(error);
  }
}
