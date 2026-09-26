import 'package:tictac_duel/lib.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _showRoundAnimation = false;
  int _animatedRound = 0;

  @override
  void initState() {
    super.initState();

    final roomSocket = RoomSocketService.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final room = ref.read(roomProvider).room;

      if (room == null) {
        return;
      }

      final mySocketId = SocketService.instance.socketId;

      final myPlayer = room.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;

      if (myPlayer == null || myPlayer.isReady) {
        return;
      }

      roomSocket.setPlayerReady(roomCode: room.code);
    });

    roomSocket.onPlayerJoined((room) {
      if (!mounted) {
        return;
      }

      ref.read(roomProvider.notifier).setRoom(room);
      ref.read(musicProvider.notifier).playJoin();

      if (room.roundStatus == RoundStatus.playing &&
          _animatedRound != room.currentRound) {
        _animatedRound = room.currentRound;
        showRoundAnimation();
      }
    });

    roomSocket.onRoomUpdated((room) {
      if (!mounted) {
        return;
      }

      ref.read(roomProvider.notifier).setRoom(room);
    });

    roomSocket.onPlayerLeft((room) {
      if (!mounted) {
        return;
      }

      ref.read(roomProvider.notifier).setRoom(room);

      SnackbarUtils.showWarning(context, 'Player left the game');
    });

    // Ready status updated.
    roomSocket.onReadyUpdated((room) {
      if (!mounted) {
        return;
      }

      final roomNotifier = ref.read(roomProvider.notifier);
      final currentRoom = ref.read(roomProvider).room;

      final mySocketId = SocketService.instance.socketId;

      final myPlayer = room.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;

      if (myPlayer == null) {
        return;
      }

      final currentMyPlayer = currentRoom?.players
          .where((player) => player.socketId == mySocketId)
          .firstOrNull;

      final myReadyChanged = currentMyPlayer?.isReady != myPlayer.isReady;

      // Only update the complete room when my own ready state changed.
      if (myReadyChanged) {
        roomNotifier.setRoom(room);
      }

      final allReady =
          room.players.length == 2 &&
          room.players.every((player) => player.isReady);

      // Both players are ready and the round has started.
      if (room.roundStatus == RoundStatus.playing) {
        roomNotifier.setRoom(room);

        if (_animatedRound != room.currentRound) {
          _animatedRound = room.currentRound;
          showRoundAnimation();
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
      if (!mounted) {
        return;
      }

      final roomNotifier = ref.read(roomProvider.notifier);

      // Apply the server-confirmed move locally.
      roomNotifier.setBoardValue(index, symbol);
      roomNotifier.updateRoom(room);

      // Do not process results if the round is already finished.
      if (room.roundStatus != RoundStatus.playing) {
        return;
      }

      final mySocketId = SocketService.instance.socketId;

      final myPlayer = room.players.firstWhere(
        (player) => player.socketId == mySocketId,
      );

      final mySymbol = myPlayer.symbol;

      // Check the result for every confirmed move.
      final result = GameLogicUtils.checkWinner(ref.read(roomProvider).board);

      // Round is still active.
      if (!result.isFinished) {
        return;
      }

      // --------------------------------------------------
      // DRAW
      // --------------------------------------------------

      if (result == GameResult.draw) {
        RoomSocketService.instance.submitGameResult(
          roomCode: room.code,
          winnerSocketId: null,
          winningIndexes: const [],
        );

        return;
      }

      // --------------------------------------------------
      // WIN
      // --------------------------------------------------

      // Only the player who made the winning move submits
      // the result.
      if (symbol != mySymbol) {
        return;
      }

      final winningIndexes = GameLogicUtils.getWinningIndexes(
        ref.read(roomProvider).board,
      );

      roomNotifier.setWinningIndexes(winningIndexes);

      RoomSocketService.instance.submitGameResult(
        roomCode: room.code,
        winnerSocketId: mySocketId,
        winningIndexes: winningIndexes.toList(),
      );

      // round_result will be received by both players.
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

      final roomNotifier = ref.read(roomProvider.notifier);

      roomNotifier.updateRoom(room);
      roomNotifier.setWinningIndexes(winningIndexes.toSet());

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

          roomNotifier.clearBoard();
        },
      );
    });

    roomSocket.onRoomError((message) {
      if (!mounted) {
        return;
      }

      ref.read(musicProvider.notifier).mediumVibration();

      SnackbarUtils.showError(context, message);
    });

    roomSocket.onGameError((message) {
      if (!mounted) {
        return;
      }

      ref.read(musicProvider.notifier).mediumVibration();

      SnackbarUtils.showError(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);

    final room = roomState.room;
    final board = roomState.board;
    final winningIndexes = roomState.winningIndexes;

    final myWebsocketId = SocketService.instance.socketId;

    if (room == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Room not found',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
                                Shadow(
                                  blurRadius: 6,
                                  color: AppColors.neonPurple,
                                ),
                                Shadow(
                                  blurRadius: 18,
                                  color: AppColors.neonPurple,
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

    ref.read(musicProvider.notifier).playRoundStart();

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
    final roomState = ref.read(roomProvider);

    // Ignore already occupied cells.
    if (roomState.board[index] != null) {
      return;
    }

    // Send the move to the server.
    RoomSocketService.instance.makeMove(index: index, roomCode: room.code);
  }
}
