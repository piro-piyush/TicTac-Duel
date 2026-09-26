import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state;

      if (!state.isValid) {
        return const SizedBox.shrink();
      }

      if (state.showConfetti) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }

          _showConfetti(context);
          controller.dismissConfetti();
        });
      }

      return NeonBackgroundWidget(
        needScroll: false,
        title: 'Game Result',
        child: _buildContent(state),
      );
    });
  }

  Widget _buildContent(ResultModel state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResultIcon(hasWon: state.hasWon),
          const SizedBox(height: 24),
          _buildTitle(hasWon: state.hasWon),
          const SizedBox(height: 8),
          Text(
            state.isDraw
                ? 'The game ended in a draw!'
                : '${state.gameWinner!.name} wins the game!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 32),
          _buildScoreCard(
            playerOne: state.playerOne!,
            playerTwo: state.playerTwo!,
            winner: state.gameWinner,
          ),
          const SizedBox(height: 24),
          Text(
            'ROUND ${state.room!.currentRound} / ${state.room!.maxRounds}',
            style: const TextStyle(
              color: AppColors.textSecondary,
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
      repeat: !hasWon,
    );
  }

  Widget _buildTitle({required bool hasWon}) {
    return Text(
      hasWon ? 'YOU WON!' : 'YOU LOSE',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.textPrimary,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildPlayerScore(player: playerOne, winner: winner),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
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
    final isWinner = controller.isWinner(player);
    final isMe = controller.isMe(player);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (isWinner) ...[
                const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.neonPurple,
                  size: 18,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  isMe ? '${player.name} (You)' : player.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isWinner
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
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
            color: AppColors.neonCyan,
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
          child: NeonOutlinedButtonWidget(
            label: 'HOME',
            onPressed: controller.goHome,
          ),
        ),
        Expanded(
          child: NeonElevatedButton(
            label: 'NEW GAME',
            onPressed: controller.newGame,
          ),
        ),
      ],
    );
  }

  void _showConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.55),
    );
  }
}
