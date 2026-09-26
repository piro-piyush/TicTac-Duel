import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class RoomController extends GetxController {
  RoomController({
    required this._roomApiService,
    required this._playerController,
  });

  // ===========================================================================
  // DEPENDENCIES
  // ===========================================================================

  final RoomApiService _roomApiService;
  final PlayerController _playerController;

  // ===========================================================================
  // FORM
  // ===========================================================================

  final formKey = GlobalKey<FormState>();

  final playerNameController = TextEditingController();
  final playerNameFocusNode = FocusNode();

  final roomCodeController = TextEditingController();
  final roomCodeFocusNode = FocusNode();

  // ===========================================================================
  // CREATE ROOM STATE
  // ===========================================================================

  final Rx<PlayerSymbol> _selectedSymbol = PlayerSymbol.x.obs;
  final Rx<RoomTheme> _selectedTheme = RoomTheme.classic.obs;
  final RxInt _selectedMaxRounds = 3.obs;
  final RxBool _isRoomPrivate = true.obs;

  // ===========================================================================
  // REQUEST STATE
  // ===========================================================================

  final RxBool _isCreating = false.obs;
  final RxBool _isJoining = false.obs;

  final RxnString _errorMessage = RxnString();

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  PlayerSymbol get selectedSymbol => _selectedSymbol.value;

  RoomTheme get selectedTheme => _selectedTheme.value;

  int get selectedMaxRounds => _selectedMaxRounds.value;

  bool get isRoomPrivate => _isRoomPrivate.value;

  bool get isCreating => _isCreating.value;

  bool get isJoining => _isJoining.value;

  bool get isLoading => isCreating || isJoining;

  String? get errorMessage => _errorMessage.value;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    playerNameFocusNode.requestFocus();

    ever<String?>(_errorMessage, (message) {
      if (message == null) {
        return;
      }

      SnackbarUtils.showError('Room error: $message');

      clearError();
    });
  }

  // ===========================================================================
  // PLAYER NAME
  // ===========================================================================

  void generateRandomName() {
    playerNameController.text = GameNameUtils.random();

    playerNameController.selection = TextSelection.collapsed(
      offset: playerNameController.text.length,
    );

    playerNameFocusNode.requestFocus();

    formKey.currentState?.validate();
  }

  // ===========================================================================
  // ROOM CODE
  // ===========================================================================

  Future<void> pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);

    final code = data?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    roomCodeController.text = code.length > 8 ? code.substring(0, 8) : code;

    roomCodeController.selection = TextSelection.collapsed(
      offset: roomCodeController.text.length,
    );

    roomCodeFocusNode.requestFocus();

    formKey.currentState?.validate();
  }

  // ===========================================================================
  // CREATE ROOM OPTIONS
  // ===========================================================================

  void setSelectedSymbol(PlayerSymbol symbol) {
    _selectedSymbol.value = symbol;
  }

  void setSelectedTheme(RoomTheme theme) {
    _selectedTheme.value = theme;
  }

  void setSelectedMaxRounds(int rounds) {
    _selectedMaxRounds.value = rounds;
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  Future<void> createRoom() async {
    if (isLoading) {
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      playerNameFocusNode.requestFocus();
      return;
    }

    try {
      _isCreating.value = true;
      _errorMessage.value = null;

      final room = await _roomApiService.createRoom(
        playerId: _playerController.playerId,
        playerName: playerNameController.text.trim(),
        symbol: selectedSymbol,
        theme: selectedTheme,
        maxRounds: selectedMaxRounds,
        isPrivate: isRoomPrivate,
      );

      AppNavigation.replaceToGame(room.id);
    } catch (error) {
      _errorMessage.value = error.toString();
    } finally {
      _isCreating.value = false;
    }
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  Future<void> joinRoom() async {
    if (isLoading) {
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      _isJoining.value = true;
      _errorMessage.value = null;

      final room = await _roomApiService.joinRoom(
        playerId: _playerController.playerId,
        playerName: playerNameController.text.trim(),
        roomCode: roomCodeController.text.trim().toUpperCase(),
      );

      AppNavigation.replaceToGame(room.id);

    } catch (error) {
      _errorMessage.value = error.toString();
    } finally {
      _isJoining.value = false;
    }
  }

  // ===========================================================================
  // JOIN PUBLIC ROOM
  // ===========================================================================

  Future<void> joinPublicRoom(RoomModel room) async {
    if (isLoading) {
      return;
    }

    if (playerNameController.text.trim().isEmpty) {
      playerNameFocusNode.requestFocus();
      return;
    }

    try {
      _isJoining.value = true;
      _errorMessage.value = null;

      final joinedRoom = await _roomApiService.joinRoom(
        playerId: _playerController.playerId,
        playerName: playerNameController.text.trim(),
        roomCode: room.code,
      );

      AppNavigation.replaceWaitingRoom(joinedRoom);
    } catch (error) {
      _errorMessage.value = error.toString();
    } finally {
      _isJoining.value = false;
    }
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  void refreshRooms() {
    update();
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  void clearError() {
    _errorMessage.value = null;
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    playerNameController.dispose();
    playerNameFocusNode.dispose();

    roomCodeController.dispose();
    roomCodeFocusNode.dispose();

    super.onClose();
  }
}
