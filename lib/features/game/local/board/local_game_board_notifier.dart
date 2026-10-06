import 'package:tictac_duel/lib.dart';

final localGameBoardProvider =
    NotifierProvider.family<
      LocalGameBoardNotifier,
      LocalGameBoardState,
      LocalGameModel
    >(LocalGameBoardNotifier.new);

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
        mySymbol: state.game.playerOne.symbol,
        onConfirm: () {
          final winner = result.winner;

          if (winner != null) {
            startNextRound(winner);
            return;
          }

          final nextStarter = state.currentRound.isEven
              ? state.game.playerOne.symbol
              : state.game.playerTwo.symbol;

          startNextRound(nextStarter);
        },
      );
    });
  }

  void _updateWinnerScore(PlayerSymbol winner) {
    if (winner == state.game.playerOne.symbol) {
      state = state.copyWith(playerOnePoints: state.playerOnePoints + 1);
      return;
    }

    if (winner == state.game.playerTwo.symbol) {
      state = state.copyWith(playerTwoPoints: state.playerTwoPoints + 1);
    }
  }

  // ===========================================================================
  // FINAL RESULT
  // ===========================================================================

  void _showFinalResult() {
    final isDraw = state.playerOnePoints == state.playerTwoPoints;

    final winner = isDraw
        ? null
        : state.playerOnePoints > state.playerTwoPoints
        ? state.game.playerOne
        : state.game.playerTwo;

    final hasWon = winner?.id == state.game.playerOne.id;

    final result = ResultModel.completed(
      playerOne: state.game.playerOne,
      playerTwo: state.game.playerTwo,
      playerOnePoints: state.playerOnePoints,
      playerTwoPoints: state.playerTwoPoints,
      currentRound: state.currentRound,
      maxRounds: state.game.maxRounds,
      gameWinner: winner,
      isDraw: isDraw,
      hasWon: hasWon,
      showConfetti: hasWon,
      isOnline: false,
      theme: state.game.theme,
    );

    _navigation.replaceResult(result);
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _switchTurn() {
    state = state.copyWith(turnIndex: state.turnIndex == 0 ? 1 : 0);

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
      turnIndex: startingSymbol == state.game.playerOne.symbol ? 0 : 1,
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
      turnIndex: 0,
      currentRound: 1,
      playerOnePoints: 0,
      playerTwoPoints: 0,
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
  // REACTION
  // ===========================================================================

  void sendReaction(GameReaction reaction) {
    final senderId = playerId;

    final targetPlayerId = senderId == state.game.playerOne.id
        ? state.game.playerTwo.id
        : state.game.playerOne.id;

    _reactionTimer?.cancel();

    state = state.copyWith(
      reactionEvent: GameReactionEvent(
        reaction: reaction,
        senderId: senderId,
        targetPlayerId: targetPlayerId,
      ),
    );

    _reactionTimer = Timer(GameConstants.reactionTotalDuration, () {
      if (!_disposed) {
        state = state.copyWith(clearReactionEvent: true);
      }

      _reactionTimer = null;
    });
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

    state = state.copyWith(
      playerOnePoints: 0,
      playerTwoPoints: 0,
      currentRound: 0,
    );

    startNextRound(state.game.playerOne.symbol);
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
