import 'package:tictac_duel/lib.dart';

final localGameBoardProvider = NotifierProvider.autoDispose
    .family<LocalGameBoardNotifier, LocalGameBoardState, LocalGameModel>(
      LocalGameBoardNotifier.new,
    );

class LocalGameBoardNotifier extends Notifier<LocalGameBoardState> {
  LocalGameBoardNotifier(this.game);

  final LocalGameModel game;
  late final AudioNotifier _audioNotifier;
  late final AppNavigation _navigation;
  late final GameDialogUtils _gameDialog;

  Timer? _cpuMoveTimer;
  Timer? _roundAnimationTimer;
  Timer? _resultTimer;
  Timer? _reactionTimer;

  final bool _disposed = false;

  @override
  LocalGameBoardState build() {
    _audioNotifier = ref.read(audioProvider.notifier);
    _navigation = ref.read(appNavigationProvider);
    _gameDialog = ref.read(gameDialogProvider);

    ref.onDispose(_cancelTimers);

    Future.microtask(_startGame);

    return LocalGameBoardState(
      game: game,
      board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );
  }

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  String get playerId => GameConstants.localPlayerOneId;

  // ===========================================================================
  // GAME ACTIONS
  // ===========================================================================

  Future<void> onCellTap(int index) async {
    if (!_canMakeHumanMove(index)) {
      return;
    }

    await _makeMove(index);
  }

  Future<void> _makeCpuMove() async {
    _cpuMoveTimer = null;

    if (_disposed ||
        !state.isCpuTurn ||
        state.isBoardFull ||
        state.isRoundFinished) {
      return;
    }

    final difficulty = state.game.difficulty;

    if (difficulty == null) {
      return;
    }

    final move = GameLogicUtils.getBestMove(
      board: state.board,
      difficulty: difficulty,
      cpuSymbol: state.currentSymbol,
      opponentSymbol: state.opponentPlayer.symbol,
    );

    if (move == null) {
      return;
    }

    await _makeMove(move);
  }

  bool _canMakeHumanMove(int index) {
    if (index < 0 || index >= state.board.length) {
      return false;
    }

    if (!state.canMakeMove) {
      return false;
    }

    return state.board[index] == null;
  }

  Future<void> _makeMove(int index) async {
    if (_disposed ||
        index < 0 ||
        index >= state.board.length ||
        state.board[index] != null ||
        state.isRoundFinished) {
      return;
    }

    final symbol = state.currentSymbol;
    final board = List<PlayerSymbol?>.from(state.board);

    board[index] = symbol;

    state = state.copyWith(board: board);

    await WidgetsBinding.instance.endOfFrame;

    if (_disposed) {
      return;
    }

    final result = GameLogicUtils.checkWinner(state.board);

    if (result.isFinished) {
      _handleRoundResult(result);
      return;
    }

    _switchTurn();
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void _handleRoundResult(GameResult result) {
    _cancelCpuTimer();
    _cancelResultTimer();

    state = state.copyWith(isRoundFinished: true);

    if (result.hasWinner) {
      final winner = result.winner;

      if (winner != null) {
        _updateWinnerScore(winner);

        state = state.copyWith(
          winningIndexes: GameLogicUtils.getWinningIndexes(state.board),
        );
        _audioNotifier.playDraw();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed) {
        return;
      }

      _showRoundResultDialog(result);
    });
  }

  void _showRoundResultDialog(GameResult result) {
    _cancelResultTimer();

    _resultTimer = Timer(GameConstants.resultDelay, () {
      if (_disposed) {
        return;
      }

      _resultTimer = null;

      if (state.isFinalRound) {
        _showFinalResult();
        return;
      }

      _gameDialog.showGameResult(
        result: result,
        mySymbol: state.game.host.symbol,
        onConfirm: () {
          final winner = result.winner;

          if (winner != null) {
            startNextRound(winner);
            return;
          }

          final nextStarter = state.currentRound.isEven
              ? state.game.host.symbol
              : state.game.guest.symbol;

          startNextRound(nextStarter);
        },
      );
    });
  }

  void _updateWinnerScore(PlayerSymbol winner) {
    if (winner == state.game.host.symbol) {
      state = state.copyWith(hostPoints: state.hostPoints + 1);
      return;
    }

    if (winner == state.game.guest.symbol) {
      state = state.copyWith(guestPoints: state.guestPoints + 1);
    }
  }

