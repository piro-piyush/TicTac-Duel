import 'package:tictac_duel/lib.dart';

class OnlineGameState extends Equatable {
  const OnlineGameState({
    required this.room,
    this.board = const [],
    this.winningIndexes = const {},
    this.errorMessage,
    this.infoMessage,
    // this.roundResult,
    // this.roundResultSubmitted = false,
    // this.movePending = false,
    this.showRoundAnimation = false,
    this.reactionEvent,
  });

  final RoomModel room;

  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  final String? errorMessage;
  final String? infoMessage;

  // final RoundResultResponse? roundResult;

  // final bool roundResultSubmitted;
  // final bool movePending;

  final bool showRoundAnimation;

  final GameReactionEvent? reactionEvent;

  OnlineGameState copyWith({
    RoomModel? room,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    String? errorMessage,
    String? infoMessage,
    RoundResultResponse? roundResult,
    // bool? roundResultSubmitted,
    // bool? movePending,
    bool? showRoundAnimation,
    GameReactionEvent? reactionEvent,
    bool clearError = false,
    bool clearInfo = false,
    bool clearAnimatedRound = false,
    bool clearRoundResult = false,
    bool clearReactionEvent = false,
  }) {
    return OnlineGameState(
      room: room ?? this.room,
      board: board ?? this.board,
      winningIndexes: winningIndexes ?? this.winningIndexes,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      infoMessage: clearInfo ? null : infoMessage ?? this.infoMessage,
      // roundResult: clearRoundResult ? null : roundResult ?? this.roundResult,
      // roundResultSubmitted: roundResultSubmitted ?? this.roundResultSubmitted,
      // movePending: movePending ?? this.movePending,
      showRoundAnimation: showRoundAnimation ?? this.showRoundAnimation,

      reactionEvent: clearReactionEvent
          ? null
          : reactionEvent ?? this.reactionEvent,
    );
  }

  factory OnlineGameState.initial(RoomModel room) {
    return OnlineGameState(
      room: room,
      board: List<PlayerSymbol?>.filled(
        GameConstants.totalCells,
        null,
      ),
    );
  }

  @override
  List<Object?> get props => [
    room,
    board,
    winningIndexes,
    errorMessage,
    infoMessage,
    // roundResult,
    // roundResultSubmitted,
    // movePending,
    showRoundAnimation,

    reactionEvent,
  ];
}
