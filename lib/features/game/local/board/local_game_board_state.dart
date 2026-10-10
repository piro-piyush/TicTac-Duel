import 'package:tictac_duel/lib.dart';

class LocalGameBoardState extends Equatable {
  const LocalGameBoardState({
    required this.game,
    this.board = const [],
    this.winningIndexes = const {},
    this.turnPlayerId,
    this.currentRound = 0,
    this.isRoundFinished = false,
    this.showRoundAnimation = false,
    this.animatedRound = 1,
    this.hostPoints = 0,
    this.guestPoints = 0,
    this.reactionEvent,
  });

  final LocalGameModel game;

  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  final String? turnPlayerId;
  final int currentRound;
  final bool isRoundFinished;

  final bool showRoundAnimation;
  final int animatedRound;

  final int hostPoints;
  final int guestPoints;

  final ReactionReceivedResponse? reactionEvent;

  LocalGameBoardState copyWith({
    LocalGameModel? game,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    String? turnPlayerId,
    int? currentRound,
    bool? isRoundFinished,
    bool? showRoundAnimation,
    int? animatedRound,
    int? hostPoints,
    int? guestPoints,
    ReactionReceivedResponse? reactionEvent,
    bool clearReactionEvent = false,
  }) => LocalGameBoardState(
    game: game ?? this.game,
    board: board ?? this.board,
    winningIndexes: winningIndexes ?? this.winningIndexes,
    turnPlayerId: turnPlayerId ?? this.turnPlayerId,
    currentRound: currentRound ?? this.currentRound,
    isRoundFinished: isRoundFinished ?? this.isRoundFinished,
    showRoundAnimation: showRoundAnimation ?? this.showRoundAnimation,
    animatedRound: animatedRound ?? this.animatedRound,
    hostPoints: hostPoints ?? this.hostPoints,
    guestPoints: guestPoints ?? this.guestPoints,
    reactionEvent: clearReactionEvent
        ? null
        : reactionEvent ?? this.reactionEvent,
  );

  PlayerModel get currentPlayer =>
      turnPlayerId == game.host.id ? game.host : game.guest;

  PlayerModel get opponentPlayer =>
      turnPlayerId == game.host.id ? game.guest : game.host;

  PlayerSymbol get currentSymbol => currentPlayer.symbol;

  bool get isBoardFull => !board.contains(null);

  bool get isCpuTurn =>
      game.isComputerGame && currentPlayer.id == game.guest.id;

  bool get canMakeMove => !isBoardFull && !isRoundFinished && !isCpuTurn;

  bool get isFinalRound => currentRound >= game.maxRounds;

  PlayerModel? get gameWinner {
    if (!isFinalRound) {
      return null;
    }

    if (hostPoints > guestPoints) {
      return game.host;
    }

    if (guestPoints > hostPoints) {
      return game.guest;
    }

    return null;
  }

  @override
  List<Object?> get props => [
    game,
    board,
    winningIndexes,
    turnPlayerId,
    currentRound,
    isRoundFinished,
    showRoundAnimation,
    animatedRound,
    hostPoints,
    guestPoints,
    reactionEvent,
  ];
}
