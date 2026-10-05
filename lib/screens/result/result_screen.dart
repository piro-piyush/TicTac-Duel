import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state;

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
        bottomNavigationBar: ResultActionsWidget(isOnline: state.isOnline),
        child: _buildContent(context, state),
      );
    });
  }

  // ===========================================================================
  // CONTENT
  // ===========================================================================

  Widget _buildContent(BuildContext context, ResultModel state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Dimens.spaceBtwSections,
      children: [
        Column(
          spacing: Dimens.spaceBtwSections,
          children: [
            _buildResultIcon(hasWon: state.hasWon, isDraw: state.isDraw),
            _buildResultHeader(context, state),
          ],
        ),
        ResultScoreCardWidget(
          state: state,
          isPlayerOneMe: state.playerOne.id == GameConstants.localPlayerOneId,
          isPlayerTwoMe: state.playerTwo.id == GameConstants.localPlayerOneId,
          isOnline: state.isOnline,
        ),
        Text(
          'ROUND ${state.currentRound} / ${state.maxRounds}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // ===========================================================================
  // RESULT ICON
  // ===========================================================================

  Widget _buildResultIcon({required bool hasWon, required bool isDraw}) {
    if (isDraw) {
      return const Icon(
        Icons.handshake_rounded,
        color: AppColors.neonCyan,
        size: Dimens.oneHundred,
      );
    }

    return Lottie.asset(
      hasWon
          ? AnimationConstants.trophyAnimation
          : AnimationConstants.loseAnimation,
      width: Dimens.oneHundred,
      height: Dimens.oneHundred,
      repeat: !hasWon,
    );
  }

  // ===========================================================================
  // RESULT HEADER
  // ===========================================================================

  Widget _buildResultHeader(BuildContext context, ResultModel state) {
    final String title;
    final String message;

    if (state.isDraw) {
      title = 'DRAW';
      message = 'The game ended in a draw.';
    } else if (state.isDismissed) {
      final winner = state.gameWinner;

      if (winner == null || state.dismissReason == null) {
        return const SizedBox.shrink();
      }

      title = state.hasWon ? 'YOU WON!' : 'YOU LOSE';
      message = state.dismissReason!.message;
    } else if (state.isLocal) {
      final winner = state.gameWinner;

      if (winner == null) {
        return const SizedBox.shrink();
      }

      final isPlayerOneWinner = winner.id == state.playerOne.id;

      title = isPlayerOneWinner ? 'YOU WON!' : 'YOU LOSE';
      message = '${winner.name} wins the game.';
    } else {
      final winner = state.gameWinner;

      if (winner == null) {
        return const SizedBox.shrink();
      }

      title = state.hasWon ? 'YOU WON!' : 'YOU LOSE';
      message = state.hasWon
          ? 'Congratulations! You won the game.'
          : '${winner.name} won the game.';
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
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
  // CONFETTI
  // ===========================================================================

  void _showConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.55),
    );
  }
}
