import 'package:tictac_duel/lib.dart';

class ResultNotifier extends Notifier<ResultState> {
  @override
  ResultState build() {
    final room = ref.watch(roomProvider).room;

    if (room == null || room.players.length < 2) {
      return const ResultState();
    }

    final playerOne = room.players[0];
    final playerTwo = room.players[1];

    final isDraw = playerOne.points == playerTwo.points;

    final gameWinner = isDraw
        ? null
        : playerOne.points > playerTwo.points
        ? playerOne
        : playerTwo;

    final mySocketId = SocketService.instance.socketId;

    final myPlayer = room.players.cast<PlayerModel?>().firstWhere(
      (player) => player?.socketId == mySocketId,
      orElse: () => null,
    );

    final hasWon = gameWinner != null && gameWinner.socketId == mySocketId;

    return ResultState(
      room: room,
      playerOne: playerOne,
      playerTwo: playerTwo,
      gameWinner: gameWinner,
      myPlayer: myPlayer,
      isDraw: isDraw,
      hasWon: hasWon,
    );
  }

  void playResultFeedback() {
    if (!state.isValid) {
      return;
    }

    if (state.isDraw) {
      ref.read(musicProvider.notifier).mediumVibration();
      return;
    }

    if (state.hasWon) {
      ref.read(musicProvider.notifier).playWin();

      state = state.copyWith(showConfetti: true);
      return;
    }

    ref.read(musicProvider.notifier).playLose();
  }

  void dismissConfetti() {
    state = state.copyWith(showConfetti: false);
  }

  void goHome() {
    ref.read(roomProvider.notifier).clearRoom();
    Routes.goToHome();
  }

  void newGame() {
    ref.read(roomProvider.notifier).clearRoom();
    Routes.goToCreateRoom();
  }
}

final resultProvider = NotifierProvider<ResultNotifier, ResultState>(
  ResultNotifier.new,
);
