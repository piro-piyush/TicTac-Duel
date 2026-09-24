import 'package:tictac_duel/lib.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();

    final roomSocket = RoomSocketService.instance;

    roomSocket.onPlayerJoined((room) {
      if (!mounted) {
        return;
      }

      context.read<RoomDataProvider>().setRoom(room);

      MusicAndFeedbackService.instance.mediumVibration();

      SnackbarUtils.showSuccess(context, 'Player joined the game');
    });

    roomSocket.onRoomUpdated((room) {
      if (!mounted) {
        return;
      }

      context.read<RoomDataProvider>().setRoom(room);
    });

    roomSocket.onPlayerLeft((room) {
      if (!mounted) {
        return;
      }

      context.read<RoomDataProvider>().setRoom(room);

      SnackbarUtils.showWarning(context, 'Player left the game');
    });

    // Ready status updated.
    roomSocket.onReadyUpdated((room) {
      if (!mounted) {
        return;
      }

      final roomData = context.read<RoomDataProvider>();

      roomData.setRoom(room);

      final mySocketId = SocketService.instance.socketId;

      final myPlayer = room.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;

      final allReady =
          room.players.length == 2 &&
          room.players.every((player) => player.isReady);

      // Both players are ready and the round has started.
      if (room.roundStatus == RoundStatus.playing) {
        MusicAndFeedbackService.instance.mediumVibration();

        SnackbarUtils.showSuccess(
          context,
          'Round ${room.currentRound} started',
        );

        return;
      }

      // Only one player is ready.
      if (myPlayer?.isReady == true && !allReady) {
        SnackbarUtils.showSuccess(
          context,
          'You are ready. Waiting for opponent...',
        );

        return;
      }

      // Player cancelled ready.
      if (myPlayer?.isReady == false) {
        return;
      }
    });

    roomSocket.onMoveMade(({
      required RoomModel room,
      required int index,
      required PlayerSymbol symbol,
    }) {
      if (!mounted) return;

      final roomData = context.read<RoomDataProvider>();

      // Always apply the confirmed move locally.
      roomData.setBoardValue(index, symbol);
      roomData.updateRoom(room);

      final mySymbol = room.players
          .firstWhere(
            (player) => player.socketId == SocketService.instance.socketId,
          )
          .symbol;

      // Opponent's move: just update the board.
      if (symbol != mySymbol) {
        return;
      }

      // This was MY confirmed move.
      final result = GameLogicUtils.checkWinner(context);

      if (!result.isFinished) {
        return;
      }

      // Draw: no winner needs to submit anything.
      // Show the draw dialog locally.
      if (result == GameResult.draw) {
        context.read<RoomDataProvider>().clearBoard();
        GameDialogUtils.showGameResult(
          context: context,
          result: result,
          theme: room.theme,
          mySymbol: mySymbol,
        );
        return;
      }

      // I won, so calculate the winning line and submit the result.
      final winningIndexes = GameLogicUtils.getWinningIndexes(context);

      roomData.setWinningIndexes(winningIndexes);

      RoomSocketService.instance.submitGameResult(
        roomCode: room.code,
        winnerSocketId: SocketService.instance.socketId!,
        winningIndexes: winningIndexes.toList(),
      );

      // Do NOT show win dialog here.
      // round_result will be received by both players
      // and will show You Won / You Lose.
    });

    roomSocket.onRoundResult(({
      required RoomModel room,
      required String winnerSocketId,
      required List<int> winningIndexes,
      required int completedRound,
      required bool gameFinished,
    }) {
      if (!mounted) return;

      final roomData = context.read<RoomDataProvider>();

      roomData.updateRoom(room);
      roomData.setWinningIndexes(winningIndexes.toSet());

      final mySocketId = SocketService.instance.socketId;

      final winner = room.players.firstWhere(
        (player) => player.socketId == winnerSocketId,
      );

      final myPlayer = room.players.firstWhere(
        (player) => player.socketId == mySocketId,
      );

      final result = winner.symbol == PlayerSymbol.x
          ? GameResult.xWins
          : GameResult.oWins;

      // Clear the board and
      context.read<RoomDataProvider>().clearBoard();
      GameDialogUtils.showGameResult(
        context: context,
        result: result,
        theme: room.theme,
        mySymbol: myPlayer.symbol,
      );
    });

    roomSocket.onRoomError((message) {
      if (!mounted) {
        return;
      }

      MusicAndFeedbackService.instance.mediumVibration();

      SnackbarUtils.showError(context, message);
    });

    roomSocket.onGameError((message) {
      if (!mounted) {
        return;
      }

      MusicAndFeedbackService.instance.mediumVibration();

      SnackbarUtils.showError(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomDataProvider>().room;
    final board = context.watch<RoomDataProvider>().board;
    final myWebsocketId = SocketService.instance.socketId;
    final winningIndexes = context.watch<RoomDataProvider>().winningIndexes;
    if (room == null) {
      return const Scaffold(
        backgroundColor: Themes.background,
        body: Center(
          child: Text(
            'Room not found',
            style: TextStyle(color: Themes.textSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return NeonBackgroundWidget(
      needScroll: true,
      title: 'Tic Tac Duel',
      child: switch (room.roundStatus) {
        RoundStatus.waiting => WaitingForPlayersWidget(
          room: room,
          waitingForNextRound: false,
        ),

        RoundStatus.playing => _buildGame(
          room,
          myWebsocketId,
          board,
          winningIndexes,
        ),

        RoundStatus.result => WaitingForPlayersWidget(
          room: room,
          waitingForNextRound: true,
        ),
      },
    );
  }

  Widget _buildGame(
    RoomModel room,
    String? myWebsocketId,
    List<PlayerSymbol?> board,
    Set<int> winningIndexes,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 380;
        final isWide = width >= 600;

        final horizontalPadding = isCompact ? 4.0 : 12.0;
        final sectionSpacing = isCompact ? 12.0 : 18.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            16,
          ),
          child: Column(
            children: [
              GameRoundIndicatorWidget(room: room, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildPlayers(room, myWebsocketId, compact: isCompact),
              SizedBox(height: sectionSpacing),
              _buildBoard(
                room,
                board,
                winningIndexes,
                isWide: isWide,
                isMyTurn: room.turn?.socketId == myWebsocketId,
              ),
              SizedBox(height: sectionSpacing),
              GameStatusWidget(
                room: room,
                webSocketId: myWebsocketId,
                compact: isCompact,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayers(
    RoomModel room,
    String? myWebsocketId, {
    required bool compact,
  }) {
    return Row(
      spacing: compact ? 6 : 10,
      children: [
        Expanded(
          child: GamePlayerCardWidget(
            webSocketId: myWebsocketId,
            player: room.players[0],
            isTurn: room.turnIndex == 0,
            theme: room.theme,
            compact: compact,
            isMe: myWebsocketId == room.players[0].socketId,
          ),
        ),
        VersusWidget(compact: compact),
        Expanded(
          child: GamePlayerCardWidget(
            webSocketId: myWebsocketId,
            player: room.players[1],
            isTurn: room.turnIndex == 1,
            theme: room.theme,
            compact: compact,
            isMe: myWebsocketId == room.players[1].socketId,
          ),
        ),
      ],
    );
  }

  Widget _buildBoard(
    RoomModel room,
    List<PlayerSymbol?> values,
    Set<int> winningIndexes, {
    required bool isWide,
    required bool isMyTurn,
  }) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 460 : 420),
        child: GameBoardWidget(
          roomTheme: room.theme,
          onCellTap: (index) => _handleCellTap(index, room),
          values: values,
          isMyTurn: isMyTurn,
          winningIndexes: winningIndexes,
        ),
      ),
    );
  }

  void _handleCellTap(int index, RoomModel room) {
    final roomData = context.read<RoomDataProvider>();

    // Ignore already occupied cells.
    if (roomData.getBoardValue(index) != null) {
      return;
    }

    // Give immediate tactile feedback for a valid tap.
    MusicAndFeedbackService.instance.selectionVibration();

    // Send the move to the server.
    RoomSocketService.instance.makeMove(index: index, roomCode: room.code);
  }
}
