import 'package:tictac_duel/lib.dart';

class LocalGameBoardController extends GetxController {
  LocalGameBoardController({
    required this.game,
    required this._musicController,
  });

  final LocalGameModel game;
  final MusicController _musicController;

  Timer? _cpuMoveTimer;
  Timer? _roundAnimationTimer;
  Timer? _resultTimer;
  Timer? _reactionTimer;

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  String get playerId => GameConstants.localPlayerOneId;

  // ===========================================================================
  // BOARD
  // ===========================================================================

  final RxList<PlayerSymbol?> _board = List<PlayerSymbol?>.filled(
    GameConstants.totalCells,
    null,
  ).obs;

  final RxSet<int> _winningIndexes = <int>{}.obs;

  List<PlayerSymbol?> get board => _board.toList();

  Set<int> get winningIndexes => _winningIndexes.toSet();

  // ===========================================================================
  // GAME STATE
  // ===========================================================================

  final RxInt _turnIndex = 0.obs;
  final RxInt _currentRound = 0.obs;
  final RxBool _isRoundFinished = false.obs;

  int get turnIndex => _turnIndex.value;

  int get currentRound => _currentRound.value;

  bool get isRoundFinished => _isRoundFinished.value;

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  final RxBool _showRoundAnimation = false.obs;
  final RxInt _animatedRound = 1.obs;

  bool get showRoundAnimation => _showRoundAnimation.value;

  int get animatedRound => _animatedRound.value;

  // ===========================================================================
  // POINTS
  // ===========================================================================

  final RxInt _playerOnePoints = 0.obs;
  final RxInt _playerTwoPoints = 0.obs;

  int get playerOnePoints => _playerOnePoints.value;

  int get playerTwoPoints => _playerTwoPoints.value;

  // ===========================================================================
  // REACTION
  // ===========================================================================

  final Rxn<GameReactionEvent> _reactionEvent = Rxn<GameReactionEvent>();

  GameReactionEvent? get reactionEvent => _reactionEvent.value;

  // ===========================================================================
  // PLAYER STATE
  // ===========================================================================

  PlayerModel get currentPlayer =>
      turnIndex == 0 ? game.playerOne : game.playerTwo;

  PlayerModel get opponentPlayer =>
      turnIndex == 0 ? game.playerTwo : game.playerOne;

  PlayerSymbol get currentSymbol => currentPlayer.symbol;

  bool get isBoardFull => !_board.contains(null);

  bool get isCpuTurn =>
      game.isComputerGame && currentPlayer.id == game.playerTwo.id;

  bool get canMakeMove => !isBoardFull && !isRoundFinished && !isCpuTurn;

  bool get _isFinalRound => currentRound >= game.maxRounds;

  PlayerModel? get gameWinner {
    if (!_isFinalRound) {
      return null;
    }

    if (playerOnePoints > playerTwoPoints) {
      return game.playerOne;
    }

    if (playerTwoPoints > playerOnePoints) {
      return game.playerTwo;
    }

    return null;
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    _startGame();
  }

  @override
  void onClose() {
    _cancelTimers();
    super.onClose();
  }

  // ===========================================================================
  // GAME LIFECYCLE
  // ===========================================================================

  void quitGame() {
    closeGame();
    AppNavigation.back();
  }

  void closeGame() {
    _cancelTimers();
  }

  // ===========================================================================
  // GAME START
  // ===========================================================================

  void _startGame() {
    _playerOnePoints.value = 0;
    _playerTwoPoints.value = 0;
    _currentRound.value = 0;

    startNextRound(game.playerOne.symbol);
  }

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

    if (!isCpuTurn || isBoardFull || isRoundFinished) {
      return;
    }

    final difficulty = game.difficulty;

    if (difficulty == null) {
      return;
    }

    final move = GameLogicUtils.getBestMove(
      board: board,
      difficulty: difficulty,
      cpuSymbol: currentSymbol,
      opponentSymbol: opponentPlayer.symbol,
    );

    if (move == null) {
      return;
    }

