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

  // ===========================================================================
  // BOARD
  // ===========================================================================

  final RxList<PlayerSymbol?> _board = List<PlayerSymbol?>.filled(
    GameConstants.totalCells,
    null,
  ).obs;

  final RxSet<int> _winningIndexes = <int>{}.obs;

  // ===========================================================================
  // GAME STATE
  // ===========================================================================

  final RxInt _turnIndex = 0.obs;
  final RxInt _currentRound = 0.obs;
  final RxBool _isRoundFinished = false.obs;

  bool get isRoundFinished => _isRoundFinished.value;

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  final RxBool _showRoundAnimation = false.obs;
  final RxInt _animatedRound = 1.obs;

  // ===========================================================================
  // POINTS
  // ===========================================================================

  final RxInt _playerOnePoints = 0.obs;
  final RxInt _playerTwoPoints = 0.obs;

  int get playerOnePoints => _playerOnePoints.value;

  int get playerTwoPoints => _playerTwoPoints.value;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  List<PlayerSymbol?> get board => _board.toList();

  Set<int> get winningIndexes => _winningIndexes.toSet();

  int get turnIndex => _turnIndex.value;

  int get currentRound => _currentRound.value;

  int get animatedRound => _animatedRound.value;

  bool get showRoundAnimation => _showRoundAnimation.value;

  LocalPlayerModel get currentPlayer =>
      turnIndex == 0 ? game.playerOne : game.playerTwo;

  LocalPlayerModel get opponentPlayer =>
      turnIndex == 0 ? game.playerTwo : game.playerOne;

  PlayerSymbol get currentSymbol => currentPlayer.symbol;

  bool get isBoardFull => !_board.contains(null);

  bool get isCpuTurn =>
      game.isComputerGame && currentPlayer.id == game.playerTwo.id;

  bool get canMakeMove => !isBoardFull && !isCpuTurn;

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

    if (!isCpuTurn || isBoardFull) {
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

    if (isBoardFull || isRoundFinished) {
      return false;
    }

    if (game.isComputerGame && isCpuTurn) {
      return false;
    }

    return _board[index] == null;
  }

  Future<void> _makeMove(int index) async {
    if (index < 0 || index >= _board.length) {
      return;
    }

    if (_board[index] != null) {
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
  // MOVE VALIDATION
  // ===========================================================================

  // bool _canMakeMove(int index) {
  //   if (index < 0 || index >= _board.length) {
  //     return false;
  //   }
  //
  //   if (!canMakeMove) {
  //     return false;
  //   }
  //
  //   return _board[index] == null;
  // }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRoundResultDialog(result);
    });
  }

  void _showFinalResult() {
    final isDraw = playerOnePoints == playerTwoPoints;

    final winner = isDraw
        ? null
        : playerOnePoints > playerTwoPoints
        ? game.playerOne
        : game.playerTwo;

    final hasWon = winner?.id == game.playerOne.id;

    final result = ResultModel.local(
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
    );

    AppNavigation.replaceResult(result);
  }

  void _showRoundResultDialog(GameResult result) {
    _cancelResultTimer();

    _resultTimer = Timer(GameConstants.resultDelay, () {
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

          // Draw: alternate the starting player.
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
    } else if (winner == game.playerTwo.symbol) {
      _playerTwoPoints.value++;
    }
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

    if (!isCpuTurn || isBoardFull) {
      return;
    }

    _cpuMoveTimer = Timer(GameConstants.cpuMoveDelay, _makeCpuMove);
  }

  // ===========================================================================
  // GAME WINNER
  // ===========================================================================

  // int get _requiredWins => (game.maxRounds ~/ 2) + 1;
  //
  // bool get _hasGameWinner =>
  //     playerOneScore >= _requiredWins || playerTwoScore >= _requiredWins;

  bool get _isFinalRound => currentRound >= game.maxRounds;

  LocalPlayerModel? get gameWinner {
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
  // RESET
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
  // TIMER HELPERS
  // ===========================================================================

  void _cancelCpuTimer() {
    _cpuMoveTimer?.cancel();
    _cpuMoveTimer = null;
  }

  void _cancelResultTimer() {
    _resultTimer?.cancel();
    _resultTimer = null;
  }

  void _cancelRoundTimers() {
    _cancelCpuTimer();
    _cancelResultTimer();
  }

  void _cancelTimers() {
    _cancelRoundTimers();

    _roundAnimationTimer?.cancel();
    _roundAnimationTimer = null;
  }
}
