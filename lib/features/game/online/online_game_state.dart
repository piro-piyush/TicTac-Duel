import 'package:tictac_duel/lib.dart';

class OnlineGameState extends Equatable {
  const OnlineGameState({
    required this.room,
    required this.board,
    this.winningIndexes = const {},
    this.errorMessage,
    this.showRoundAnimation = false,
    this.reactionEvent,
  });

  final RoomModel room;
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;
  final String? errorMessage;
  final bool showRoundAnimation;
  final ReactionReceivedResponse? reactionEvent;

  OnlineGameState copyWith({
    RoomModel? room,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    String? errorMessage,
    bool? showRoundAnimation,
    ReactionReceivedResponse? reactionEvent,
    bool clearError = false,
    bool clearRoundAnimation = false,
    bool clearReactionEvent = false,
  }) => OnlineGameState(
    room: room ?? this.room,
    board: board ?? this.board,
    winningIndexes: winningIndexes ?? this.winningIndexes,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    showRoundAnimation: clearRoundAnimation
        ? false
        : showRoundAnimation ?? this.showRoundAnimation,
    reactionEvent: clearReactionEvent
        ? null
        : reactionEvent ?? this.reactionEvent,
  );

  factory OnlineGameState.initial(RoomModel room) => OnlineGameState(
    room: room,
    board: List<PlayerSymbol?>.filled(GameConstants.totalCells, null),
  );

  @override
  List<Object?> get props => [
    room,
    board,
    winningIndexes,
    errorMessage,
    showRoundAnimation,
    reactionEvent,
  ];
}
