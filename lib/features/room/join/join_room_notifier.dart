import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

final joinRoomProvider =
    NotifierProvider.family<JoinRoomNotifier, JoinRoomState, String?>(
      JoinRoomNotifier.new,
    );

class JoinRoomNotifier extends Notifier<JoinRoomState> {
  JoinRoomNotifier(this.roomCode);

  final String? roomCode;

  late final RoomApiService _roomApiService;
  late final PlayerNotifier _playerNotifier;
  late final AppNavigation _navigation;

  late final GlobalKey<FormState> joinFormKey;

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  late final TextEditingController roomCodeController;
  late final FocusNode roomCodeFocusNode;

  @override
  JoinRoomState build() {
    _roomApiService = ref.read(roomApiServiceProvider);
    _playerNotifier = ref.read(playerProvider.notifier);
    _navigation = ref.read(appNavigationProvider);

    joinFormKey = GlobalKey<FormState>();

    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();

    roomCodeController = TextEditingController(
      text: roomCode?.trim().toUpperCase() ?? '',
    );
    roomCodeFocusNode = FocusNode();

    ref.onDispose(() {
      playerNameController.dispose();
      playerNameFocusNode.dispose();

      roomCodeController.dispose();
      roomCodeFocusNode.dispose();
    });

    return const JoinRoomState();
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
    joinFormKey.currentState?.validate();
  }

  // ===========================================================================
  // ROOM CODE
  // ===========================================================================

  Future<void> pasteRoomCode() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);

    final code = clipboard?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    if (ValidatorUtils.roomCode(code) != null) {
      return;
    }

    roomCodeController
      ..text = code
      ..selection = TextSelection.collapsed(offset: code.length);

    roomCodeFocusNode.requestFocus();
    joinFormKey.currentState?.validate();
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  Future<void> joinRoom() async {
    if (state.isJoining) {
      return;
    }

    if (!(joinFormKey.currentState?.validate() ?? false)) {
      return;
    }

    state = state.copyWith(isJoining: true, clearError: true);

    try {
      final room = await _roomApiService.joinRoom(
        playerId: _playerNotifier.playerId,
        playerName: playerNameController.text.trim(),
        roomCode: roomCodeController.text.trim().toUpperCase(),
      );

      _clearForm();

      _navigation.pushGame(room.roomCode);
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
    roomCodeController.clear();
    joinFormKey.currentState?.reset();
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
      LoggerUtils.error('JoinRoomNotifier.joinRoom', error, stackTrace);
    }

    state = state.copyWith(errorMessage: message);

    PopupUtils.showError(message);

    LoggerUtils.error('Join room error: $message');

    clearError();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
