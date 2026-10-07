import 'package:tictac_duel/lib.dart';

class OnlineGameState extends Equatable {
  const OnlineGameState({
    required this.room,
    this.board = const [],
    this.winningIndexes = const {},
    this.errorMessage,
    this.infoMessage,
    this.roundResult,
    this.playerOnePoints = 0,
    this.playerTwoPoints = 0,
    this.playerOneReady = false,
    this.playerTwoReady = false,
    this.roundResultSubmitted = false,
    this.movePending = false,
    this.turnIndex = 0,
    this.turnPlayerId,
    this.showRoundAnimation = false,
    this.animatedRound = 0,
    this.reactionEvent,
  });

  final Room room;

  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  final String? errorMessage;
  final String? infoMessage;

  final RoundResultResponse? roundResult;

  final int playerOnePoints;
  final int playerTwoPoints;

  final bool playerOneReady;
  final bool playerTwoReady;

  final bool roundResultSubmitted;
  final bool movePending;

  final int turnIndex;
  final String? turnPlayerId;

  final bool showRoundAnimation;
  final int animatedRound;

  final GameReactionEvent? reactionEvent;

  OnlineGameState copyWith({
    Room? room,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    String? errorMessage,
    String? infoMessage,
    RoundResultResponse? roundResult,
    int? playerOnePoints,
    int? playerTwoPoints,
    bool? playerOneReady,
    bool? playerTwoReady,
    bool? roundResultSubmitted,
    bool? movePending,
    int? turnIndex,
    String? turnPlayerId,
    bool? showRoundAnimation,
    int? animatedRound,
    GameReactionEvent? reactionEvent,
    bool clearError = false,
    bool clearInfo = false,
    bool clearRoundResult = false,
    bool clearTurnPlayerId = false,
    bool clearReactionEvent = false,
  }) {
    return OnlineGameState(
      room: room ?? this.room,
      board: board ?? this.board,
      winningIndexes: winningIndexes ?? this.winningIndexes,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      infoMessage: clearInfo ? null : infoMessage ?? this.infoMessage,
      roundResult: clearRoundResult ? null : roundResult ?? this.roundResult,
      playerOnePoints: playerOnePoints ?? this.playerOnePoints,
      playerTwoPoints: playerTwoPoints ?? this.playerTwoPoints,
      playerOneReady: playerOneReady ?? this.playerOneReady,
      playerTwoReady: playerTwoReady ?? this.playerTwoReady,
      roundResultSubmitted: roundResultSubmitted ?? this.roundResultSubmitted,
      movePending: movePending ?? this.movePending,
      turnIndex: turnIndex ?? this.turnIndex,
      turnPlayerId: clearTurnPlayerId
          ? null
          : turnPlayerId ?? this.turnPlayerId,
      showRoundAnimation: showRoundAnimation ?? this.showRoundAnimation,
      animatedRound: animatedRound ?? this.animatedRound,
      reactionEvent: clearReactionEvent
          ? null
          : reactionEvent ?? this.reactionEvent,
    );
  }

  @override
  List<Object?> get props => [
    room,
    board,
    winningIndexes,
    errorMessage,
    infoMessage,
    roundResult,
    playerOnePoints,
    playerTwoPoints,
    playerOneReady,
    playerTwoReady,
    roundResultSubmitted,
    movePending,
    turnIndex,
    turnPlayerId,
    showRoundAnimation,
    animatedRound,
    reactionEvent,
  ];
}
