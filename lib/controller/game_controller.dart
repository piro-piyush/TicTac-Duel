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

  final Rxn<RoundResultResponse> _roundResult = Rxn<RoundResultResponse>();

  final RxBool _isLoading = false.obs;

  final RxBool _showRoundAnimation = false.obs;

  final RxInt _animatedRound = 0.obs;

  Timer? _roundAnimationTimer;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  RoomModel? get room => _room.value;

  List<PlayerSymbol?> get board => _board.toList();

  Set<int> get winningIndexes => _winningIndexes.toSet();

  String? get errorMessage => _errorMessage.value;

  String? get infoMessage => _infoMessage.value;

  RoundResultResponse? get roundResult => _roundResult.value;

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
    clearError();

    try {
      _listenToSocketEvents();

      await _roomSocketService.connect(
        roomCode: roomCode,
        playerId: playerId,
        onConnected: _handleRoomConnected,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('GameController._initialize', error, stackTrace);

      setError(error.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  // ===========================================================================
  // SOCKET
  // ===========================================================================

  void _listenToSocketEvents() {
    _roomSocketService.onPlayerJoined(_handlePlayerJoined);
    _roomSocketService.onPlayerLeft(_handlePlayerLeft);
    _roomSocketService.onReadyUpdated(_handleReadyUpdated);
    _roomSocketService.onRoundStarted(_handleRoundStarted);
    _roomSocketService.onRoomClosed(_handleRoomClosed);
    _roomSocketService.onGameDismissed(_handleGameDismissed);
    _roomSocketService.onMoveMade(_handleMoveMade);
    _roomSocketService.onRoundResult(_handleRoundResult);
    _roomSocketService.onRoomError(_handleRoomError);
  }

  void _handleRoomConnected(RoomModel connectedRoom) {
    _setRoom(connectedRoom);

    clearError();
    clearInfo();
  }

  void _handleReadyUpdated(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
  }

  void _handleRoundStarted(RoomModel updatedRoom) {
    _setRoom(updatedRoom);
    _prepareNewRound(updatedRoom);
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

  void _handleGameDismissed(GameDismissedResponse response) {
    GameDialogUtils.showGameDismissed(reason: response.reason);
  }

  // ===========================================================================
  // ROOM STATE
  // ===========================================================================

  void _setRoom(RoomModel value) {
    final previousRoom = _room.value;
    final previousRound = previousRoom?.currentRound;

    _room.value = value;

    if (_board.length != value.boardSize) {
      _resetBoard(value.boardSize);
    }

    final roundChanged =
        previousRound != null && previousRound != value.currentRound;

    final roundStarted = value.roundStatus == RoundStatus.playing;

    if (roundChanged && roundStarted) {
      _showRoundAnimationFor(value);
    }
  }

  void _prepareNewRound(RoomModel currentRoom) {
    _roundResult.value = null;

    clearBoard();

    if (currentRoom.roundStatus == RoundStatus.playing) {
      _showRoundAnimationFor(currentRoom);
    }
  }

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  OnlinePlayerModel? get myPlayer {
    final currentRoom = room;

    if (currentRoom == null) {
      return null;
    }

    return currentRoom.players
        .where((player) => player.id == playerId)
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

  bool get isMyTurn {
    final currentRoom = room;

    if (currentRoom == null) {
      return false;
    }

    return currentRoom.turnPlayerId == playerId;
  }

  bool get isGamePlaying {
    return room?.roundStatus == RoundStatus.playing;
  }

  bool get isRoundResult {
    return room?.roundStatus == RoundStatus.result;
  }

  // bool get isGameFinished {
  //   return room?.roundStatus == RoundStatus.completed;
  // }

  // ===========================================================================
  // GAME
  // ===========================================================================

  void startGame() {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.startGame(roomCode: currentRoom.roomCode);
  }

  // ===========================================================================
  // READY
  // ===========================================================================

  void setReady() {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.setReady(roomCode: currentRoom.roomCode);
  }

  // ===========================================================================
  // MOVES
  // ===========================================================================

  void makeMove(int index) {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    if (!isGamePlaying || !isMyTurn) {
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
    _roundAnimationTimer?.cancel();

    _musicController.playRoundStart();

    _animatedRound.value = currentRoom.currentRound;
    _showRoundAnimation.value = true;

    _roundAnimationTimer = Timer(const Duration(milliseconds: 900), () {
      if (isClosed) {
        return;
      }

      _showRoundAnimation.value = false;
      _roundAnimationTimer = null;
    });
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void _handleRoundResult(RoundResultResponse response) {
    _roundResult.value = response;

    _setRoom(response.room);

    if (response.winningIndexes.isNotEmpty) {
      setWinningIndexes(response.winningIndexes.toSet());
    }

    if (!response.gameFinished) {
      return;
    }

    _showFinalResult(response.room);
  }

  void _showFinalResult(RoomModel room) {
    try {
      final playerOne = room.playerOne;
      final playerTwo = room.playerTwo;

      final isDraw = playerOne.points == playerTwo.points;

      final winner = isDraw
          ? null
          : playerOne.points > playerTwo.points
          ? playerOne
          : playerTwo;

      final result = ResultModel.online(
        playerOne: playerOne,
        playerTwo: playerTwo,
        currentRound: room.currentRound,
        maxRounds: room.maxRounds,
        gameWinner: winner,
        hasWon: winner?.id == playerId,
        isDraw: isDraw,
        showConfetti: winner?.id == playerId,
      );

      AppNavigation.replaceResult(result);
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'GameController._showFinalResult',
        error,
        stackTrace,
      );

      setInfo('Unable to load game result.');
    }
  }

  void prepareNextRound() {
    _roundResult.value = null;
    clearBoard();
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
    final boardSize = room?.boardSize ?? GameConstants.boardSize;

    _resetBoard(boardSize);
  }

  void _resetBoard(int boardSize) {
    _board.assignAll(List<PlayerSymbol?>.filled(boardSize, null));

    _winningIndexes.clear();
  }

  // ===========================================================================
  // MOVE RESPONSE
  // ===========================================================================

  void _handleMoveMade(MoveResultResponse response) {
    _setRoom(response.room);

    updateBoardValue(response.index, response.symbol);
  }

  bool get waitingForNextRound {
    return (room?.currentRound ?? 0) > 0;
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    _roundAnimationTimer?.cancel();
    _roundAnimationTimer = null;

    _roomSocketService.offReadyUpdated();
    _roomSocketService.offMoveMade();
    _roomSocketService.offRoundResult();
    _roomSocketService.offRoomError();

    _roomSocketService.disconnect();

    super.onClose();
  }
}