    await _makeMove(move);
  }

  bool _canMakeHumanMove(int index) {
    if (index < 0 || index >= _board.length) {
      return false;
    }

    if (!canMakeMove) {
      return false;
    }

    return _board[index] == null;
  }

  Future<void> _makeMove(int index) async {
    if (index < 0 ||
        index >= _board.length ||
        _board[index] != null ||
        isRoundFinished) {
      return;
    }

    final symbol = currentSymbol;

    _board[index] = symbol;

    await WidgetsBinding.instance.endOfFrame;

    final result = GameLogicUtils.checkWinner(board);

    if (result.isFinished) {
      _handleRoundResult(result);
      return;
    }

    _switchTurn();
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void _handleRoundResult(GameResult result) {
    _cancelCpuTimer();
    _cancelResultTimer();

    _isRoundFinished.value = true;

    if (result.hasWinner) {
      final winner = result.winner;

      if (winner != null) {
        _updateWinnerScore(winner);

        _winningIndexes.assignAll(GameLogicUtils.getWinningIndexes(board));
      }
    }

    // Allow the winning line to render before starting the result delay.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) {
        return;
      }

      _showRoundResultDialog(result);
    });
  }

  void _showRoundResultDialog(GameResult result) {
    _cancelResultTimer();

    _resultTimer = Timer(GameConstants.resultDelay, () {
      if (isClosed) {
        return;
      }

      _resultTimer = null;

      if (_isFinalRound) {
        _showFinalResult();
        return;
      }

      GameDialogUtils.showGameResult(
        result: result,
        mySymbol: game.playerOne.symbol,
        onConfirm: () {
          final winner = result.winner;

          if (winner != null) {
            startNextRound(winner);
            return;
          }

          final nextStarter = currentRound.isEven
              ? game.playerOne.symbol
              : game.playerTwo.symbol;

          startNextRound(nextStarter);
        },
      );
    });
  }

  void _updateWinnerScore(PlayerSymbol winner) {
    if (winner == game.playerOne.symbol) {
      _playerOnePoints.value++;
      return;
    }

    if (winner == game.playerTwo.symbol) {
      _playerTwoPoints.value++;
    }
  }

  // ===========================================================================
  // FINAL RESULT
  // ===========================================================================

  void _showFinalResult() {
    final isDraw = playerOnePoints == playerTwoPoints;

    final winner = isDraw
        ? null
        : playerOnePoints > playerTwoPoints
        ? game.playerOne
        : game.playerTwo;

    final hasWon = winner?.id == game.playerOne.id;

    final result = ResultModel.completed(
      playerOne: game.playerOne,
      playerTwo: game.playerTwo,
      playerOnePoints: playerOnePoints,
      playerTwoPoints: playerTwoPoints,
      currentRound: currentRound,
      maxRounds: game.maxRounds,
      gameWinner: winner,
      isDraw: isDraw,
      hasWon: hasWon,
      showConfetti: hasWon,
      isOnline: false,
      theme: game.theme,
    );

    AppNavigation.replaceResult(result);
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _switchTurn() {
    _turnIndex.value = turnIndex == 0 ? 1 : 0;
    _scheduleCpuMove();
  }

  void _scheduleCpuMove() {
    _cancelCpuTimer();

    if (!isCpuTurn || isBoardFull || isRoundFinished) {
      return;
    }

    _cpuMoveTimer = Timer(GameConstants.cpuMoveDelay, _makeCpuMove);
  }

  // ===========================================================================
  // NEXT ROUND
  // ===========================================================================

  void startNextRound(PlayerSymbol startingSymbol) {
    if (_isFinalRound) {
      return;
    }

    _cancelRoundTimers();

    _resetBoard();

    _currentRound.value++;

    _turnIndex.value = startingSymbol == game.playerOne.symbol ? 0 : 1;

    _musicController.playRoundStart();

    _showRoundStartAnimation();
    _scheduleCpuMove();
  }

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  void _showRoundStartAnimation() {
    _roundAnimationTimer?.cancel();

    _animatedRound.value = currentRound;
    _showRoundAnimation.value = true;

    _roundAnimationTimer = Timer(GameConstants.roundAnimationDuration, () {
      _showRoundAnimation.value = false;
      _roundAnimationTimer = null;
    });
  }

  // ===========================================================================
  // RESTART
  // ===========================================================================

  void restartGame() {
    _cancelTimers();

    _resetBoard();

    _turnIndex.value = 0;
    _currentRound.value = 1;

    _playerOnePoints.value = 0;
    _playerTwoPoints.value = 0;

    _showRoundAnimation.value = false;
    _animatedRound.value = 1;

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
    _isRoundFinished.value = false;

    _board.assignAll(
      List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );

    _winningIndexes.clear();
  }

  // ===========================================================================
  // REACTION
  // ===========================================================================

  void sendReaction(GameReaction reaction) {
    final senderId = playerId;

    final targetPlayerId = senderId == game.playerOne.id
        ? game.playerTwo.id
        : game.playerOne.id;

    _reactionTimer?.cancel();

    _reactionEvent.value = GameReactionEvent(
      reaction: reaction,
      senderId: senderId,
      targetPlayerId: targetPlayerId,
    );

    _reactionTimer = Timer(GameConstants.reactionTotalDuration, () {
      if (!isClosed) {
        _reactionEvent.value = null;
      }

      _reactionTimer = null;
    });
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
