import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _playResultFeedback();
    });
  }

  void _playResultFeedback() {
    final room = context.read<RoomDataProvider>().room;

    if (room == null || room.players.length < 2) {
      return;
    }

    final players = room.players;
    final playerOne = players[0];
    final playerTwo = players[1];

    final isDraw = playerOne.points == playerTwo.points;

    if (isDraw) {
      context.read<MusicProvider>().mediumVibration();
      return;
    }

    final gameWinner = playerOne.points > playerTwo.points
        ? playerOne
        : playerTwo;

    final mySocketId = SocketService.instance.socketId;
    final hasWon = gameWinner.socketId == mySocketId;

    final musicProvider = context.read<MusicProvider>();

    if (hasWon) {
      musicProvider.playWin();
      _showConfetti();
    } else {
      musicProvider.playLose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomDataProvider>().room;

    if (room == null || room.players.length < 2) {
      return const SizedBox.shrink();
    }

    final players = room.players;

    final playerOne = players[0];
    final playerTwo = players[1];

    // final isDraw = playerOne.points == playerTwo.points;

    final gameWinner = playerOne.points > playerTwo.points
        ? playerOne
        : playerTwo;

    final mySocketId = SocketService.instance.socketId;

    final myPlayer = players.firstWhere(
      (player) => player.socketId == mySocketId,
    );

    final hasWon = gameWinner.socketId == myPlayer.socketId;

    return NeonBackgroundWidget(
      needScroll: false,
      title: 'Game Result',
      child: _buildContent(
        room: room,
        playerOne: playerOne,
        playerTwo: playerTwo,
        gameWinner: gameWinner,
        myPlayer: myPlayer,
        hasWon: hasWon,
      ),
    );
  }

  void _showConfetti() {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.55),
    );
  }

  Widget _buildContent({
    required RoomModel room,
    required PlayerModel playerOne,
    required PlayerModel playerTwo,
    required PlayerModel? gameWinner,
    required PlayerModel myPlayer,
    required bool hasWon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResultIcon(hasWon: hasWon),
          const SizedBox(height: 24),
          _buildTitle(hasWon: hasWon),
          const SizedBox(height: 8),
          Text(
            '${gameWinner!.name} wins the game!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Themes.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 32),
          _buildScoreCard(
            playerOne: playerOne,
            playerTwo: playerTwo,
            winner: gameWinner,
          ),
          const SizedBox(height: 24),
          Text(
            'ROUND ${room.currentRound} / ${room.maxRounds}',
            style: const TextStyle(
              color: Themes.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildResultIcon({required bool hasWon}) {
    return Lottie.asset(
      hasWon
          ? AnimationConstants.trophyAnimation
          : AnimationConstants.loseAnimation,
      width: 110,
      height: 110,
      repeat: hasWon ? false : true,
    );
  }

  Widget _buildTitle({required bool hasWon}) {
    final title = hasWon ? 'YOU WON!' : 'YOU LOSE';

    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Themes.textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildScoreCard({
    required PlayerModel playerOne,
    required PlayerModel playerTwo,
    required PlayerModel? winner,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Themes.border),
      ),
      child: Column(
        children: [
          _buildPlayerScore(player: playerOne, winner: winner),
          const SizedBox(height: 14),
          const Divider(color: Themes.border, height: 1),
          const SizedBox(height: 14),
          _buildPlayerScore(player: playerTwo, winner: winner),
        ],
      ),
    );
  }

  Widget _buildPlayerScore({
    required PlayerModel player,
    required PlayerModel? winner,
  }) {
    final isWinner = winner?.socketId == player.socketId;

    final isMe = player.socketId == SocketService.instance.socketId;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (isWinner) ...[
                const Icon(
                  Icons.emoji_events_rounded,
                  color: Themes.neonPurple,
                  size: 18,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  isMe ? '${player.name} (You)' : player.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isWinner ? Themes.textPrimary : Themes.textSecondary,
                    fontWeight: isWinner ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          '${player.points}',
          style: const TextStyle(
            color: Themes.neonCyan,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: NeonOutlinedButtonWidget(label: 'HOME', onPressed: _goHome),
        ),
        Expanded(
          child: NeonElevatedButton(label: 'NEW GAME', onPressed: _newGame),
        ),
      ],
    );
  }

  void _goHome() {
    _clearRoom();
    Routes.goToHome();
  }

  void _newGame() {
    _clearRoom();
    Routes.goToCreateRoom();
  }

  void _clearRoom() {
    context.read<RoomDataProvider>().clearRoom();
  }
}