  // ===========================================================================
  // FINAL RESULT
  // ===========================================================================

  void _showFinalResult() {
    final isDraw = state.hostPoints == state.guestPoints;

    final winner = isDraw
        ? null
        : state.hostPoints > state.guestPoints
        ? state.game.host
        : state.game.guest;

    final hasWon = winner?.id == state.game.host.id;

    final result = ResultModel.completed(
      host: state.game.host,
      guest: state.game.guest,
      hostPoints: state.hostPoints,
      guestPoints: state.guestPoints,
      currentRound: state.currentRound,
      maxRounds: state.game.maxRounds,
      gameWinner: winner,
      isDraw: isDraw,
      hasWon: hasWon,
      showConfetti: hasWon,
      isOnline: false,
      theme: state.game.theme,
    );

    _navigation.goToResult(result);
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _switchTurn() {
    state = state.copyWith(
      turnPlayerId: state.turnPlayerId == state.game.host.id
          ? state.game.guest.id
          : state.game.host.id,
    );

    _scheduleCpuMove();
  }

  void _scheduleCpuMove() {
    _cancelCpuTimer();

    if (_disposed ||
        !state.isCpuTurn ||
        state.isBoardFull ||
        state.isRoundFinished) {
      return;
    }

    _cpuMoveTimer = Timer(GameConstants.cpuMoveDelay, _makeCpuMove);
  }

  // ===========================================================================
  // NEXT ROUND
  // ===========================================================================

  void startNextRound(PlayerSymbol startingSymbol) {
    if (state.isFinalRound) {
      return;
    }

    _cancelRoundTimers();

    _resetBoard();

    state = state.copyWith(
      currentRound: state.currentRound + 1,
      turnPlayerId: startingSymbol == state.game.host.symbol
          ? state.game.host.id
          : state.game.guest.id,
    );

    _audioNotifier.playRoundStart();

    _showRoundStartAnimation();
    _scheduleCpuMove();
  }

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  void _showRoundStartAnimation() {
    _cancelRoundAnimationTimer();

    state = state.copyWith(
      animatedRound: state.currentRound,
      showRoundAnimation: true,
    );

    _roundAnimationTimer = Timer(GameConstants.roundAnimationDuration, () {
      if (_disposed) {
        return;
      }

      state = state.copyWith(showRoundAnimation: false);

      _roundAnimationTimer = null;
    });
  }

  // ===========================================================================
  // RESTART
  // ===========================================================================

  void restartGame() {
    _cancelTimers();

    _resetBoard();

    state = state.copyWith(
      turnPlayerId: state.game.host.id,
      currentRound: 1,
      hostPoints: 0,
      guestPoints: 0,
      showRoundAnimation: false,
      animatedRound: 1,
    );

    _showRoundStartAnimation();
    _scheduleCpuMove();
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  void resetBoard() {
    _cancelRoundTimers();
    _resetBoard();
  }

  void _resetBoard() {
    final board = List<PlayerSymbol?>.filled(GameConstants.totalCells, null);

    state = state.copyWith(
      board: board,
      winningIndexes: <int>{},
      isRoundFinished: false,
    );
  }

  // ===========================================================================
  // GAME LIFECYCLE
  // ===========================================================================

  void quitGame() {
    closeGame();
    _navigation.back();
  }

  void closeGame() {
    _cancelTimers();
  }

  void _startGame() {
    if (_disposed) {
      return;
    }

    state = state.copyWith(hostPoints: 0, guestPoints: 0, currentRound: 0);

    startNextRound(state.game.host.symbol);
  }

  // ===========================================================================
  // TIMER HELPERS
  // ===========================================================================

  void _cancelCpuTimer() {
    _cpuMoveTimer?.cancel();
    _cpuMoveTimer = null;
  }

  void _cancelRoundAnimationTimer() {
    _roundAnimationTimer?.cancel();
    _roundAnimationTimer = null;
  }

  void _cancelResultTimer() {
    _resultTimer?.cancel();
    _resultTimer = null;
  }

  void _cancelReactionTimer() {
    _reactionTimer?.cancel();
    _reactionTimer = null;
  }

  void _cancelRoundTimers() {
    _cancelCpuTimer();
    _cancelResultTimer();
    _cancelRoundAnimationTimer();
  }

  void _cancelTimers() {
    _cancelRoundTimers();
    _cancelReactionTimer();
  }
}
