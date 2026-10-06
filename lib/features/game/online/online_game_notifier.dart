import 'package:tictac_duel/lib.dart';

final onlineGameProvider =
    NotifierProvider.family<OnlineGameNotifier, OnlineGameState, String>(
      OnlineGameNotifier.new,
    );

class OnlineGameNotifier extends Notifier<OnlineGameState> {
  OnlineGameNotifier(this.roomCode);

  final String roomCode;

  late final RoomSocketService _roomSocketService;
  late final AudioNotifier _audioNotifier;
  late final PlayerNotifier _playerNotifier;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  Timer? _roundAnimationTimer;
  Timer? _reactionTimer;
  Timer? _resultTimer;

  bool _disposed = false;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  OnlineGameState build() {
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _audioNotifier = ref.read(audioProvider.notifier);
    _playerNotifier = ref.read(playerProvider.notifier);
    _navigation = ref.read(appNavigationProvider);
    _gameDialog = ref.read(gameDialogProvider);

    ref.onDispose(_dispose);

    final initialState = OnlineGameState(
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );

    Future.microtask(_initialize);

    return initialState;
  }

  String get playerId => _playerNotifier.playerId;

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  PlayerModel get playerOne {
    final currentRoom = state.room;

    if (currentRoom == null || currentRoom.players.isEmpty) {
      throw StateError('Room is not initialized');
    }

    return currentRoom.players.first;
  }

  PlayerModel? get playerTwo {
    final currentRoom = state.room;

    if (currentRoom == null || currentRoom.players.length < 2) {
      return null;
    }

    return currentRoom.players[1];
  }

  PlayerModel get myPlayer {
    final currentRoom = state.room;

    if (currentRoom == null) {
      throw StateError('Room is not initialized');
    }

    return currentRoom.players.firstWhere(
      (player) => player.id == playerId,
      orElse: () => throw StateError('Current player not found in room'),
    );
  }

  PlayerModel? get currentPlayer {
    final currentRoom = state.room;

    if (currentRoom == null ||
        state.turnIndex < 0 ||
        state.turnIndex >= currentRoom.players.length) {
      return null;
    }

    return currentRoom.players[state.turnIndex];
  }

  bool get amIReady {
    final first = playerOne;
    final second = playerTwo;
    final current = myPlayer;

    if (current.id == first.id) {
      return state.playerOneReady;
    }

    return second?.id == current.id && state.playerTwoReady;
  }

  // ===========================================================================
  // GAME STATE
  // ===========================================================================

  bool get isMyTurn =>
      state.turnPlayerId != null && state.turnPlayerId == playerId;

  bool get isGamePlaying => state.room?.roundStatus == RoundStatus.playing;

  bool get isRoundAnimationPlaying => state.showRoundAnimation;

  bool get showGame {
    final currentRoom = state.room;

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

  bool get isWaitingForPlayers {
    final currentRoom = state.room;

    if (currentRoom == null) {
      return false;
    }

    return currentRoom.roundStatus == RoundStatus.waiting &&
        currentRoom.players.length < GameConstants.maxPlayers;
  }

  bool get waitingForNextRound => (state.room?.currentRound ?? 0) > 0;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);

    try {
      _listenToSocketEvents();

      await _roomSocketService.connect(
        roomCode: roomCode,
        playerId: playerId,
        onConnected: _handleRoomConnected,
      );
    } catch (error, stackTrace) {
      if (_disposed) {
        return;
      }

      setError(error.toString());

      state = state.copyWith(isLoading: false);

      LoggerUtils.error('OnlineGameNotifier._initialize', error, stackTrace);
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
    _roomSocketService.onReactionReceived(_handleReactionReceived);
    _roomSocketService.onRoomError(_handleRoomError);
  }

  void _handleRoomConnected(RoomConnectedResponse response) {
    if (_disposed) {
      return;
    }

    state = state.copyWith(
      room: response.room,
      playerOnePoints: response.playerOnePoints,
      playerTwoPoints: response.playerTwoPoints,
      playerOneReady: response.playerOneReady,
      playerTwoReady: response.playerTwoReady,
      turnPlayerId: response.turnPlayerId,
      turnIndex: response.turnIndex,
      isLoading: false,
      clearError: true,
      clearInfo: true,
    );
  }

  void _handlePlayerJoined(PlayerJoinedResponse response) {
    _setPlayer(response.player);
    _setPlayerPoints(response.player.id, response.points);
    _setPlayerReady(response.player.id, response.isReady);
  }

