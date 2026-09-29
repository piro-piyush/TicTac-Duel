import 'package:tictac_duel/lib.dart';

class ResultModel {
  const ResultModel({
    required this.playerOne,
    required this.playerTwo,
    required this.playerOnePoints,
    required this.playerTwoPoints,
    required this.currentRound,
    required this.maxRounds,
    this.gameWinner,
    this.hasWon = false,
    this.isDraw = false,
    this.showConfetti = false,
  }) : isOnline = false;

  final PlayerModel playerOne;
  final PlayerModel playerTwo;

  final int playerOnePoints;
  final int playerTwoPoints;

  final int currentRound;
  final int maxRounds;

  final PlayerModel? gameWinner;

  final bool hasWon;
  final bool isDraw;
  final bool showConfetti;

  final bool isOnline;

  bool get isLocal => !isOnline;

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
  }) {
    return ResultModel(
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      playerOnePoints: playerOnePoints ?? this.playerOnePoints,
      playerTwoPoints: playerTwoPoints ?? this.playerTwoPoints,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      gameWinner: gameWinner ?? this.gameWinner,
      hasWon: hasWon ?? this.hasWon,
      isDraw: isDraw ?? this.isDraw,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}
