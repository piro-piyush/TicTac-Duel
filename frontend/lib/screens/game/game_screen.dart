import 'package:tictac_duel/lib.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showRoundAnimation = false;
  int _animatedRound = 0;

  @override
  void initState() {
    super.initState();
    final roomSocket = RoomSocketService.instance;
    roomSocket.onPlayerJoined((room) {
      if (!mounted) {
        return;
      }

      context.read<RoomDataProvider>().setRoom(room);
      context.read<MusicProvider>().playJoin();

      if (room.roundStatus == RoundStatus.playing &&
          _animatedRound != room.currentRound) {
        _animatedRound = room.currentRound;

        showRoundAnimation();

        context.read<MusicProvider>().mediumVibration();

        SnackbarUtils.showSuccess(
          context,
          'Round ${room.currentRound} started',
        );
      }
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
      final mySocketId = SocketService.instance.socketId;
      final myPlayer = room.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;
      if (myPlayer == null) {
        return;
      }
      final currentRoom = roomData.room;

      final currentMyPlayer = currentRoom?.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;

      final myReadyChanged = currentMyPlayer?.isReady != myPlayer.isReady;

      // Only update the complete room when my own ready state changed.
      if (myReadyChanged) {
        roomData.setRoom(room);
      }

      final allReady =
          room.players.length == 2 &&
          room.players.every((player) => player.isReady);

      // Both players are ready and the round has started.
      // Both players are ready and the round has started.
      if (room.roundStatus == RoundStatus.playing) {
        roomData.setRoom(room);

        if (_animatedRound != room.currentRound) {
          _animatedRound = room.currentRound;

          showRoundAnimation();

          context.read<MusicProvider>().mediumVibration();

          SnackbarUtils.showSuccess(
            context,
            'Round ${room.currentRound} started',
          );
        }

        return;
      }

      // Only I am ready.
      if (myPlayer.isReady && !allReady) {
        SnackbarUtils.showSuccess(
          context,
          'You are ready. Waiting for opponent...',
        );

        return;
      }

      // I cancelled ready.
      if (!myPlayer.isReady) {
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
          onConfirm: () {
            RoomSocketService.instance.setPlayerReady(roomCode: room.code);
            context.read<RoomDataProvider>().clearBoard();
          },
        );
        return;
      }

      // I won, so calculate the winning line and submit the result.
      final winningIndexes = GameLogicUtils.getWinningIndexes(context);

      roomData.setWinningIndexes(winningIndexes);

      RoomSocketService.instance.submitGameResult(
        roomCode: room.code,
        winnerSocketId: SocketService.instance.socketId,
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
      if (!mounted) {
        return;
      }

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

      // Game is completely finished.
      if (gameFinished) {
        Routes.replaceToResult();
        // GameDialogUtils.showGameFinished(
        //   context: context,
        //   room: room,
        //   mySymbol: myPlayer.symbol,
        //   theme: room.theme,
        // );

        return;
      }

      // Current round finished, but more rounds remain.
      GameDialogUtils.showGameResult(
        context: context,
        result: result,
        theme: room.theme,
        mySymbol: myPlayer.symbol,
        onConfirm: () {
          RoomSocketService.instance.setPlayerReady(roomCode: room.code);
          context.read<RoomDataProvider>().clearBoard();
        },
      );
    });
    roomSocket.onRoomError((message) {
      if (!mounted) {
        return;
      }

      context.read<MusicProvider>().mediumVibration();

      SnackbarUtils.showError(context, message);
    });

    roomSocket.onGameError((message) {
      if (!mounted) {
        return;
      }

      context.read<MusicProvider>().mediumVibration();

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

    final amIReady = room.players
        .where((player) => player.socketId == myWebsocketId)
        .first
        .isReady;

    final showGame =
        room.roundStatus == RoundStatus.playing ||
        (room.roundStatus == RoundStatus.result && !amIReady);

    return NeonBackgroundWidget(
      needScroll: true,
      title: 'Tic Tac Duel',
      child: showGame
          ? Stack(
              alignment: Alignment.center,
              children: [
                _buildGame(room, myWebsocketId, board, winningIndexes),

                IgnorePointer(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 650),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final scale = Tween<double>(begin: 0.82, end: 1.0)
                          .animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          );

                      final slide =
                          Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          );

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slide,
                          child: ScaleTransition(scale: scale, child: child),
                        ),
                      );
                    },
                    child: _showRoundAnimation
                        ? Text(
                            'ROUND ${room.currentRound}',
                            key: ValueKey(room.currentRound),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.5,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 6, color: Themes.neonPurple),
                                Shadow(
                                  blurRadius: 18,
                                  color: Themes.neonPurple,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            )
          : WaitingForPlayersWidget(
              room: room,
              waitingForNextRound: room.currentRound > 0,
            ),
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

  void showRoundAnimation() {
    if (!mounted) {
      return;
    }

    context.read<MusicProvider>().playRoundStart();

    setState(() {
      _showRoundAnimation = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _showRoundAnimation = false;
      });
    });
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
    // roomData.setBoardValue(index, symbol);
    // Give immediate tactile feedback for a valid tap.
    // context.read<MusicProvider>().selectionVibration();
    // Send the move to the server.
    RoomSocketService.instance.makeMove(index: index, roomCode: room.code);
  }
}
