import 'package:tictac_duel/lib.dart';

class ResultModel{
  const ResultModel({
    this.room,
    this.playerOne,
    this.playerTwo,
    this.gameWinner,
    this.hasWon = false,
    this.isDraw = false,
    this.showConfetti = false,
  });

  final RoomModel? room;
  final PlayerModel? playerOne;
  final PlayerModel? playerTwo;
  final PlayerModel? gameWinner;

  final bool hasWon;
  final bool isDraw;
  final bool showConfetti;

  bool get isValid {
    return room != null && playerOne != null && playerTwo != null;
  }

  ResultModel copyWith({
    RoomModel? room,
    PlayerModel? playerOne,
    PlayerModel? playerTwo,
    PlayerModel? gameWinner,
    bool? hasWon,
    bool? isDraw,
    bool? showConfetti,
  }) {
    return ResultModel(
      room: room ?? this.room,
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      gameWinner: gameWinner ?? this.gameWinner,
      hasWon: hasWon ?? this.hasWon,
      isDraw: isDraw ?? this.isDraw,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}
