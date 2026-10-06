import 'package:tictac_duel/lib.dart';

class LocalGameBoardState extends Equatable {
  const LocalGameBoardState({
    required this.game,
    this.board = const [],
    this.winningIndexes = const {},
    this.turnIndex = 0,
    this.currentRound = 0,
    this.isRoundFinished = false,
    this.showRoundAnimation = false,
    this.animatedRound = 1,
    this.playerOnePoints = 0,
    this.playerTwoPoints = 0,
    this.reactionEvent,
  });

  final LocalGameModel game;

  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  final int turnIndex;
  final int currentRound;
  final bool isRoundFinished;

  final bool showRoundAnimation;
  final int animatedRound;

  final int playerOnePoints;
  final int playerTwoPoints;

  final GameReactionEvent? reactionEvent;

  LocalGameBoardState copyWith({
    LocalGameModel? game,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    int? turnIndex,
    int? currentRound,
    bool? isRoundFinished,
    bool? showRoundAnimation,
    int? animatedRound,
    int? playerOnePoints,
    int? playerTwoPoints,
    GameReactionEvent? reactionEvent,
    bool clearReactionEvent = false,
  }) {
    return LocalGameBoardState(
      game: game ?? this.game,
      board: board ?? this.board,
      winningIndexes: winningIndexes ?? this.winningIndexes,
      turnIndex: turnIndex ?? this.turnIndex,
      currentRound: currentRound ?? this.currentRound,
      isRoundFinished: isRoundFinished ?? this.isRoundFinished,
      showRoundAnimation: showRoundAnimation ?? this.showRoundAnimation,
      animatedRound: animatedRound ?? this.animatedRound,
      playerOnePoints: playerOnePoints ?? this.playerOnePoints,
      playerTwoPoints: playerTwoPoints ?? this.playerTwoPoints,
      reactionEvent: clearReactionEvent
          ? null
          : reactionEvent ?? this.reactionEvent,
    );
  }

  PlayerModel get currentPlayer {
    return turnIndex == 0 ? game.playerOne : game.playerTwo;
  }

  PlayerModel get opponentPlayer {
    return turnIndex == 0 ? game.playerTwo : game.playerOne;
  }

  PlayerSymbol get currentSymbol => currentPlayer.symbol;

  bool get isBoardFull => !board.contains(null);

  bool get isCpuTurn {
    return game.isComputerGame && currentPlayer.id == game.playerTwo.id;
  }

  bool get canMakeMove {
    return !isBoardFull && !isRoundFinished && !isCpuTurn;
  }

  bool get isFinalRound => currentRound >= game.maxRounds;

  PlayerModel? get gameWinner {
    if (!isFinalRound) {
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

  @override
  List<Object?> get props => [
    game,
    board,
    winningIndexes,
    turnIndex,
    currentRound,
    isRoundFinished,
    showRoundAnimation,
    animatedRound,
    playerOnePoints,
    playerTwoPoints,
    reactionEvent,
  ];
}
