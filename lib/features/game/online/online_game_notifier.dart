import 'package:share_plus/share_plus.dart';
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

  String? get playerId => _roomSocketService.socketId;

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
    state = state.copyWith(clearError: true);

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
    final room = state.room;
    state = state.copyWith(
      room: room.copyWith(
        hostReady: response.playerId == room.host.id
            ? response.isReady
            : room.hostReady,
        guestReady: response.playerId == room.guest?.id
            ? response.isReady
            : room.guestReady,
      ),
    );
  }

  void _handleRoundStarted(RoundStartedResponse response) {
    state = state.copyWith(
      room: state.room.copyWith(
        currentRound: response.currentRound,
        status: response.status,
        hostReady: response.hostReady,
        guestReady: response.guestReady,
        turnPlayerId: response.turnPlayerId,
      ),
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
      winningIndexes: const {},
    );

    _showRoundAnimationFor();
  }

  void _handleRoomError(String message) {
    setError(message);
  }

  void _handleRoomClosed(GameDismissReason reason) =>
      _gameDialog.showRoomClosed(reason: reason);

  void _handleGameDismissed(GameDismissedResponse response) {
    final currentRoom = state.room;
    final result = ResultModel.dismissed(
      host: currentRoom.host,
      guest: currentRoom.guest!,
      hostPoints: currentRoom.hostPoints,
      guestPoints: currentRoom.guestPoints,
      currentRound: currentRoom.currentRound,
      maxRounds: currentRoom.maxRounds,
      isOnline: true,
      gameWinner: response.winnerPlayerId == currentRoom.guest!.id
          ? guest!
          : host,
      dismissReason: response.reason,
      theme: currentRoom.theme,
    );
    _navigation.replaceResult(result);
  }

  void startGame() => _roomSocketService.startGame();

  void setReady() => _roomSocketService.setReady();

  void makeMove(int index) {
    if (!isGamePlaying ||
        isRoundAnimationPlaying ||
        !isMyTurn ||
        index < 0 ||
        index >= state.board.length ||
        state.board[index] != null) {
      return;
    }

    _audioNotifier.playTouch();

    _roomSocketService.makeMove(index);
  }

  void _showRoundAnimationFor() {
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
    if (_disposed) {
      return;
    }

    final room = state.room;
    final winnerId = response.winnerId;

    state = state.copyWith(
      winningIndexes: response.winningIndexes.toSet(),
      room: room.copyWith(
        status: response.status,
        clearTurnPlayerId: true,
        hostReady: false,
        guestReady: false,
        hostPoints: winnerId == room.host.id
            ? room.hostPoints + 1
            : room.hostPoints,
        guestPoints: winnerId == room.guest?.id
            ? room.guestPoints + 1
            : room.guestPoints,
      ),
    );

    if (response.gameFinished) {
      _showRoundResultAfterDelay(_showFinalResult);
      return;
    }

    if (winnerId == null) {
      _showRoundResultAfterDelay(_showDrawResult);
      return;
    }

    final winner = _findPlayer(winnerId);

    _showRoundResultAfterDelay(
      () => _showGameResult(
        winner.symbol == PlayerSymbol.x ? GameResult.xWins : GameResult.oWins,
      ),
    );
  }

  void _showDrawResult() {
    _showGameResult(GameResult.draw);
  }

  void _showGameResult(GameResult result) => _gameDialog.showGameResult(
    result: result,
    mySymbol: myPlayer.symbol,
    onConfirm: setReady,
  );

  void _showRoundResultAfterDelay(VoidCallback callback) {
    _resultTimer?.cancel();
    _resultTimer = Timer(GameConstants.resultDelay, () {
      if (_disposed) {
        return;
      }
      _resultTimer = null;
      callback();
    });
  }

  void _showFinalResult() {
    try {
      final currentGuest = guest;

      if (currentGuest == null) {
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
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);

    PopupUtils.showError('Room error: $message');

    LoggerUtils.error('Room error: $message');

    clearError();
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

  // void clearBoard() {
  //   state = state.copyWith(
  //     board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
  //     winningIndexes: const {},
  //   );
  // }

  void _handleMoveMade(MoveResultResponse response) {
    final room = state.room;

    final player = room.host.id == response.playerId
        ? room.host
        : room.guest?.id == response.playerId
        ? room.guest
        : null;

    if (player == null) {
      return;
    }

    state = state.copyWith(
      room: room.copyWith(turnPlayerId: response.turnPlayerId),
    );

    updateBoardValue(response.index, player.symbol);

    _handleMoveResult(response);
  }

  void _handleMoveResult(MoveResultResponse response) {
    final result = GameLogicUtils.checkWinner(state.board);

    if (result == GameResult.inProgress) {
      return;
    }

    if (result == GameResult.draw) {
      if (response.playerId == playerId) {
        _roomSocketService.submitGameResult();
      }

      return;
    }

    final winningIndexes = GameLogicUtils.getWinningIndexes(state.board)
        .toList();

    setWinningIndexes(winningIndexes.toSet());

    if (response.playerId == playerId) {
      _roomSocketService.submitGameResult(winningIndexes);
    }
  }

  void sendReaction(GameReaction reaction) =>
      _roomSocketService.sendReaction(reaction);

  void _handleReactionReceived(ReactionReceivedResponse event) {
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

  PlayerModel _findPlayer(String id) {
    final room = state.room;

    return room.host.id == id
        ? room.host
        : room.guest?.id == id
        ? room.guest!
        : room.host;
  }

  void _dispose() {
    if (_disposed) {
      return;
    }

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

  Future<void> share(String roomCode) async => await SharePlus.instance.share(
    ShareParams(
      text: GameConstants.getRoomShareText(roomCode),
      subject: GameConstants.appName,
    ),
  );
}