  void _handlePlayerLeft(String playerId) {
    final currentRoom = state.room;

    if (currentRoom == null) {
      return;
    }

    final isPlayerOne = currentRoom.playerOne.id == playerId;

    _removePlayer(playerId);

    if (isPlayerOne) {
      state = state.copyWith(playerOnePoints: 0, playerOneReady: false);
    } else {
      state = state.copyWith(playerTwoPoints: 0, playerTwoReady: false);
    }
  }

  void _handleReadyUpdated(ReadyUpdatedResponse response) {
    final first = state.room?.playerOne;
    final second = state.room?.playerTwo;

    if (first?.id == response.playerId) {
      state = state.copyWith(playerOneReady: response.isReady);
      return;
    }

    if (second?.id == response.playerId) {
      state = state.copyWith(playerTwoReady: response.isReady);
    }
  }

  void _handleRoundStarted(RoundStartedResponse response) {
    _setRoom(response.room);

    state = state.copyWith(
      playerOneReady: response.playerOneReady,
      playerTwoReady: response.playerTwoReady,
      turnPlayerId: response.turnPlayerId,
      turnIndex: response.turnIndex,
      movePending: false,
      roundResultSubmitted: false,
      clearRoundResult: true,
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
      winningIndexes: const {},
    );
  }

  void _handleRoomError(String message) {
    state = state.copyWith(roundResultSubmitted: false, movePending: false);

    setError(message);
  }

  void _handleRoomClosed(String reason) {
    _gameDialog.showRoomClosed(reason: reason);
  }

  void _handleGameDismissed(GameDismissedResponse response) {
    final currentRoom = state.room;
    final currentPlayerTwo = playerTwo;

    if (currentRoom == null || currentPlayerTwo == null) {
      setInfo('Unable to load game result.');
      return;
    }

    final winner = currentRoom.players
        .where((player) => player.id == response.winnerPlayerId)
        .firstOrNull;

    if (winner == null) {
      setInfo('Unable to determine game winner.');
      return;
    }

    final result = ResultModel.dismissed(
      playerOne: playerOne,
      playerTwo: currentPlayerTwo,
      playerOnePoints: state.playerOnePoints,
      playerTwoPoints: state.playerTwoPoints,
      currentRound: currentRoom.currentRound,
      maxRounds: currentRoom.maxRounds,
      isOnline: true,
      gameWinner: winner,
      dismissReason: response.reason,
      theme: currentRoom.theme,
    );

    _navigation.replaceResult(result);
  }

  // ===========================================================================
  // ROOM STATE
  // ===========================================================================

  void _setRoom(RoomModel value) {
    final previousRoom = state.room;
    final previousRound = previousRoom?.currentRound;

    state = state.copyWith(room: value);

    final roundChanged =
        previousRound != null && previousRound != value.currentRound;

    final roundStarted = value.roundStatus == RoundStatus.playing;

    if (roundChanged && roundStarted) {
      _showRoundAnimationFor(value);
    }
  }

  void _setPlayer(PlayerModel player) {
    final currentRoom = state.room;

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

    state = state.copyWith(room: currentRoom.copyWith(players: players));
  }

  void _removePlayer(String playerId) {
    final currentRoom = state.room;

    if (currentRoom == null) {
      return;
    }

    state = state.copyWith(
      room: currentRoom.copyWith(
        players: currentRoom.players
            .where((player) => player.id != playerId)
            .toList(),
      ),
    );
  }

  // ===========================================================================
  // PLAYER STATE
  // ===========================================================================

  void _setPlayerPoints(String id, int points) {
    final first = state.room?.playerOne;
    final second = state.room?.playerTwo;

    if (id == first?.id) {
      state = state.copyWith(playerOnePoints: points);
      return;
    }

    if (id == second?.id) {
      state = state.copyWith(playerTwoPoints: points);
    }
  }

  void _setPlayerReady(String id, bool isReady) {
    final first = state.room?.playerOne;
    final second = state.room?.playerTwo;

    if (id == first?.id) {
      state = state.copyWith(playerOneReady: isReady);
      return;
    }

    if (id == second?.id) {
      state = state.copyWith(playerTwoReady: isReady);
    }
  }

  void _incrementWinnerPoints(String winnerId) {
    final first = state.room?.playerOne;
    final second = state.room?.playerTwo;

    if (winnerId == first?.id) {
      state = state.copyWith(playerOnePoints: state.playerOnePoints + 1);
      return;
    }

    if (winnerId == second?.id) {
      state = state.copyWith(playerTwoPoints: state.playerTwoPoints + 1);
    }
  }

