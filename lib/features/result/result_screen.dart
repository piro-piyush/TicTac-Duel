import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.result});

  final ResultModel result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resultProvider(result));
    final notifier = ref.read(resultProvider(result).notifier);

    if (state.showConfetti) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        _showConfetti(context);
        notifier.dismissConfetti();
      });
    }

    return NeonBackgroundWidget(
      needScroll: false,
      bottomNavigationBar: ResultActionsWidget(isOnline: state.isOnline),
      child: _buildContent(context, state, notifier),
    );
  }

  // ===========================================================================
  // CONTENT
  // ===========================================================================

  Widget _buildContent(
    BuildContext context,
    ResultModel state,
    ResultNotifier notifier,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Dimens.spaceBtwSections,
      children: [
        Column(
          spacing: Dimens.spaceBtwSections,
          children: [
            _buildResultAnimation(state),
            _buildResultHeader(context, state),
          ],
        ),
        ResultScoreCardWidget(
          state: state,
          isPlayerOneMe: notifier.isMe(state.playerOne),
          isPlayerTwoMe: notifier.isMe(state.playerTwo),
          isOnline: state.isOnline,
        ),
        _buildRoundLabel(context, state),
      ],
    );
  }

  // ===========================================================================
  // RESULT ANIMATION
  // ===========================================================================

  Widget _buildResultAnimation(ResultModel state) {
    if (state.isDraw) {
      return const Icon(
        Icons.handshake_rounded,
        color: AppColors.neonCyan,
        size: Dimens.oneHundred,
      );
    }

    return Lottie.asset(
      state.hasWon
          ? AnimationConstants.trophyAnimation
          : AnimationConstants.loseAnimation,
      width: Dimens.oneHundred,
      height: Dimens.oneHundred,
      repeat: !state.hasWon,
    );
  }

  // ===========================================================================
  // RESULT HEADER
  // ===========================================================================

  Widget _buildResultHeader(BuildContext context, ResultModel state) {
    final winner = state.gameWinner;

    if (!state.isDraw && winner == null) {
      return const SizedBox.shrink();
    }

    final String title;
    final String message;

    if (state.isDraw) {
      title = 'IT\'S A DRAW!';
      message = 'No winner this time. Great game!';
    } else if (state.isDismissed) {
      title = state.hasWon ? 'YOU WON!' : 'YOU LOSE';
      message = state.dismissReason?.message ?? 'The game has ended.';
    } else if (state.isLocal) {
      title = '${winner!.name.toUpperCase()} WINS!';
      message = 'Congratulations, ${winner.name}! Great game.';
    } else if (state.hasWon) {
      title = 'YOU WON!';
      message = 'Congratulations! You played a great game.';
    } else {
      title = 'YOU LOSE';
      message = '${winner!.name} takes the win. Better luck next time!';
    }

    return Column(
      spacing: Dimens.eight,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // ===========================================================================
  // ROUND
  // ===========================================================================

  Widget _buildRoundLabel(BuildContext context, ResultModel state) {
    return Text(
      'ROUND ${state.currentRound} / ${state.maxRounds}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  // ===========================================================================
  // CONFETTI
  // ===========================================================================

  void _showConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.55),
    );
  }
}
