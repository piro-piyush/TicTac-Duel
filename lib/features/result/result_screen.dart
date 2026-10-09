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
      bottomNavigationBar: ResultActionsWidget(isOnline: state.isOnline)
          .animate()
          .fadeIn(
            delay: AnimationConstants.staggerMedium,
            duration: AnimationConstants.medium,
          )
          .slideY(
            begin: AnimationConstants.slideSmall,
            end: 0,
            delay: AnimationConstants.staggerMedium,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.entranceCurve,
          ),
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
            _buildResultAnimation(state)
                .animate()
                .fadeIn(
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                )
                .scale(
                  begin: const Offset(
                    AnimationConstants.scaleSmall,
                    AnimationConstants.scaleSmall,
                  ),
                  end: const Offset(
                    AnimationConstants.scaleNormal,
                    AnimationConstants.scaleNormal,
                  ),
                  duration: AnimationConstants.long,
                  curve: AnimationConstants.entranceCurve,
                ),

            _buildResultHeader(context, state)
                .animate()
                .fadeIn(
                  delay: AnimationConstants.staggerShort,
                  duration: AnimationConstants.medium,
                )
                .slideY(
                  begin: AnimationConstants.slideSmall,
                  end: 0,
                  delay: AnimationConstants.staggerShort,
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                ),
          ],
        ),

        ResultScoreCardWidget(
              state: state,
              isPlayerOneMe: notifier.isMe(state.host),
              isPlayerTwoMe: notifier.isMe(state.guest),
              isOnline: state.isOnline,
            )
            .animate()
            .fadeIn(
              delay: AnimationConstants.staggerMedium,
              duration: AnimationConstants.medium,
            )
            .slideY(
              begin: AnimationConstants.slideSmall,
              end: 0,
              delay: AnimationConstants.staggerMedium,
              duration: AnimationConstants.medium,
              curve: AnimationConstants.entranceCurve,
            ),

        _buildRoundLabel(context, state)
            .animate()
            .fadeIn(
              delay: AnimationConstants.staggerLong,
              duration: AnimationConstants.medium,
            )
            .slideY(
              begin: AnimationConstants.slideSmall,
              end: 0,
              delay: AnimationConstants.staggerLong,
              duration: AnimationConstants.medium,
              curve: AnimationConstants.entranceCurve,
            ),
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
      message = state.dismissReason?.subtitle ?? 'The game has ended.';
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