  void _resetPlayersReady() {
    state = state.copyWith(playerOneReady: false, playerTwoReady: false);
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _setTurn({required String? playerId, required int turnIndex}) {
    state = state.copyWith(turnPlayerId: playerId, turnIndex: turnIndex);
  }

  // ===========================================================================
  // GAME
  // ===========================================================================

  void startGame() {
    final currentRoom = state.room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.startGame(roomCode: currentRoom.roomCode);
  }

  // ===========================================================================
  // READY
  // ===========================================================================

  void setReady() {
    final currentRoom = state.room;

    if (currentRoom == null) {
      return;
    }

    _roomSocketService.setReady(roomCode: currentRoom.roomCode);
  }

  // ===========================================================================
  // MOVES
  // ===========================================================================

  void makeMove(int index) {
    final currentRoom = state.room;

    if (currentRoom == null ||
        !isGamePlaying ||
        isRoundAnimationPlaying ||
        state.roundResultSubmitted ||
        state.movePending ||
        !isMyTurn ||
        index < 0 ||
        index >= state.board.length ||
        state.board[index] != null) {
      return;
    }

    state = state.copyWith(movePending: true);

    _audioNotifier.playTouch();

    _roomSocketService.makeMove(
      roomCode: currentRoom.roomCode,
      index: index,
      playerId: playerId,
    );
  }

  // ===========================================================================
  // ROUND
  // ===========================================================================

  void _showRoundAnimationFor(RoomModel currentRoom) {
    _roundAnimationTimer?.cancel();

    _audioNotifier.playRoundStart();

    state = state.copyWith(
      animatedRound: currentRoom.currentRound,
      showRoundAnimation: true,
    );

    _roundAnimationTimer = Timer(const Duration(milliseconds: 900), () {
      if (_disposed) {
        return;
      }

      state = state.copyWith(showRoundAnimation: false);

      _roundAnimationTimer = null;
    });
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void _handleRoundResult(RoundResultResponse response) {
    if (_disposed || state.roundResult != null) {
      return;
    }

    state = state.copyWith(
      roundResult: response,
      roundResultSubmitted: true,
      winningIndexes: response.winningIndexes.toSet(),
    );

    _resetPlayersReady();

    final currentRoom = state.room;

    if (currentRoom == null) {
      return;
    }

    if (response.roundStatus != null) {
      state = state.copyWith(
        room: currentRoom.copyWith(roundStatus: response.roundStatus),
      );
    }

    _setTurn(playerId: response.turnPlayerId, turnIndex: response.turnIndex);

    final winnerId = response.winnerId;

    if (winnerId != null) {
      _incrementWinnerPoints(winnerId);
    }

    if (response.gameFinished) {
      _showRoundResultAfterDelay(_showFinalResult);
      return;
    }

    if (winnerId == null) {
      _showRoundResultAfterDelay(() {
        _gameDialog.showGameResult(
          result: GameResult.draw,
          mySymbol: myPlayer.symbol,
          onConfirm: () {
            setReady();
            clearBoard();
          },
        );
      });

      return;
    }

    final winner = currentRoom.players.firstWhere(
      (player) => player.id == winnerId,
    );

    final result = winner.symbol == PlayerSymbol.x
        ? GameResult.xWins
        : GameResult.oWins;

    _showRoundResultAfterDelay(() {
      _gameDialog.showGameResult(
        result: result,
        mySymbol: myPlayer.symbol,
        onConfirm: () {
          setReady();
          clearBoard();
        },
      );
    });
  }

  void _showRoundResultAfterDelay(VoidCallback callback) {
    _resultTimer?.cancel();

    _resultTimer = Timer(GameConstants.resultDelay, () {
      if (_disposed) {
        return;
      }

      callback();
      _resultTimer = null;
    });
  }

  void _submitRoundResult({required List<int> winningIndexes}) {
    final currentRoom = state.room;

    if (currentRoom == null || state.roundResultSubmitted) {
      return;
    }

    state = state.copyWith(roundResultSubmitted: true);

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
      final currentRoom = state.room;
      final currentPlayerTwo = playerTwo;

      if (currentRoom == null || currentPlayerTwo == null) {
        setInfo('Unable to load game result.');
        return;
      }

      final isDraw = state.playerOnePoints == state.playerTwoPoints;

      final winner = isDraw
          ? null
          : state.playerOnePoints > state.playerTwoPoints
          ? playerOne
          : currentPlayerTwo;

      final result = ResultModel.completed(
        playerOne: playerOne,
        playerTwo: currentPlayerTwo,
        playerOnePoints: state.playerOnePoints,
        playerTwoPoints: state.playerTwoPoints,
        currentRound: currentRoom.currentRound,
        maxRounds: currentRoom.maxRounds,
        gameWinner: winner,
        hasWon: winner?.id == playerId,
        isDraw: isDraw,
        showConfetti: winner?.id == playerId,
        isOnline: true,
        theme: currentRoom.theme,
      );

      _navigation.replaceResult(result);
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'OnlineGameNotifier._showFinalResult',
        error,
        stackTrace,
      );

      setInfo('Unable to load game result.');
    }
  }

