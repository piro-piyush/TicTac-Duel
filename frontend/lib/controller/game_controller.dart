import 'package:tictac_duel/lib.dart';

class GameController extends GetxController {
  GameController({
    required this.roomCode,
    required this._roomSocketService,
    required this._musicController,
    required this._playerController,
  });

  final String roomCode;

  // ===========================================================================
  // DEPENDENCIES
  // ===========================================================================

  final RoomSocketService _roomSocketService;

  final MusicController _musicController;

  final PlayerController _playerController;

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

  String get playerId => _playerController.playerId;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      _listenToSocketEvents();

      await _roomSocketService.connect(
        roomCode: roomCode,
        playerId: playerId,
        onConnected: _handleRoomConnected,
      );

      _isLoading.value = false;
    } catch (error) {
      _errorMessage.value = error.toString();
      _isLoading.value = false;
    }
  }

  // ===========================================================================
  // SOCKET
  // ===========================================================================

  void _listenToSocketEvents() {
    // _roomSocketService.onRoomConnected(_handleRoomConnected);

    _roomSocketService.onPlayerJoined(_handlePlayerJoined);
    _roomSocketService.onPlayerLeft(_handlePlayerLeft);
    _roomSocketService.onReadyUpdated(_handleReadyUpdated);
    _roomSocketService.onRoundStarted(_handleRoundStarted);
    _roomSocketService.onRoomClosed(_handleRoomClosed);
    _roomSocketService.onGameDismissed(_handleGameDismissed);

    _roomSocketService.onReadyUpdated(_handleReadyUpdated);

    _roomSocketService.onMoveMade(_handleMoveMade);

    _roomSocketService.onRoundResult(_handleRoundResult);

    _roomSocketService.onRoomError(_handleRoomError);
  }

  void _handleRoomConnected(RoomModel connectedRoom) {
    _setRoom(connectedRoom);

    _infoMessage.value = null;
    _errorMessage.value = null;
  }

  void _handleReadyUpdated(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void _handleRoundStarted(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void _handlePlayerJoined(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void _handlePlayerLeft(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void _handleRoomError(String message) {
    setError(message);
  }

  void _handleRoomClosed(String reason) {
    GameDialogUtils.showRoomClosed(reason: reason);
  }

  void _handleGameDismissed({
    required String winnerPlayerId,
    required String disconnectedPlayerId,
    required String reason,
  }) {
    GameDialogUtils.showGameDismissed(reason: reason, theme: room!.theme);
  }

  // ===========================================================================
  // ROOM STATE
  // ===========================================================================

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

  void startGame() {
    _roomSocketService.startGame(roomCode: room!.roomCode);
  }

  bool get isMyTurn {
    final currentRoom = room;

    if (currentRoom == null) {
      return false;
    }

    return currentRoom.turn?.id == _playerController.playerId;
  }

  // ===========================================================================
  // READY
  // ===========================================================================

  void setReady() {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.setReady(
      roomCode: currentRoom.roomCode,
      isReady: !amIReady,
    );
  }

  // ===========================================================================
  // MOVES
  // ===========================================================================

  void makeMove(int index) {
    final currentRoom = room;

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

    _roomSocketService.makeMove(roomCode: currentRoom.roomCode, index: index);
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

  void _handleRoundResult({
    required RoomModel room,
    required String winnerSocketId,
    required List<int> winningIndexes,
    required int completedRound,
    required bool gameFinished,
  }) {
    _setRoom(room);

    setWinningIndexes(winningIndexes.toSet());

    /*
     * Create GameRoundResultModel here once its constructor
     * is available.
     */

    if (gameFinished) {
      setInfo('Game completed.');
    }
  }

  void prepareNextRound() {
    _roundResult.value = null;
    _winningIndexes.clear();
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
  // BOARD STATE
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
      List<PlayerSymbol?>.filled(
        currentRoom?.boardSize ?? GameConstants.boardSize,
        null,
      ),
    );

    _winningIndexes.clear();
  }

  // ===========================================================================
  // MOVE RESPONSE
  // ===========================================================================

  void _handleMoveMade({
    required RoomModel room,
    required int index,
    required PlayerSymbol symbol,
  }) {
    _setRoom(room);

    updateBoardValue(index, symbol);
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    // _roomSocketService.offRoomConnected();
    _roomSocketService.offReadyUpdated();
    _roomSocketService.offMoveMade();
    _roomSocketService.offRoundResult();
    _roomSocketService.offRoomError();

    _roomSocketService.disconnect();

    super.onClose();
  }
}
