import 'package:tictac_duel/lib.dart';

final onlineGameProvider = NotifierProvider.autoDispose
    .family<OnlineGameNotifier, OnlineGameState, RoomModel>(
      OnlineGameNotifier.new,
    );

class OnlineGameNotifier extends Notifier<OnlineGameState> {
  OnlineGameNotifier(this.room);

  final RoomModel room;

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

    return OnlineGameState.initial(room);
  }

  String get playerId => _roomSocketService.socketId;

  PlayerModel get host => state.room.host;

  PlayerModel? get guest => state.room.guest;

  PlayerModel get myPlayer {
    final currentRoom = state.room;

    if (currentRoom.host.id == playerId) {
      return currentRoom.host;
    }

    final currentGuest = currentRoom.guest;

    if (currentGuest?.id == playerId) {
      return currentGuest!;
    }

    throw StateError('Current player not found in room');
  }

  String? get turnPlayerId => state.room.turnPlayerId;

  bool get isMyTurn => state.room.turnPlayerId == playerId;

  bool get isGamePlaying => state.room.status == RoomStatus.playing;

  bool get isRoundAnimationPlaying => state.showRoundAnimation;

  bool get amIReady {
    final currentPlayer = myPlayer;

    if (currentPlayer.id == state.room.host.id) {
      return state.room.hostReady;
    }

    return currentPlayer.id == state.room.guest?.id && state.room.guestReady;
  }

  bool get showGame {
    final status = state.room.status;

    if (status == RoomStatus.playing) {
      return true;
    }

    if (status == RoomStatus.result) {
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

  void _handlePlayerJoined(PlayerJoinedResponse response) {
    state = state.copyWith(
      room: state.room.copyWith(
        guest: response.player,
        guestPoints: response.points,
        guestReady: response.isReady,
      ),
    );
  }

  void _handlePlayerLeft(String playerId) {
    if (state.room.guest?.id != playerId) {
      return;
    }
    state = state.copyWith(
      room: state.room.copyWith(
        clearGuest: true,
        guestPoints: 0,
        guestReady: false,
      ),
    );
  }

  void _handleReadyUpdated(ReadyUpdatedResponse response) {
    if (response.playerId == state.room.host.id) {
      state = state.copyWith(
        room: state.room.copyWith(hostReady: response.isReady),
      );
      return;
    }

    if (response.playerId == state.room.guest?.id) {
      state = state.copyWith(
        room: state.room.copyWith(guestReady: response.isReady),
      );
    }
  }

  void _handleRoundStarted(RoundStartedResponse response) {
    final room = state.room.copyWith(
      currentRound: response.currentRound,
      status: response.status,
      hostReady: response.hostReady,
      guestReady: response.guestReady,
      turnPlayerId: response.turnPlayerId,
      clearNextTurnPlayerId: true,
    );

    state = state.copyWith(
      room: room,
      movePending: false,
      roundResultSubmitted: false,
      clearRoundResult: true,
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
      winningIndexes: const {},
    );

    _showRoundAnimationFor(room);
  }

  void _handleRoomError(String message) {
    state = state.copyWith(roundResultSubmitted: false, movePending: false);

    setError(message);
  }

  void _handleRoomClosed(GameDismissReason reason) {
    _gameDialog.showRoomClosed(reason: reason);
  }

  void _handleGameDismissed(GameDismissedResponse response) {
    final currentRoom = state.room;
    final winner = response.winnerPlayerId == currentRoom.host.id
        ? currentRoom.host
        : currentRoom.guest;

    if (winner == null) {
      setInfo('Unable to determine game winner.');
      return;
    }

    final result = ResultModel.dismissed(
      host: currentRoom.host,
      guest: currentRoom.guest!,
      hostPoints: currentRoom.hostPoints,
      guestPoints: currentRoom.guestPoints,
      currentRound: currentRoom.currentRound,
      maxRounds: currentRoom.maxRounds,
      isOnline: true,
      gameWinner: winner,
      dismissReason: response.reason,
      theme: currentRoom.theme,
    );

    _navigation.replaceResult(result);
  }

  void _incrementWinnerPoints(String winnerId) {
    final currentRoom = state.room;

    if (winnerId == currentRoom.host.id) {
      state = state.copyWith(
        room: currentRoom.copyWith(hostPoints: currentRoom.hostPoints + 1),
      );
      return;
    }

    if (winnerId == currentRoom.guest?.id) {
      state = state.copyWith(
        room: currentRoom.copyWith(guestPoints: currentRoom.guestPoints + 1),
      );
    }
  }

  void _resetPlayersReady() {
    state = state.copyWith(
      room: state.room.copyWith(hostReady: false, guestReady: false),
    );
  }

  void _setTurn(String? playerId) {
    state = state.copyWith(room: state.room.copyWith(turnPlayerId: playerId));
  }

  void startGame() => _roomSocketService.startGame();

  void setReady() => _roomSocketService.setReady();

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

    _roomSocketService.makeMove(index);
  }

  void _showRoundAnimationFor(RoomModel value) {
    _roundAnimationTimer?.cancel();
    _audioNotifier.playRoundStart();
    state = state.copyWith(showRoundAnimation: true);
    _roundAnimationTimer = Timer(GameConstants.roundAnimationDuration, () {
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

    _setTurn(response.turnPlayerId);

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

  void _submitRoundResult(List<int>? winningIndexes) {
    if (state.roundResultSubmitted) {
      return;
    }

    state = state.copyWith(roundResultSubmitted: true);

    _roomSocketService.submitGameResult(winningIndexes);
  }

  void _showFinalResult() {
    try {
      final currentGuest = guest;

      if (currentGuest == null) {
        setInfo('Unable to load game result.');
        return;
      }

      final hostPoints = state.room.hostPoints;
      final guestPoints = state.room.guestPoints;

      final isDraw = hostPoints == guestPoints;

      final winner = isDraw
          ? null
          : hostPoints > guestPoints
          ? host
          : currentGuest;

      final result = ResultModel.completed(
        host: host,
        guest: currentGuest,
        hostPoints: hostPoints,
        guestPoints: guestPoints,
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
    final room = state.room;

    final player = room.host.id == response.playerId
        ? room.host
        : room.guest?.id == response.playerId
        ? room.guest
        : null;

    if (player == null) {
      setInfo('Unable to identify the player who made the move.');
      return;
    }

    state = state.copyWith(
      movePending: false,
      room: room.copyWith(turnPlayerId: response.turnPlayerId),
    );

    updateBoardValue(response.index, player.symbol);

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
        _submitRoundResult(null);
      }

      return;
    }

    final winningIndexes = GameLogicUtils.getWinningIndexes(state.board)
        .toList();

    setWinningIndexes(winningIndexes.toSet());

    if (response.playerId == playerId) {
      _submitRoundResult(winningIndexes);
    }
  }

  void sendReaction(GameReaction reaction) =>
      _roomSocketService.sendReaction(reaction);

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

  PlayerModel? _findPlayer(String id) {
    if (state.room.host.id == id) {
      return state.room.host;
    }

    if (state.room.guest?.id == id) {
      return state.room.guest;
    }

    return null;
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

  void quitGame() {
    try {
      _roomSocketService.quitGame();
    } catch (error, stackTrace) {
      LoggerUtils.error('OnlineGameNotifier.quitGame', error, stackTrace);
    }
  }
}
