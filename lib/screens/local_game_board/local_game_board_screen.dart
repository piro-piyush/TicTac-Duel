import 'package:tictac_duel/lib.dart';

class LocalGameBoardScreen extends GetView<LocalGameBoardController> {
  const LocalGameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldQuit = await GameDialogUtils.confirmQuit();

        if (shouldQuit) {
          controller.quitGame();
        }
      },
      child: Obx(() {
        final game = controller.game;
        final currentPlayer = controller.currentPlayer;

        return TicTacToeGameTemplateWidget(
          currentRound: controller.currentRound,
          maxRounds: game.maxRounds,
          player: currentPlayer,
          isMe: (id) => id == controller.playerId,
          theme: game.theme,
          isOnline: false,
          showGameStatus: true,
          // floatingActionButton: _buildReactionButton(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              TicTacToeGameWidget(
                theme: game.theme,
                board: controller.board,
                winningIndexes: controller.winningIndexes,
                turnIndex: controller.turnIndex,
                isMyTurn: controller.canMakeMove,
                onCellTap: controller.onCellTap,
                playerOnePoints: controller.playerOnePoints,
                playerTwoPoints: controller.playerTwoPoints,
                playerId: controller.playerId,
                playerOne: game.playerOne,
                playerTwo: game.playerTwo,
                isOnline: false,
                reactionEvent: controller.reactionEvent,
                showRoundAnimation: controller.showRoundAnimation,
              ),
              GameRoundAnimationWidget(
                showRoundAnimation: controller.showRoundAnimation,
                animatedRound: controller.animatedRound,
              ),
            ],
          ),
        );
      }),
    );
  }

  // // ===========================================================================
  // // REACTION
  // // ===========================================================================
  //
  // Widget _buildReactionButton(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () => _showReactionPicker(context),
  //     tooltip: 'Send reaction',
  //     child: const Icon(Icons.emoji_emotions_rounded),
  //   );
  // }
  //
  // void _showReactionPicker(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     showDragHandle: false,
  //     builder: (context) {
  //       final theme = Theme.of(context);
  //
  //       return SafeArea(
  //         top: false,
  //         child: Container(
  //           padding: const EdgeInsets.fromLTRB(
  //             Dimens.spaceBtwSections,
  //             Dimens.spaceBtwItems,
  //             Dimens.spaceBtwSections,
  //             Dimens.spaceBtwSections,
  //           ),
  //           decoration: BoxDecoration(
  //             color: theme.colorScheme.surface,
  //             borderRadius: const BorderRadius.vertical(
  //               top: Dimens.cornerRadius16,
  //             ),
  //             border: Border.all(
  //               color: theme.colorScheme.outline.withValues(alpha: 0.15),
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha: 0.25),
  //                 blurRadius: Dimens.twenty,
  //                 offset: const Offset(0, -Dimens.eight),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               _buildReactionHandle(theme),
  //               const SizedBox(height: Dimens.spaceBtwItems),
  //               _buildReactionTitle(theme),
  //               const SizedBox(height: Dimens.spaceBtwItems),
  //               _buildReactionGrid(context),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // Widget _buildReactionHandle(ThemeData theme) {
  //   return Container(
  //     width: Dimens.forty,
  //     height: Dimens.four,
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
  //       borderRadius: Dimens.radius10,
  //     ),
  //   );
  // }
  //
  // Widget _buildReactionTitle(ThemeData theme) {
  //   return Text(
  //     'SEND A REACTION',
  //     style: theme.textTheme.labelLarge?.copyWith(
  //       fontWeight: FontWeight.w700,
  //       letterSpacing: 1.2,
  //     ),
  //   );
  // }
  //
  // Widget _buildReactionGrid(BuildContext context) {
  //   return Wrap(
  //     alignment: WrapAlignment.center,
  //     spacing: Dimens.spaceBtwItems,
  //     runSpacing: Dimens.spaceBtwItems,
  //     children: [
  //       for (final reaction in GameReaction.values)
  //         _reactionButton(context, reaction),
  //     ],
  //   );
  // }
  //
  // Widget _reactionButton(BuildContext context, GameReaction reaction) {
  //   final theme = Theme.of(context);
  //
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.of(context).pop();
  //         controller.sendReaction(reaction);
  //       },
  //       borderRadius: Dimens.radius10,
  //       splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
  //       highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
  //       child: Ink(
  //         width: Dimens.fifty,
  //         height: Dimens.fifty,
  //         decoration: BoxDecoration(
  //           color: theme.colorScheme.surfaceContainerHighest.withValues(
  //             alpha: 0.45,
  //           ),
  //           borderRadius: Dimens.radius10,
  //           border: Border.all(
  //             color: theme.colorScheme.outline.withValues(alpha: 0.15),
  //           ),
  //         ),
  //         child: Center(
  //           child: Lottie.network(
  //             reaction.animation,
  //             width: Dimens.forty,
  //             height: Dimens.forty,
  //             fit: BoxFit.contain,
  //             repeat: true,
  //             animate: true,
  //             frameRate: FrameRate.max,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
