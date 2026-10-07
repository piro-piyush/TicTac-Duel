import 'package:tictac_duel/lib.dart';

final onlineGameProvider =
    NotifierProvider.family<OnlineGameNotifier, OnlineGameState, Room>(
      OnlineGameNotifier.new,
    );

class OnlineGameNotifier extends Notifier<OnlineGameState> {
  OnlineGameNotifier(this.room);

  final Room room;

  late final RoomSocketService _roomSocketService;
  late final AudioNotifier _audioNotifier;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  Timer? _roundAnimationTimer;
  Timer? _reactionTimer;
  Timer? _resultTimer;

  bool _disposed = false;

  @override
  OnlineGameState build() {
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _audioNotifier = ref.read(audioProvider.notifier);
    _navigation = ref.read(appNavigationProvider);
    _gameDialog = ref.read(gameDialogProvider);

    ref.onDispose(_dispose);

    Future.microtask(_initialize);

    return OnlineGameState(
      room: room,
      turnPlayerId: room.turnPlayerId,
      turnIndex: _getTurnIndex(room),
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );
  }

  String get playerId => _roomSocketService.socketId;

  PlayerModel get playerOne => state.room.host;

  PlayerModel? get playerTwo => state.room.guest;

  PlayerModel get myPlayer {
    final currentRoom = state.room;

    if (currentRoom.host.id == playerId) {
      return currentRoom.host;
    }

    final guest = currentRoom.guest;

    if (guest != null && guest.id == playerId) {
      return guest;
    }

    throw StateError('Current player not found in room');
  }

  // PlayerModel? get currentPlayer {
  //   final turnPlayerId = state.turnPlayerId;
  //
  //   if (turnPlayerId == state.room.host.id) {
  //     return state.room.host;
  //   }
  //
  //   final guest = state.room.guest;
  //
  //   if (guest?.id == turnPlayerId) {
  //     return guest!;
  //   }
  //
  //  return null;
  // }

  String? get turnPlayerId => state.turnPlayerId;

  bool get amIReady {
    final current = myPlayer;

    if (current.id == playerOne.id) {
      return state.playerOneReady;
    }

    return current.id == playerTwo?.id && state.playerTwoReady;
  }

  bool get isMyTurn =>
      state.turnPlayerId != null && state.turnPlayerId == playerId;

  bool get isGamePlaying => state.room.status == RoomStatus.playing;

  bool get isRoundAnimationPlaying => state.showRoundAnimation;

  bool get showGame {
    final currentRoom = state.room;

    if (currentRoom.status == RoomStatus.playing) {
      return true;
    }

    if (currentRoom.status == RoomStatus.result) {
      return !amIReady;
    }

    return false;
  }

  bool get isWaitingForPlayers =>
      state.room.status == RoomStatus.waiting && state.room.guest == null;

  bool get waitingForNextRound => state.room.currentRound > 0;

  Future<void> _initialize() async {
    state = state.copyWith(clearError: true, clearInfo: true);

    try {
      _listenToSocketEvents();
    } catch (error, stackTrace) {
      if (_disposed) {
        return;
      }

      setError(error.toString());

      LoggerUtils.error('OnlineGameNotifier._initialize', error, stackTrace);
    }
  }

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

  void _handlePlayerJoined(PlayerModel response) {
    final room = state.room;
    state = state.copyWith(room: room.copyWith(guest: response));
  }

  void _handlePlayerLeft(String playerId) {
    if (state.room.guest?.id != playerId) {
      return;
    }

    state = state.copyWith(
      room: state.room.copyWith(clearGuest: true),
      playerTwoPoints: 0,
      playerTwoReady: false,
    );
  }

  void _handleReadyUpdated(ReadyUpdatedResponse response) {
    if (state.room.host.id == response.playerId) {
      state = state.copyWith(playerOneReady: response.isReady);
      return;
    }

    if (state.room.guest?.id == response.playerId) {
      state = state.copyWith(playerTwoReady: response.isReady);
    }
  }

