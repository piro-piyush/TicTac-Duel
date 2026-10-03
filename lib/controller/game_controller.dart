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

  final RxList<PlayerSymbol?> _board = List<PlayerSymbol?>.filled(
    GameConstants.totalCells,
    null,
  ).obs;
  final RxSet<int> _winningIndexes = <int>{}.obs;

  final RxnString _errorMessage = RxnString();

  final RxnString _infoMessage = RxnString();

  final Rxn<RoundResultResponse> _roundResult = Rxn<RoundResultResponse>();
  final RxInt _playerOnePoints = 0.obs;
  final RxInt _playerTwoPoints = 0.obs;

  final RxBool _playerOneReady = false.obs;
  final RxBool _playerTwoReady = false.obs;
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

  int get playerOnePoints => _playerOnePoints.value;

  int get playerTwoPoints => _playerTwoPoints.value;

  bool get playerOneReady => _playerOneReady.value;

  bool get playerTwoReady => _playerTwoReady.value;

  PlayerModel? get playerOne => room?.playerOne;

  PlayerModel? get playerTwo => room?.playerTwo;

  bool get amIReady {
    final player = myPlayer;

    if (player == null) {
      return false;
    }

    if (player.id == playerOne?.id) {
      return playerOneReady;
    }

    return playerTwoReady;
  }

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    _listenForErrors();
    _initialize();
  }

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
    } catch (error) {
      setError(error.toString());
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

  void _handleRoomConnected(RoomConnectedResponse response) {
    _setRoom(response.room);

    _playerOnePoints.value = response.playerOnePoints;
    _playerTwoPoints.value = response.playerTwoPoints;

    _playerOneReady.value = response.playerOneReady;
    _playerTwoReady.value = response.playerTwoReady;

    _isLoading.value = false;

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

  void _handlePlayerJoined(PlayerJoinedResponse response) {
    _setPlayer(response.player);

    _playerTwoPoints.value = response.points;
    _playerTwoReady.value = response.isReady;
  }

  void _handlePlayerLeft(String playerId) {
    final currentRoom = _room.value;

    if (currentRoom == null) return;

    final isPlayerOne = currentRoom.playerOne.id == playerId;

    _removePlayer(playerId);

    if (isPlayerOne) {
      _playerOnePoints.value = 0;
      _playerOneReady.value = false;
    } else {
      _playerTwoPoints.value = 0;
      _playerTwoReady.value = false;
    }
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

    if (_board.length != GameConstants.totalCells) {
      _resetBoard();
    }

    final roundChanged =
        previousRound != null && previousRound != value.currentRound;

    final roundStarted = value.roundStatus == RoundStatus.playing;

    if (roundChanged && roundStarted) {
      _showRoundAnimationFor(value);
    }
  }

  void _setPlayer(OnlinePlayerModel player) {
    final currentRoom = _room.value;

    if (currentRoom == null) return;

    final players = [...currentRoom.players];
    final index = players.indexWhere((item) => item.id == player.id);

    if (index == -1) {
      players.add(player);
    } else {
      players[index] = player;
    }

    _room.value = currentRoom.copyWith(players: players);
  }

  void _removePlayer(String playerId) {
    final currentRoom = _room.value;

    if (currentRoom == null) return;

    _room.value = currentRoom.copyWith(
      players: currentRoom.players
          .where((player) => player.id != playerId)
          .toList(),
    );
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


  OnlinePlayerModel get currentPlayer {
    final currentRoom = room!;

    return currentRoom.players[currentRoom.turnIndex];
  }
  // bool get amIReady => myPlayer?.isReady ?? false;

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

    final symbol = currentRoom.players[currentRoom.turnIndex].symbol;

    _board[index] = symbol;

    final result = GameLogicUtils.checkWinner(_board);

    _roomSocketService.makeMove(
      roomCode: currentRoom.roomCode,
      index: index,
      playerId: playerId,
    );

    if (result == GameResult.inProgress) {
      return;
    }

    final winningIndexes = result == GameResult.draw
        ? <int>[]
        : GameLogicUtils.getWinningIndexes(_board).toList();

    _submitRoundResult(winningIndexes: winningIndexes);
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

    if (response.winningIndexes.isNotEmpty) {
      setWinningIndexes(response.winningIndexes.toSet());
    }

    if (!response.gameFinished) {
      return;
    }

    _showFinalResult();
  }

  void _submitRoundResult({required List<int> winningIndexes}) {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.submitGameResult(
      roomCode: currentRoom.roomCode,
      playerId: playerId,
      winningIndexes: winningIndexes,
    );
  }

  void _showFinalResult() {
    try {
      final currentRoom = room;

      if (currentRoom == null) {
        return;
      }

      final currentPlayerOne = currentRoom.playerOne;
      final currentPlayerTwo = currentRoom.playerTwo;

      final playerOnePoints = _playerOnePoints.value;
      final playerTwoPoints = _playerTwoPoints.value;

      final isDraw = playerOnePoints == playerTwoPoints;

      final winner = isDraw
          ? null
          : playerOnePoints > playerTwoPoints
          ? currentPlayerOne
          : currentPlayerTwo;

      final result = ResultModel(
        playerOne: currentPlayerOne,
        playerTwo: currentPlayerTwo,
        playerOnePoints: playerOnePoints,
        playerTwoPoints: playerTwoPoints,
        currentRound: currentRoom.currentRound,
        maxRounds: currentRoom.maxRounds,
        gameWinner: winner,
        hasWon: winner?.id == playerId,
        isDraw: isDraw,
        showConfetti: winner?.id == playerId,
        isOnline: true,
      );

      AppNavigation.replaceResult(result);
    } catch (error, stackTrace) {
      LoggerUtils.error('GameController._showFinalResult', error, stackTrace);

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

  void clearBoard() => _resetBoard();

  void _resetBoard() {
    _board.assignAll(
      List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );

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
