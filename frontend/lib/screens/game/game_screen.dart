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

      final allReady = room.players.length == 2 &&
          room.players.every((player) => player.isReady);

      // Both players are ready and the next round has started.
      if (room.isPlaying) {
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
      child: !room.isPlaying
          ? WaitingForPlayersWidget(room: room)
          : _buildGame(room, myWebsocketId, board, winningIndexes),
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
              _buildRoundIndicator(room, compact: isCompact),
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
              _buildGameStatus(room, myWebsocketId, compact: isCompact),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoundIndicator(RoomModel room, {required bool compact}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 14,
        vertical: compact ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: room.theme.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 7,
        children: [
          Icon(
            Icons.sports_esports_outlined,
            color: room.theme.primary,
            size: compact ? 14 : 15,
          ),
          Text(
            'ROUND ${room.currentRound}',
            style: TextStyle(
              color: room.theme.primary,
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          Text(
            '/',
            style: TextStyle(
              color: Themes.textSecondary.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
          Text(
            '${room.maxRounds}',
            style: const TextStyle(
              color: Themes.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
          child: _buildPlayerCard(
            webSocketId: myWebsocketId,
            player: room.players[0],
            isTurn: room.turnIndex == 0,
            theme: room.theme,
            compact: compact,
            isMe: myWebsocketId == room.players[0].socketId,
          ),
        ),
        _buildVersus(compact: compact),
        Expanded(
          child: _buildPlayerCard(
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

  Widget _buildPlayerCard({
    required PlayerModel player,
    required String? webSocketId,
    required bool isMe,
    required bool isTurn,
    required RoomTheme theme,
    required bool compact,
  }) {
    final color = player.symbol == PlayerSymbol.x
        ? theme.primary
        : theme.secondary;

    final avatarSize = compact ? 40.0 : 48.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: isTurn ? color.withValues(alpha: 0.07) : Themes.surface,
        borderRadius: BorderRadius.circular(compact ? 13 : 16),
        border: Border.all(
          color: isTurn ? color.withValues(alpha: 0.55) : Themes.border,
          width: isTurn ? 1.5 : 1,
        ),
        boxShadow: isTurn
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.10),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        spacing: compact ? 6 : 9,
        children: [
          PlayerAvatarWidget(
            player: player,
            isMe: isMe,
            isTurn: isTurn,
            size: avatarSize,
          ),
          Expanded(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Flexible(
                      child: Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Themes.textPrimary,
                          fontSize: compact ? 10 : 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 4 : 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? color.withValues(alpha: 0.12)
                            : Themes.card,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isMe
                              ? color.withValues(alpha: 0.25)
                              : Themes.border,
                        ),
                      ),
                      child: Text(
                        isMe ? 'YOU' : 'OPPONENT',
                        style: TextStyle(
                          color: isMe ? color : Themes.textSecondary,
                          fontSize: compact ? 6 : 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      player.symbol.value.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: compact ? 8 : 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (isTurn)
                      Flexible(
                        child: Text(
                          'TURN',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color.withValues(alpha: 0.8),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersus({required bool compact}) {
    final size = compact ? 24.0 : 28.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Themes.card,
        shape: BoxShape.circle,
        border: Border.all(color: Themes.border),
      ),
      child: Center(
        child: Text(
          'VS',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: compact ? 7 : 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
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

  Widget _buildGameStatus(
    RoomModel room,
    String? webSocketId, {
    required bool compact,
  }) {
    final player = room.turn;
    if (player == null) {
      return const SizedBox.shrink();
    }
    final isMyTurn = player.socketId == webSocketId;
    final color = player.symbol == PlayerSymbol.x
        ? room.theme.primary
        : room.theme.secondary;
    final text = isMyTurn ? 'Your turn' : '${player.name}\'s turn';
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 7),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: compact ? 9 : 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