  void _handleRoundStarted(RoundStartedResponse response) {
    state = state.copyWith(
      room: state.room.copyWith(
        currentRound: response.currentRound,
        status: response.status,
        turnPlayerId: response.turnPlayerId,
      ),
      playerOneReady: false,
      playerTwoReady: false,
      turnPlayerId: response.turnPlayerId,
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
    final currentPlayerTwo = playerTwo;

    if (currentPlayerTwo == null) {
      setInfo('Unable to load game result.');
      return;
    }

    final winner = _findPlayer(response.winnerPlayerId);

    if (winner == null) {
      setInfo('Unable to determine game winner.');
      return;
    }

    final result = ResultModel.dismissed(
      playerOne: playerOne,
      playerTwo: currentPlayerTwo,
      playerOnePoints: state.playerOnePoints,
      playerTwoPoints: state.playerTwoPoints,
      currentRound: state.room.currentRound,
      maxRounds: state.room.maxRounds,
      isOnline: true,
      gameWinner: winner,
      dismissReason: response.reason,
      theme: state.room.theme,
    );

    _navigation.replaceResult(result);
  }

  void _setRoom(Room value) {
    final previousRound = state.room.currentRound;

    state = state.copyWith(room: value);

    final roundChanged = previousRound != value.currentRound;
    final roundStarted = value.status == RoomStatus.playing;

    if (roundChanged && roundStarted) {
      _showRoundAnimationFor(value);
    }
  }

  void _setPlayer(PlayerModel player) {
    final currentRoom = state.room;

    if (currentRoom.host.id == player.id) {
      state = state.copyWith(room: currentRoom.copyWith(host: player));
      return;
    }

    if (currentRoom.guest?.id == player.id) {
      state = state.copyWith(room: currentRoom.copyWith(guest: player));
      return;
    }

    if (currentRoom.guest == null) {
      state = state.copyWith(room: currentRoom.copyWith(guest: player));
    }
  }

  void _removePlayer(String playerId) {
    final currentRoom = state.room;

    if (currentRoom.host.id == playerId) {
      state = state.copyWith(room: currentRoom.copyWith(guest: null));
      return;
    }

    if (currentRoom.guest?.id == playerId) {
      state = state.copyWith(room: currentRoom.copyWith(guest: null));
    }
  }

  void _setPlayerPoints(String id, int points) {
    if (id == state.room.host.id) {
      state = state.copyWith(playerOnePoints: points);
      return;
    }

    if (id == state.room.guest?.id) {
      state = state.copyWith(playerTwoPoints: points);
    }
  }

  void _setPlayerReady(String id, bool isReady) {
    if (id == state.room.host.id) {
      state = state.copyWith(playerOneReady: isReady);
      return;
    }

    if (id == state.room.guest?.id) {
      state = state.copyWith(playerTwoReady: isReady);
    }
  }

  void _incrementWinnerPoints(String winnerId) {
    if (winnerId == state.room.host.id) {
      state = state.copyWith(playerOnePoints: state.playerOnePoints + 1);
      return;
    }

    if (winnerId == state.room.guest?.id) {
      state = state.copyWith(playerTwoPoints: state.playerTwoPoints + 1);
    }
  }

  void _resetPlayersReady() {
    state = state.copyWith(playerOneReady: false, playerTwoReady: false);
  }

  void _setTurn({required String? playerId, required int turnIndex}) {
    state = state.copyWith(turnPlayerId: playerId, turnIndex: turnIndex);
  }

  void startGame() {
    _roomSocketService.startGame(roomCode: state.room.roomCode);
  }

  void setReady() {
    _roomSocketService.setReady(roomCode: state.room.roomCode);
  }

  void makeMove(int index) {
    if (!isGamePlaying ||
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

    _roomSocketService.makeMove(roomCode: state.room.roomCode, index: index);
  }

  void _showRoundAnimationFor(Room value) {
    _roundAnimationTimer?.cancel();

    _audioNotifier.playRoundStart();

    state = state.copyWith(
      animatedRound: value.currentRound,
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

    if (response.status != null) {
      state = state.copyWith(
        room: state.room.copyWith(status: response.status),
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

    final winner = _findPlayer(winnerId);

    if (winner == null) {
      return;
    }

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
    if (state.roundResultSubmitted) {
      return;
    }

    state = state.copyWith(roundResultSubmitted: true);

    _roomSocketService.submitGameResult(
      roomCode: state.room.roomCode,
      winningIndexes: winningIndexes,
    );
  }

  void _showFinalResult() {
    try {
      final currentPlayerTwo = playerTwo;

      if (currentPlayerTwo == null) {
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
        currentRound: state.room.currentRound,
        maxRounds: state.room.maxRounds,
        gameWinner: winner,
        hasWon: winner?.id == playerId,
        isDraw: isDraw,
        showConfetti: winner?.id == playerId,
        isOnline: true,
        theme: state.room.theme,
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

  void sendReaction(GameReaction reaction) {
    if (playerTwo == null) {
      return;
    }

    _roomSocketService.sendReaction(
      roomCode: state.room.roomCode,
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

  void quitGame() {
    try {
      _roomSocketService.quitGame(roomCode: state.room.roomCode);
    } catch (error, stackTrace) {
      LoggerUtils.error('OnlineGameNotifier.quitGame', error, stackTrace);
    }
  }

  PlayerModel? _findPlayer(String id) {
    if (state.room.host.id == id) {
      return state.room.host;
    }

    if (state.room.guest?.id == id) {
      return state.room.guest;
    }

    return null;
  }

  int _getTurnIndex(Room value) {
    final turnPlayerId = value.turnPlayerId;

    if (turnPlayerId == null) {
      return 0;
    }

    if (value.host.id == turnPlayerId) {
      return 0;
    }

    if (value.guest?.id == turnPlayerId) {
      return 1;
    }

    return 0;
  }

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
    _roomSocketService.offReactionReceived();
    _roomSocketService.offRoomError();

    _roomSocketService.disconnect();
  }
}
