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

  final RxBool _roundResultSubmitted = false.obs;
  final RxBool _movePending = false.obs;

  final RxInt _turnIndex = 0.obs;
  final RxnString _turnPlayerId = RxnString();

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

  String? get turnPlayerId => _turnPlayerId.value;

  int get turnIndex => _turnIndex.value;

  PlayerModel get playerOne {
    final currentRoom = room;

    if (currentRoom == null || currentRoom.players.isEmpty) {
      throw StateError('Room is not initialized');
    }

    return currentRoom.players.first;
  }

  PlayerModel? get playerTwo {
    final currentRoom = room;

    if (currentRoom == null || currentRoom.players.length < 2) {
      return null;
    }

    return currentRoom.players[1];
  }

  PlayerModel get myPlayer {
    final currentRoom = room;

    if (currentRoom == null) {
      throw StateError('Room is not initialized');
    }

    return currentRoom.players.firstWhere(
      (player) => player.id == playerId,
      orElse: () => throw StateError('Current player not found in room'),
    );
  }

  PlayerModel get currentPlayer {
    final currentRoom = room;

    if (currentRoom == null) {
      throw StateError('Room is not initialized');
    }

    if (_turnIndex.value < 0 ||
        _turnIndex.value >= currentRoom.players.length) {
      throw StateError('Invalid current player index');
    }

    return currentRoom.players[_turnIndex.value];
  }

  bool get amIReady {
    final currentPlayer = myPlayer;

    return currentPlayer.id == playerOne.id ? playerOneReady : playerTwoReady;
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
      _isLoading.value = false;
    }
  }

  // ===========================================================================
  // SOCKET EVENTS
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

    _turnPlayerId.value = response.turnPlayerId;
    _turnIndex.value = response.turnIndex;

    _isLoading.value = false;

    clearError();
    clearInfo();
  }

  void _handleReadyUpdated(ReadyUpdatedResponse response) {
    if (response.playerId == playerOne.id) {
      _playerOneReady.value = response.isReady;
      return;
    }

    if (response.playerId == playerTwo?.id) {
      _playerTwoReady.value = response.isReady;
    }
  }

  void _handleRoundStarted(RoundStartedResponse response) {
    _setRoom(response.room);

    _playerOneReady.value = response.playerOneReady;
    _playerTwoReady.value = response.playerTwoReady;

    _turnPlayerId.value = response.turnPlayerId;
    _turnIndex.value = response.turnIndex;

    _movePending.value = false;
    _roundResultSubmitted.value = false;
    _roundResult.value = null;
    clearBoard();
  }

  void _handlePlayerJoined(PlayerJoinedResponse response) {
    _setPlayer(response.player);

    _setPlayerPoints(response.player.id, response.points);

    _setPlayerReady(response.player.id, response.isReady);
  }

  void _handlePlayerLeft(String playerId) {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

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
    _roundResultSubmitted.value = false;
    _movePending.value = false;

    setError(message);
  }

  void _handleRoomClosed(String reason) {
    GameDialogUtils.showRoomClosed(reason: reason);
  }

  void _handleGameDismissed(GameDismissedResponse response) {
    final currentRoom = room;
    final currentPlayerTwo = playerTwo;

    if (currentRoom == null || currentPlayerTwo == null) {
      setInfo('Unable to load game result.');
      return;
    }

    final winner = currentRoom.players.firstWhereOrNull(
      (player) => player.id == response.winnerPlayerId,
    );

    if (winner == null) {
      setInfo('Unable to determine game winner.');
      return;
    }

    final result = ResultModel.dismissed(
      playerOne: playerOne,
      playerTwo: currentPlayerTwo,
      playerOnePoints: playerOnePoints,
      playerTwoPoints: playerTwoPoints,
      currentRound: currentRoom.currentRound,
      maxRounds: currentRoom.maxRounds,
      isOnline: true,
      gameWinner: winner,
      dismissReason: response.reason,
    );

    AppNavigation.replaceResult(result);
  }

  // ===========================================================================
  // ROOM STATE
  // ===========================================================================

  void _setRoom(RoomModel value) {
    final previousRoom = room;
    final previousRound = previousRoom?.currentRound;

    _room.value = value;

    final roundChanged =
        previousRound != null && previousRound != value.currentRound;

    final roundStarted = value.roundStatus == RoundStatus.playing;

    if (roundChanged && roundStarted) {
      _showRoundAnimationFor(value);
    }
  }

  void _setPlayer(PlayerModel player) {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

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
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _room.value = currentRoom.copyWith(
      players: currentRoom.players
          .where((player) => player.id != playerId)
          .toList(),
    );
  }

  // ===========================================================================
  // PLAYER STATE
  // ===========================================================================

  void _setPlayerPoints(String id, int points) {
    if (id == playerOne.id) {
      _playerOnePoints.value = points;
      return;
    }

    if (id == playerTwo?.id) {
      _playerTwoPoints.value = points;
    }
  }

  void _setPlayerReady(String id, bool isReady) {
    if (id == playerOne.id) {
      _playerOneReady.value = isReady;
      return;
    }

    if (id == playerTwo?.id) {
      _playerTwoReady.value = isReady;
    }
  }

  void _incrementWinnerPoints(String winnerId) {
    if (winnerId == playerOne.id) {
      _playerOnePoints.value++;
      return;
    }

    if (winnerId == playerTwo?.id) {
      _playerTwoPoints.value++;
    }
  }

  void _resetPlayersReady() {
    _playerOneReady.value = false;
    _playerTwoReady.value = false;
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _setTurn({required String? playerId, required int turnIndex}) {
    _turnPlayerId.value = playerId;
    _turnIndex.value = turnIndex;
  }

  void _setNextTurn(String winnerId) {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    final winnerIndex = currentRoom.players.indexWhere(
      (player) => player.id == winnerId,
    );

    if (winnerIndex == -1) {
      return;
    }

    _setTurn(playerId: winnerId, turnIndex: winnerIndex);
  }

  // ===========================================================================
  // GAME VISIBILITY
  // ===========================================================================

  // bool get showGame {
  //   final currentRoom = room;
  //
  //   if (currentRoom == null) {
  //     return false;
  //   }
  //
  //
  //   return currentRoom.roundStatus == RoundStatus.playing ||
  //       (currentRoom.roundStatus == RoundStatus.result && !amIReady);
  // }

  bool get isMyTurn {
    return _turnPlayerId.value == playerId;
  }

  bool get isGamePlaying {
    return room?.roundStatus == RoundStatus.playing;
  }

  bool get showGame {
    final currentRoom = room;

    if (currentRoom == null) {
      return false;
    }

    if (currentRoom.roundStatus == RoundStatus.playing) {
      return true;
    }

    if (currentRoom.roundStatus == RoundStatus.result) {
      return !amIReady;
    }

    return false;
  }

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

    if (currentRoom == null ||
        !isGamePlaying ||
        _roundResultSubmitted.value ||
        _movePending.value ||
        !isMyTurn ||
        index < 0 ||
        index >= _board.length ||
        _board[index] != null) {
      return;
    }

    _movePending.value = true;

    _musicController.playTouch();

    _roomSocketService.makeMove(
      roomCode: currentRoom.roomCode,
      index: index,
      playerId: playerId,
    );
  }

  // ===========================================================================
  // ROUND
  // ===========================================================================

  // void _prepareNewRound() {
  //
  // }

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
    _roundResultSubmitted.value = true;

    _roundResult.value = response;

    setWinningIndexes(response.winningIndexes.toSet());

    _resetPlayersReady();

    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    if (response.roundStatus != null) {
      _room.value = currentRoom.copyWith(roundStatus: response.roundStatus);
    }

    final winnerId = response.winnerId;

    if (winnerId != null) {
      _incrementWinnerPoints(winnerId);
      _setNextTurn(winnerId);
    } else {
      _setTurn(playerId: null, turnIndex: 0);
    }

    // Final game result is handled separately.
    if (response.gameFinished) {
      _showFinalResult();
      return;
    }

    // Draw
    if (winnerId == null) {
      GameDialogUtils.showGameResult(
        result: GameResult.draw,

        mySymbol: myPlayer.symbol,
        onConfirm: () {
          setReady();
          clearBoard();
        },
      );

      return;
    }

    // Winner / loser
    final winner = currentRoom.players.firstWhere(
      (player) => player.id == winnerId,
    );

    final result = winner.symbol == PlayerSymbol.x
        ? GameResult.xWins
        : GameResult.oWins;

    GameDialogUtils.showGameResult(
      result: result,
      mySymbol: myPlayer.symbol,
      onConfirm: () {
        setReady();
        clearBoard();
      },
    );
  }

  void _submitRoundResult({required List<int> winningIndexes}) {
    final currentRoom = room;

    if (currentRoom == null || _roundResultSubmitted.value) {
      return;
    }

    _roundResultSubmitted.value = true;

    _roomSocketService.submitGameResult(
      roomCode: currentRoom.roomCode,
      playerId: playerId,
      winningIndexes: winningIndexes,
    );
  }

  // ===========================================================================
  // FINAL RESULT
  // ===========================================================================

  void _showFinalResult() {
    try {
      final currentRoom = room;
      final currentPlayerTwo = playerTwo;

      if (currentRoom == null || currentPlayerTwo == null) {
        setInfo('Unable to load game result.');
        return;
      }

      final isDraw = playerOnePoints == playerTwoPoints;

      final winner = isDraw
          ? null
          : playerOnePoints > playerTwoPoints
          ? playerOne
          : currentPlayerTwo;

      final result = ResultModel.completed(
        playerOne: playerOne,
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
  // BOARD
  // ===========================================================================

  void updateBoardValue(int index, PlayerSymbol symbol) {
    if (index < 0 || index >= _board.length || _board[index] != null) {
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
    _board.assignAll(
      List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );

    _winningIndexes.clear();
  }

  // ===========================================================================
  // MOVE RESPONSE
  // ===========================================================================

  void _handleMoveMade(MoveResultResponse response) {
    _movePending.value = false;

    updateBoardValue(response.index, response.symbol);

    _turnPlayerId.value = response.turnPlayerId;
    _turnIndex.value = response.turnIndex;

    final isMyMove = response.playerId == playerId;

    // Opponent's move.
    // Just update the board and wait for the next turn.
    if (!isMyMove) {
      return;
    }

    _handleMyMoveResult();
  }

  void _handleMyMoveResult() {
    if (_roundResultSubmitted.value) {
      return;
    }

    final result = GameLogicUtils.checkWinner(_board);

    if (result == GameResult.inProgress) {
      return;
    }

    // Draw.
    if (result == GameResult.draw) {
      GameDialogUtils.showGameResult(
        result: GameResult.draw,
        mySymbol: myPlayer.symbol,
        onConfirm: () {
          setReady();
          clearBoard();
        },
      );
      return;
    }

    // I won.
    final winningIndexes = GameLogicUtils.getWinningIndexes(_board).toList();

    setWinningIndexes(winningIndexes.toSet());

    _submitRoundResult(winningIndexes: winningIndexes);
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    _roundAnimationTimer?.cancel();
    _roundAnimationTimer = null;

    _roomSocketService.offPlayerJoined();
    _roomSocketService.offPlayerLeft();
    _roomSocketService.offReadyUpdated();
    _roomSocketService.offRoundStarted();
    _roomSocketService.offRoomClosed();
    _roomSocketService.offGameDismissed();
    _roomSocketService.offMoveMade();
    _roomSocketService.offRoundResult();
    _roomSocketService.offRoomError();

    _roomSocketService.disconnect();

    super.onClose();
  }

  bool get waitingForNextRound {
    return (room?.currentRound ?? 0) > 0;
  }

  // ===========================================================================
  // QUIT GAME
  // ===========================================================================

  void quitGame() {
    final currentRoom = room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.quitGame(
      roomCode: currentRoom.roomCode,
      playerId: playerId,
    );
  }
}
