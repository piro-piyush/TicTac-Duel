import 'package:tictac_duel/lib.dart';

class ResultState extends Equatable {
  const ResultState({
    this.room,
    this.playerOne,
    this.playerTwo,
    this.gameWinner,
    this.myPlayer,
    this.isDraw = false,
    this.hasWon = false,
    this.showConfetti = false,
  });

  final RoomModel? room;
  final PlayerModel? playerOne;
  final PlayerModel? playerTwo;
  final PlayerModel? gameWinner;
  final PlayerModel? myPlayer;

  final bool isDraw;
  final bool hasWon;
  final bool showConfetti;

  bool get isValid =>
      room != null &&
      playerOne != null &&
      playerTwo != null &&
      myPlayer != null;

  ResultState copyWith({
    RoomModel? room,
    PlayerModel? playerOne,
    PlayerModel? playerTwo,
    PlayerModel? gameWinner,
    PlayerModel? myPlayer,
    bool? isDraw,
    bool? hasWon,
    bool? showConfetti,
  }) {
    return ResultState(
      room: room ?? this.room,
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      gameWinner: gameWinner ?? this.gameWinner,
      myPlayer: myPlayer ?? this.myPlayer,
      isDraw: isDraw ?? this.isDraw,
      hasWon: hasWon ?? this.hasWon,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }

  @override
  List<Object?> get props => [
    room,
    playerOne,
    playerTwo,
    gameWinner,
    myPlayer,
    isDraw,
    hasWon,
    showConfetti,
  ];
}