  // ===========================================================================
  // MESSAGES
  // ===========================================================================

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearInfo() {
    state = state.copyWith(clearInfo: true);
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);

    PopupUtils.showError('Room error: $message');

    LoggerUtils.error('Room error: $message');

    clearError();
  }

  void setInfo(String message) {
    state = state.copyWith(infoMessage: message);
  }

  // ===========================================================================
  // BOARD
  // ===========================================================================

  void updateBoardValue(int index, PlayerSymbol symbol) {
    if (index < 0 ||
        index >= state.board.length ||
        state.board[index] != null) {
      return;
    }

    final board = [...state.board];
    board[index] = symbol;

    state = state.copyWith(board: board);
  }

  void setBoard(List<PlayerSymbol?> values) {
    state = state.copyWith(board: [...values]);
  }

  void setWinningIndexes(Set<int> indexes) {
    state = state.copyWith(winningIndexes: {...indexes});
  }

  void clearBoard() {
    state = state.copyWith(
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
      winningIndexes: const {},
    );
  }

  // ===========================================================================
  // MOVE RESPONSE
  // ===========================================================================

  void _handleMoveMade(MoveResultResponse response) {
    state = state.copyWith(
      movePending: false,
      turnPlayerId: response.turnPlayerId,
      turnIndex: response.turnIndex,
    );

    updateBoardValue(response.index, response.symbol);

    _handleMoveResult(response);
  }

  void _handleMoveResult(MoveResultResponse response) {
    if (state.roundResultSubmitted) {
      return;
    }

    final result = GameLogicUtils.checkWinner(state.board);

    if (result == GameResult.inProgress) {
      return;
    }

    if (result == GameResult.draw) {
      if (response.playerId == playerId) {
        _submitRoundResult(winningIndexes: const []);
      }

      return;
    }

    final winningIndexes = GameLogicUtils.getWinningIndexes(state.board)
        .toList();

    setWinningIndexes(winningIndexes.toSet());

    if (response.playerId == playerId) {
      _submitRoundResult(winningIndexes: winningIndexes);
    }
  }

  // ===========================================================================
  // REACTIONS
  // ===========================================================================

  void sendReaction(GameReaction reaction) {
    final currentRoom = state.room;
    final currentPlayerTwo = playerTwo;

    if (currentRoom == null || currentPlayerTwo == null) {
      return;
    }

    final targetPlayerId = playerId == playerOne.id
        ? currentPlayerTwo.id
        : playerOne.id;

    _roomSocketService.sendReaction(
      roomCode: currentRoom.roomCode,
      senderId: playerId,
      targetPlayerId: targetPlayerId,
      reaction: reaction,
    );
  }

  void _handleReactionReceived(GameReactionEvent event) {
    _reactionTimer?.cancel();

    state = state.copyWith(reactionEvent: event);

    _audioNotifier.playSwoosh();

    _reactionTimer = Timer(GameConstants.reactionTotalDuration, () {
      if (_disposed) {
        return;
      }

      state = state.copyWith(clearReactionEvent: true);

      _reactionTimer = null;
    });
  }

  // ===========================================================================
  // QUIT GAME
  // ===========================================================================

  void quitGame() {
    try {
      final currentRoom = state.room;

      if (currentRoom == null) {
        return;
      }

      _roomSocketService.quitGame(
        roomCode: currentRoom.roomCode,
        playerId: playerId,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('OnlineGameNotifier.quitGame', error, stackTrace);
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  void _dispose() {
    _disposed = true;

    _roundAnimationTimer?.cancel();
    _reactionTimer?.cancel();
    _resultTimer?.cancel();

    _roundAnimationTimer = null;
    _reactionTimer = null;
    _resultTimer = null;

    _roomSocketService.offPlayerJoined();
    _roomSocketService.offPlayerLeft();
    _roomSocketService.offReadyUpdated();
    _roomSocketService.offRoundStarted();
    _roomSocketService.offRoomClosed();
    _roomSocketService.offGameDismissed();
    _roomSocketService.offMoveMade();
    _roomSocketService.offRoundResult();
    _roomSocketService.offSendReaction();
    _roomSocketService.offReactionReceived();
    _roomSocketService.offRoomError();

    _roomSocketService.disconnect();
  }
}
