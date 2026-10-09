import 'package:tictac_duel/lib.dart';

class TicTacToeRoundWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const TicTacToeRoundWidget({
    super.key,
    required this.currentRound,
    required this.maxRounds,
    this.color = AppColors.neonCyan,
    this.compact = false,
  });

  final int currentRound;
  final int maxRounds;
  final Color color;
  final bool compact;

  @override
  Size get preferredSize => Size.fromHeight(compact ? 36 : 42);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = compact ? Dimens.twelve : Dimens.sixteen;
    final verticalPadding = compact ? Dimens.six : Dimens.eight;
    final iconSize = compact ? Dimens.fourteen : Dimens.sixteen;
    final labelSize = compact ? Dimens.eight : Dimens.ten;

    return SizedBox(
      height: preferredSize.height,
      child: Center(
        child:
            Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: compact ? Dimens.radius12 : Dimens.radius16,
                    border: Border.all(color: color.withValues(alpha: 0.28)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.07),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Dimens.eight,
                    children: [
                      Icon(
                        Icons.sports_esports_outlined,
                        color: color,
                        size: iconSize,
                      ),
                      Text(
                        'ROUND',
                        style: TextStyle(
                          color: color.withValues(alpha: 0.85),
                          fontSize: labelSize,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: AnimationConstants.fast,
                        switchInCurve: AnimationConstants.entranceCurve,
                        switchOutCurve: AnimationConstants.exitCurve,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.75,
                                end: 1,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          '$currentRound',
                          key: ValueKey(currentRound),
                          style: TextStyle(
                            color: color,
                            fontSize: compact ? 11 : 12,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: compact ? 12 : 14,
                        color: AppColors.border,
                      ),
                      Text(
                        '$maxRounds',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: labelSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                )
                .slideY(
                  begin: -AnimationConstants.slideSmall,
                  end: 0,
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                )
                .scale(
                  begin: const Offset(0.94, 0.94),
                  end: const Offset(1, 1),
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                ),
      ),
    );
  }
}
