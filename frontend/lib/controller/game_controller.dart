import 'package:tictac_duel/lib.dart';

class GameController extends GetxController {
  GameController({
    required this.id,
    required this._socketService,
    required this._roomSocketService,
    required this._musicController,
    required this._playerController,
    required this._roomApiService,
  });

  final String id;

  // ===========================================================================
  // DEPENDENCIES
  // ===========================================================================

  final SocketService _socketService;

  final RoomSocketService _roomSocketService;

  final MusicController _musicController;

  final PlayerController _playerController;

  final RoomApiService _roomApiService;

  // ===========================================================================
  // STATE
  // ===========================================================================

  final Rxn<RoomModel> _room = Rxn<RoomModel>();

  final RxList<PlayerSymbol?> _board = <PlayerSymbol?>[].obs;

  final RxSet<int> _winningIndexes = <int>{}.obs;

  final RxnString _errorMessage = RxnString();

  final RxnString _infoMessage = RxnString();

  final Rxn<GameRoundResultModel> _roundResult = Rxn<GameRoundResultModel>();

  final RxBool _isLoading = false.obs;

  final RxBool _showRoundAnimation = false.obs;

  final RxInt _animatedRound = 0.obs;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  RoomModel? get room => _room.value;

  List<PlayerSymbol?> get board => _board;

  Set<int> get winningIndexes => _winningIndexes;

  String? get errorMessage => _errorMessage.value;

  String? get infoMessage => _infoMessage.value;

  GameRoundResultModel? get roundResult => _roundResult.value;

  bool get isLoading => _isLoading.value;

  bool get showRoundAnimation => _showRoundAnimation.value;

  int get animatedRound => _animatedRound.value;

  String? get socketId => _socketService.socketId;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      await _loadRoom();

      _listenToSocketEvents();

      _socketService.connect(
        roomCode: _room.value!.code,
        playerId: _playerController.playerId,
      );
    } catch (error) {
      _errorMessage.value = error.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadRoom() async {
    final loadedRoom = await _roomApiService.getRoom(id);

    _setRoom(loadedRoom);
  }

  // ===========================================================================
  // SOCKET
  // ===========================================================================

  void _listenToSocketEvents() {
    // Connect the room/game socket listeners here.
    //
    // Example:
    //
    // roomSocketService.onRoomUpdated(_handleRoomUpdated);
    // roomSocketService.onMoveMade(_handleMoveMade);
    // roomSocketService.onRoundResult(_handleRoundResult);
  }

  void _setRoom(RoomModel value) {
    final previousRound = _room.value?.currentRound;

    _room.value = value;

    if (_board.length != value.boardSize) {
      _board.assignAll(List<PlayerSymbol?>.filled(value.boardSize, null));
    }

    if (previousRound != null &&
        previousRound != value.currentRound &&
        value.roundStatus == RoundStatus.playing) {
      _showRoundAnimationFor(value);
    }
  }

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  PlayerModel? get myPlayer {
    final currentRoom = room;

    if (currentRoom == null) {
      return null;
    }

    return currentRoom.players
        .where((player) => player.id == _playerController.playerId)
        .firstOrNull;
  }

  bool get amIReady => myPlayer?.isReady ?? false;

  // ===========================================================================
  // GAME VISIBILITY
  // ===========================================================================

  bool get showGame {
    final currentRoom = room;

    if (currentRoom == null) {
      return false;
    }

    return currentRoom.roundStatus == RoundStatus.playing ||
        (currentRoom.roundStatus == RoundStatus.result && !amIReady);
  }

  bool get waitingForNextRound {
    return (room?.currentRound ?? 0) > 0;
  }

  bool get isMyTurn {
    final currentRoom = room;
    final currentSocketId = _socketService.socketId;

    if (currentRoom == null) {
      return false;
    }

    return currentRoom.turn?.socketId == currentSocketId;
  }

  // ===========================================================================
  // MOVES
  // ===========================================================================

  void makeMove(int index) {
    final currentRoom = room;
    final currentSocketId = _socketService.socketId;

    if (currentRoom == null) {
      return;
    }

    if (!isMyTurn) {
      return;
    }

    if (index < 0 || index >= _board.length) {
      return;
    }

    if (_board[index] != null) {
      return;
    }

    _roomSocketService.makeMove(roomCode: currentRoom.code, index: index);
  }

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  void _showRoundAnimationFor(RoomModel currentRoom) {
    _musicController.playRoundStart();

    _animatedRound.value = currentRoom.currentRound;
    _showRoundAnimation.value = true;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (isClosed) {
        return;
      }

      _showRoundAnimation.value = false;
    });
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void prepareNextRound() {
    _roundResult.value = null;

    // Call the socket action responsible for preparing/starting
    // the next round here.
    //
    // roomSocketService.prepareNextRound(
    //   roomCode: roomCode,
    // );
  }

  // ===========================================================================
  // MESSAGES
  // ===========================================================================

  void clearError() {
    _errorMessage.value = null;
  }

  void clearInfo() {
    _infoMessage.value = null;
  }

  void setError(String message) {
    _errorMessage.value = message;
  }

  void setInfo(String message) {
    _infoMessage.value = message;
  }

  // ===========================================================================
  // STATE UPDATES
  // ===========================================================================

  void updateBoardValue(int index, PlayerSymbol symbol) {
    if (index < 0 || index >= _board.length) {
      return;
    }

    if (_board[index] != null) {
      return;
    }

    _board[index] = symbol;
  }

  void setBoard(List<PlayerSymbol?> values) {
    _board.assignAll(values);
  }

  void setWinningIndexes(Set<int> indexes) {
    _winningIndexes
      ..clear()
      ..addAll(indexes);
  }

  void clearBoard() {
    final currentRoom = room;

    _board.assignAll(
      List<PlayerSymbol?>.filled(currentRoom?.boardSize ?? 9, null),
    );

    _winningIndexes.clear();
  }

  // ===========================================================================
  // SOCKET RESPONSE HANDLERS
  // ===========================================================================

  void handleRoomUpdated(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void handleMoveMade({
    required RoomModel updatedRoom,
    required int index,
    required PlayerSymbol symbol,
  }) {
    _setRoom(updatedRoom);
    updateBoardValue(index, symbol);
  }

  void handleRoundResult(GameRoundResultModel result) {
    _roundResult.value = result;

    if (result.winningIndexes.isNotEmpty) {
      setWinningIndexes(result.winningIndexes);
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    // Remove room/game socket listeners here if your
    // RoomSocketService exposes listener removal.
    //
    // roomSocketService.removeListeners();

    _socketService.disconnect();

    super.onClose();
  }
}
