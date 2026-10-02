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
  // CREATE ROOM
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

  // ===========================================================================
  // ERROR
  // ===========================================================================

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

  String? get errorMessage => _errorMessage.value;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _listenForErrors();
    _initialize();
  }

  void _initialize() {
    playerNameFocusNode.requestFocus();
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
    formKey.currentState?.validate();
  }

  // ===========================================================================
  // ROOM OPTIONS
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

  void setIsPrivateRoom(bool isPrivate) {
    _isRoomPrivate.value = isPrivate;
  }

  // ===========================================================================
  // ROOM CODE
  // ===========================================================================

  Future<void> pasteCode() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final code = clipboard?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    final normalizedCode = code.length > 8 ? code.substring(0, 8) : code;

    roomCodeController
      ..text = normalizedCode
      ..selection = TextSelection.collapsed(offset: normalizedCode.length);

    roomCodeFocusNode.requestFocus();
    formKey.currentState?.validate();
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  Future<void> createRoom() async {
    if (_isCreating.value || _isJoining.value) {
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      playerNameFocusNode.requestFocus();
      return;
    }

    _isCreating.value = true;
    clearError();

    try {
      final room = await _roomApiService.createRoom(
        playerId: _playerController.playerId,
        playerName: playerNameController.text.trim(),
        symbol: selectedSymbol,
        theme: selectedTheme,
        maxRounds: selectedMaxRounds,
        isPrivate: isRoomPrivate,
      );

      _isCreating.value = false;

      AppNavigation.pushGame(room.roomCode);
    } catch (error) {
      _isCreating.value = false;
      _errorMessage.value = error.toString();
    }
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  Future<void> joinRoom() async {
    if (_isJoining.value || _isCreating.value) {
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    _isJoining.value = true;
    clearError();

    try {
      final room = await _roomApiService.joinRoom(
        playerId: _playerController.playerId,
        playerName: playerNameController.text.trim(),
        roomCode: roomCodeController.text.trim().toUpperCase(),
      );

      _isJoining.value = false;

      AppNavigation.pushGame(room.roomCode);
    } catch (error) {
      _isJoining.value = false;
      _errorMessage.value = error.toString();
    }
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  void _listenForErrors() {
    ever<String?>(_errorMessage, (message) {
      if (message == null || message.isEmpty) {
        return;
      }

      PopupUtils.showError('Room error: $message');
      LoggerUtils.error('Room error: $message');
      clearError();
    });
  }

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
