import 'package:tictac_duel/lib.dart';

class ResultModel {
  const ResultModel._({
    required this.playerOne,
    required this.playerTwo,
    required this.playerOnePoints,
    required this.playerTwoPoints,
    required this.currentRound,
    required this.maxRounds,
    required this.isOnline,
    required this.theme,
    this.gameWinner,
    this.hasWon = false,
    this.isDraw = false,
    this.showConfetti = false,
    this.dismissReason,
  });

  const ResultModel.completed({
    required PlayerModel playerOne,
    required PlayerModel playerTwo,
    required int playerOnePoints,
    required int playerTwoPoints,
    required int currentRound,
    required int maxRounds,
    required bool isOnline,
    required RoomTheme theme,
    PlayerModel? gameWinner,
    bool hasWon = false,
    bool isDraw = false,
    bool showConfetti = false,
  }) : this._(
         playerOne: playerOne,
         playerTwo: playerTwo,
         playerOnePoints: playerOnePoints,
         playerTwoPoints: playerTwoPoints,
         currentRound: currentRound,
         maxRounds: maxRounds,
         isOnline: isOnline,
         gameWinner: gameWinner,
         hasWon: hasWon,
         isDraw: isDraw,
         showConfetti: showConfetti,
         theme: theme,
       );

  const ResultModel.dismissed({
    required PlayerModel playerOne,
    required PlayerModel playerTwo,
    required int playerOnePoints,
    required int playerTwoPoints,
    required int currentRound,
    required int maxRounds,
    required bool isOnline,
    required RoomTheme theme,
    required PlayerModel gameWinner,
    required GameDismissReason dismissReason,
  }) : this._(
         playerOne: playerOne,
         playerTwo: playerTwo,
         playerOnePoints: playerOnePoints,
         playerTwoPoints: playerTwoPoints,
         currentRound: currentRound,
         maxRounds: maxRounds,
         isOnline: isOnline,
         gameWinner: gameWinner,
         hasWon: true,
         dismissReason: dismissReason,
         theme: theme,
       );

  final PlayerModel playerOne;
  final PlayerModel playerTwo;

  final int playerOnePoints;
  final int playerTwoPoints;

  final int currentRound;
  final int maxRounds;

  final PlayerModel? gameWinner;
  final RoomTheme theme;
  final bool hasWon;
  final bool isDraw;
  final bool showConfetti;

  final bool isOnline;

  final GameDismissReason? dismissReason;

  bool get isLocal => !isOnline;

  bool get isDismissed => dismissReason != null;

  bool get isCompleted => dismissReason == null;

  ResultModel copyWith({
    PlayerModel? playerOne,
    PlayerModel? playerTwo,
    int? playerOnePoints,
    int? playerTwoPoints,
    int? currentRound,
    int? maxRounds,
    PlayerModel? gameWinner,
    bool? hasWon,
    bool? isDraw,
    bool? showConfetti,
    bool? isOnline,
    GameDismissReason? dismissReason,
    RoomTheme? theme,
  }) {
    return ResultModel._(
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      playerOnePoints: playerOnePoints ?? this.playerOnePoints,
      playerTwoPoints: playerTwoPoints ?? this.playerTwoPoints,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      isOnline: isOnline ?? this.isOnline,
      gameWinner: gameWinner ?? this.gameWinner,
      hasWon: hasWon ?? this.hasWon,
      isDraw: isDraw ?? this.isDraw,
      showConfetti: showConfetti ?? this.showConfetti,
      dismissReason: dismissReason ?? this.dismissReason,
      theme: theme ?? this.theme,
    );
  }

  @override
  String toString() {
    return 'ResultModel('
        'playerOne: ${playerOne.id} (${playerOne.name}), '
        'playerTwo: ${playerTwo.id} (${playerTwo.name}), '
        'playerOnePoints: $playerOnePoints, '
        'playerTwoPoints: $playerTwoPoints, '
        'currentRound: $currentRound, '
        'maxRounds: $maxRounds, '
        'gameWinner: ${gameWinner?.id} (${gameWinner?.name}), '
        'hasWon: $hasWon, '
        'isDraw: $isDraw, '
        'showConfetti: $showConfetti, '
        'isOnline: $isOnline, '
        'dismissReason: $dismissReason, '
        'theme: $theme'
        ')';
  }
}
