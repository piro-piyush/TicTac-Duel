import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class TicTacToeGameWidget extends StatelessWidget {
  const TicTacToeGameWidget({
    super.key,
    required this.theme,
    this.playerId,
    required this.board,
    required this.winningIndexes,
    required this.turnPlayerId,
    required this.isMyTurn,
    required this.onCellTap,
    required this.guest,
    required this.host,
    required this.hostPoints,
    required this.guestPoints,
    required this.showRoundAnimation,

    this.reactionEvent,
    required this.isOnline,
  });

  final ReactionReceivedResponse? reactionEvent;
  final RoomTheme theme;

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  final String? playerId;

  final PlayerModel host;
  final PlayerModel guest;

  final int hostPoints;
  final int guestPoints;

  final bool showRoundAnimation;

  // ===========================================================================
  // BOARD
  // ===========================================================================

  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  // ===========================================================================
  // TURN
  // ===========================================================================

  final String? turnPlayerId;
  final bool isMyTurn;
  final bool isOnline;

  // ===========================================================================
  // INTERACTION
  // ===========================================================================

  final ValueChanged<int> onCellTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final isCompact = width < 380;
        final isWide = width >= 600;

        final horizontalPadding = isCompact ? 4.0 : 12.0;

        final availableBoardSize = math.min(
          isWide ? 460.0 : 420.0,
          width - (horizontalPadding * 2),
        );

        // Reserve space for both player cards and spacing.
        final reservedHeight = isCompact ? 150.0 : 180.0;

        final boardSize = math.min(
          availableBoardSize,
          math.max(180.0, height - reservedHeight),
        );

        final sectionSpacing = boardSize < 300
            ? 6.0
            : isCompact
            ? 10.0
            : 16.0;

        final meIsPlayerOne = host.id == playerId;

        final me = meIsPlayerOne ? host : guest;
        final opponent = meIsPlayerOne ? guest : host;

        final mePoints = meIsPlayerOne ? hostPoints : guestPoints;
        final opponentPoints = meIsPlayerOne ? guestPoints : hostPoints;

        final meIsTurn = turnPlayerId == playerId;
        final opponentIsTurn = turnPlayerId != null && turnPlayerId != playerId;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            Dimens.eight,
            horizontalPadding,
            Dimens.sixteen,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: sectionSpacing,
                children: [
                  Align(
                        alignment: Alignment.centerRight,
                        child: _buildPlayerCard(
                          player: opponent,
                          points: opponentPoints,
                          isTurn: opponentIsTurn,
                          compact: isCompact,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: AnimationConstants.medium)
                      .slideX(
                        begin: -AnimationConstants.slideLarge,
                        end: 0,
                        duration: AnimationConstants.medium,
                        curve: AnimationConstants.defaultCurve,
                      ),

                  _buildBoard(isWide),

                  Align(
                        alignment: Alignment.centerLeft,
                        child: _buildPlayerCard(
                          player: me,
                          points: mePoints,
                          isTurn: meIsTurn,
                          compact: isCompact,
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: AnimationConstants.staggerShort,
                        duration: AnimationConstants.medium,
                      )
                      .slideX(
                        begin: AnimationConstants.slideLarge,
                        end: 0,
                        delay: AnimationConstants.staggerShort,
                        duration: AnimationConstants.medium,
                        curve: AnimationConstants.defaultCurve,
                      ),
                ],
              ),

              if (reactionEvent != null)
                Positioned.fill(
                  child: IgnorePointer(child: _buildReaction(reactionEvent!)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerCard({
    required PlayerModel player,
    required int points,
    required bool isTurn,
    required bool compact,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: compact ? 190 : 230),
      child: GamePlayerCardWidget(
        player: player,
        points: points,
        isMe: _isMe,
        isTurn: isTurn,
        theme: theme,
        compact: compact,
        isOnline: isOnline,
      ),
    );
  }

  Widget _buildReaction(ReactionReceivedResponse event) {
    final isMeSender = event.senderId == playerId;

    const begin = Alignment(-0.75, 0.75);
    const end = Alignment(0.75, -0.75);

    final start = isMeSender ? begin : end;
    final finish = isMeSender ? end : begin;

    return TweenAnimationBuilder<double>(
      key: ValueKey(event),
      duration: GameConstants.reactionTotalDuration,
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        // -----------------------------------------------------------------------
        // Travel → Hold → Fade
        // -----------------------------------------------------------------------

        final travelEnd =
            GameConstants.reactionTravelDuration.inMilliseconds /
            GameConstants.reactionTotalDuration.inMilliseconds;

        final fadeStart =
            1 -
            (GameConstants.reactionFadeDuration.inMilliseconds /
                GameConstants.reactionTotalDuration.inMilliseconds);

        final travelProgress = (value / travelEnd).clamp(0.0, 1.0);

        final alignment = Alignment.lerp(
          start,
          finish,
          Curves.easeInOutCubic.transform(travelProgress),
        )!;

        final opacity = value < 0.05
            ? value / 0.05
            : value > fadeStart
            ? (1.0 - value) / (1.0 - fadeStart)
            : 1.0;

        final scale = value < 0.08
            ? Curves.easeOutBack.transform((value / 0.08).clamp(0.0, 1.0))
            : 1.0;

        return Align(
          alignment: alignment,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: SizedBox(
        width: Dimens.seventy,
        height: Dimens.seventy,
        child: Lottie.network(
          event.reaction.animationUrl,
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
    );
  }

  bool _isMe(String id) {
    return playerId == id;
  }

  Widget _buildBoard(bool isWide) {
    return AbsorbPointer(
      absorbing: showRoundAnimation,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWide ? Dimens.fourHundredSixty : Dimens.threeHundredForty,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: TicTacToeBoardWidget(
            roomTheme: theme,
            values: board,
            isMyTurn: isMyTurn,
            winningIndexes: winningIndexes,
            onCellTap: onCellTap,
          ),
        ),
      ),
    );
  }
}
