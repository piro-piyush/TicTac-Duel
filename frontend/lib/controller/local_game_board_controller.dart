import 'package:tictac_duel/lib.dart';

class LocalGameBoardController extends GetxController {
  LocalGameBoardController({required this.game});

  final LocalGameModel game;

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
  final RxInt _currentRound = 1.obs;

  // ===========================================================================
  // ROUND ANIMATION
  // ===========================================================================

  final RxBool _showRoundAnimation = false.obs;
  final RxInt _animatedRound = 1.obs;

  // ===========================================================================
  // SCORES
  // ===========================================================================

  final RxInt _playerOneScore = 0.obs;
  final RxInt _playerTwoScore = 0.obs;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  List<PlayerSymbol?> get board => _board.toList();

  Set<int> get winningIndexes => _winningIndexes.toSet();

  int get turnIndex => _turnIndex.value;

  int get currentRound => _currentRound.value;

  int get animatedRound => _animatedRound.value;

  bool get showRoundAnimation => _showRoundAnimation.value;

  int get playerOneScore => _playerOneScore.value;

  int get playerTwoScore => _playerTwoScore.value;

  PlayerModel get currentPlayer {
    return turnIndex == 0 ? game.playerOne : game.playerTwo;
  }

  PlayerModel get opponentPlayer {
    return turnIndex == 0 ? game.playerTwo : game.playerOne;
  }

  PlayerSymbol get currentSymbol {
    return currentPlayer.symbol;
  }

  bool get isBoardFull {
    return !_board.contains(null);
  }

  bool get isCpuTurn {
    return game.gameType == LocalGameType.computer &&
        currentPlayer.id == GameConstants.localCpuId;
  }

  bool get _canMakeMoveForCpu {
    return isCpuTurn && !isBoardFull;
  }

  // ===========================================================================
  // GAME ACTIONS
  // ===========================================================================

  Future<void> onCellTap(int index) async {
    if (!_canMakeMove(index)) {
      return;
    }

    // Add the move.
    _board[index] = currentSymbol;

    // Stop here and let Flutter paint the tile.
    await WidgetsBinding.instance.endOfFrame;

    // Now evaluate the result.
    final result = GameLogicUtils.checkWinner(_board);

    switch (result) {
      case GameResult.xWins:
      case GameResult.oWins:
      case GameResult.draw:
        _handleRoundResult(result);
        return;

      case GameResult.inProgress:
        _switchTurn();
        return;
    }
  }

  // ===========================================================================
  // MOVE VALIDATION
  // ===========================================================================

  bool _canMakeMove(int index) {
    if (index < 0 || index >= _board.length) {
      return false;
    }

    return _board[index] == null;
  }

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  void _handleRoundResult(GameResult result) {
    _cpuMoveTimer?.cancel();
    _resultTimer?.cancel();

    switch (result) {
      case GameResult.xWins:
      case GameResult.oWins:
        final winner = result.winner;

        if (winner != null) {
          _updateWinnerScore(winner);
        }

        _winningIndexes.assignAll(GameLogicUtils.getWinningIndexes(_board));
        break;

      case GameResult.draw:
        break;

      case GameResult.inProgress:
        return;
    }

    // Increment the round after the current round finishes.
    if (!_hasGameWinner && !_isFinalRound) {
      _currentRound.value++;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRoundResultDialog(result);
    });
  }

  void _showRoundResultDialog(GameResult result) {
    _resultTimer = Timer(GameConstants.resultDelay, () {
      if (_hasGameWinner || _isFinalRound) {
        GameDialogUtils.showGameFinished(
          playerOne: game.playerOne,
          playerTwo: game.playerTwo,
          playerOneScore: playerOneScore,
          playerTwoScore: playerTwoScore,
          mySymbol: game.playerOne.symbol,
        );

        return;
      }

      GameDialogUtils.showGameResult(
        result: result,
        mySymbol: game.playerOne.symbol,
        onConfirm: startNextRound,
      );
    });
  }

  void _updateWinnerScore(PlayerSymbol winner) {
    if (winner == game.playerOne.symbol) {
      _playerOneScore.value++;
      return;
    }

    if (winner == game.playerTwo.symbol) {
      _playerTwoScore.value++;
    }
  }

  // ===========================================================================
  // TURN
  // ===========================================================================

  void _switchTurn() {
    _turnIndex.value = turnIndex == 0 ? 1 : 0;

    if (!isCpuTurn) {
      return;
    }

    _cpuMoveTimer?.cancel();

    _cpuMoveTimer = Timer(GameConstants.cpuMoveDelay, _makeCpuMove);
  }

  void _makeCpuMove() {
    if (!_canMakeMoveForCpu) {
      return;
    }

    final move = GameLogicUtils.getBestMove(
      board: board,
      difficulty: game.difficulty ?? CpuDifficulty.medium,
      cpuSymbol: currentSymbol,
      opponentSymbol: opponentPlayer.symbol,
    );

    if (move == null) {
      return;
    }

    onCellTap(move);
  }

  // ===========================================================================
  // GAME WINNER
  // ===========================================================================

  int get _requiredWins {
    return (game.maxRounds ~/ 2) + 1;
  }

  bool get _hasGameWinner {
    return playerOneScore >= _requiredWins || playerTwoScore >= _requiredWins;
  }

  bool get _isFinalRound {
    return currentRound >= game.maxRounds;
  }

  PlayerModel? get gameWinner {
    if (!_hasGameWinner) {
      return null;
    }

    if (playerOneScore > playerTwoScore) {
      return game.playerOne;
    }

    if (playerTwoScore > playerOneScore) {
      return game.playerTwo;
    }

    return null;
  }

  // ===========================================================================
  // NEXT ROUND
  // ===========================================================================

  void startNextRound() {
    if (_isFinalRound) {
      return;
    }

    _cpuMoveTimer?.cancel();
    _resultTimer?.cancel();

    // Clear previous round state first.
    _winningIndexes.clear();
    _resetBoard();

    // Move to the next round.
    _currentRound.value++;

    // Alternate starting player.
    _turnIndex.value = (currentRound - 1) % 2;

    _showRoundStartAnimation();

    // If CPU starts the new round, let it make its move.
    if (isCpuTurn) {
      _cpuMoveTimer = Timer(GameConstants.cpuMoveDelay, _makeCpuMove);
    }
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
    });
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  void restartGame() {
    _cpuMoveTimer?.cancel();
    _resultTimer?.cancel();
    _roundAnimationTimer?.cancel();

    _resetBoard();

    _turnIndex.value = 0;
    _currentRound.value = 1;

    _playerOneScore.value = 0;
    _playerTwoScore.value = 0;

    _showRoundAnimation.value = false;
    _animatedRound.value = 1;
  }

  void resetBoard() {
    _cpuMoveTimer?.cancel();
    _resultTimer?.cancel();

    _resetBoard();
  }

  void _resetBoard() {
    _board.assignAll(
      List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
    );

    _winningIndexes.clear();
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onClose() {
    _cpuMoveTimer?.cancel();
    _resultTimer?.cancel();
    _roundAnimationTimer?.cancel();

    super.onClose();
  }
}
