import 'package:tictac_duel/lib.dart';

class PublicRoomsController extends GetxController {
  PublicRoomsController({
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

  final playerNameController = TextEditingController();
  final playerNameFocusNode = FocusNode();

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  final RxList<RoomModel> _rooms = <RoomModel>[].obs;

  // ===========================================================================
  // REQUEST STATE
  // ===========================================================================

  final RxBool _isFetchingRooms = false.obs;
  final RxBool _isJoining = false.obs;

  // ===========================================================================
  // ERROR
  // ===========================================================================

  final RxnString _errorMessage = RxnString();

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  List<RoomModel> get rooms => _rooms.toList(growable: false);

  bool get isFetchingRooms => _isFetchingRooms.value;

  bool get isJoining => _isJoining.value;

  String? get errorMessage => _errorMessage.value;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _listenForErrors();
    fetchPublicRooms();
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
  // JOIN PUBLIC ROOM
  // ===========================================================================

  Future<void> joinPublicRoom(RoomModel room) async {
    if (_isJoining.value || _isFetchingRooms.value) {
      return;
    }

    final playerName = playerNameController.text.trim();

    if (playerName.isEmpty) {
      playerNameFocusNode.requestFocus();
      return;
    }

    _isJoining.value = true;
    clearError();

    try {
      final joinedRoom = await _roomApiService.joinRoom(
        playerId: _playerController.playerId,
        playerName: playerName,
        roomCode: room.roomCode,
      );

      _isJoining.value = false;

      AppNavigation.pushGame(joinedRoom.roomCode);
    } catch (error) {
      _isJoining.value = false;
      _errorMessage.value = error.toString();
    }
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  Future<void> fetchPublicRooms() async {
    if (_isFetchingRooms.value) {
      return;
    }

    _isFetchingRooms.value = true;
    clearError();

    try {
      final rooms = await _roomApiService.getRooms();

      _rooms.assignAll(rooms);
    } catch (error) {
      _errorMessage.value = error.toString();
    } finally {
      _isFetchingRooms.value = false;
    }
  }

  Future<void> refreshRooms() {
    return fetchPublicRooms();
  }

  void showJoinDialog(RoomModel room) {
    Get.dialog(
      JoinPublicRoomDialogWidget(
        playerNameController: playerNameController,
        playerNameFocusNode: playerNameFocusNode,
        onGenerateRandomName: generateRandomName,
        onJoin: () {
          Get.back();
          joinPublicRoom(room);
        },
      ),
      barrierDismissible: false,
    );
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

    super.onClose();
  }
}
