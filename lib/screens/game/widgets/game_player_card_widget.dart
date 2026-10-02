import 'package:tictac_duel/lib.dart';

class GamePlayerCardWidget extends StatelessWidget {
  const GamePlayerCardWidget({
    super.key,
    required this.player,
    required this.points,
    required this.isMe,
    required this.isTurn,
    required this.theme,
    required this.compact,
    this.isOnline = false,
  });

  final PlayerModel player;
  final int points;
  final bool Function(String id) isMe;
  final bool isTurn;
  final RoomTheme theme;
  final bool compact;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color = player.symbol == PlayerSymbol.x
        ? theme.primary
        : theme.secondary;

    final avatarSize = compact ? 40.0 : 48.0;
    final isCurrentPlayer = isMe(player.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: isTurn
            ? color.withValues(alpha: 0.07)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(compact ? 13 : 16),
        border: Border.all(
          color: isTurn
              ? color.withValues(alpha: 0.55)
              : AppColors.border,
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
            isMe: isCurrentPlayer,
            isTurn: isTurn,
            size: avatarSize,
          ),
          Expanded(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlayerHeader(
                  color,
                  isCurrentPlayer,
                ),
                _buildPlayerStatus(color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerHeader(
      Color color,
      bool isCurrentPlayer,
      ) {
    return Row(
      spacing: 5,
      children: [
        Flexible(
          child: Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (isOnline)
          _buildPlayerBadge(
            color,
            isCurrentPlayer,
          ),
      ],
    );
  }

  Widget _buildPlayerBadge(
      Color color,
      bool isCurrentPlayer,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? color.withValues(alpha: 0.12)
            : AppColors.card,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isCurrentPlayer
              ? color.withValues(alpha: 0.25)
              : AppColors.border,
        ),
      ),
      child: Text(
        isCurrentPlayer ? 'YOU' : 'OPPONENT',
        style: TextStyle(
          color: isCurrentPlayer
              ? color
              : AppColors.textSecondary,
          fontSize: compact ? 6 : 7,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _buildPlayerStatus(Color color) {
    return Row(
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
        const Spacer(),
        _buildPoints(
          color: color,
          compact: compact,
        ),
      ],
    );
  }

  Widget _buildPoints({
    required Color color,
    required bool compact,
  }) {
    return TweenAnimationBuilder<int>(
      key: ValueKey(points),
      tween: IntTween(
        begin: points > 0 ? points - 1 : 0,
        end: points,
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return AnimatedScale(
          scale: value == points && points > 0 ? 1.0 : 0.9,
          duration: const Duration(milliseconds: 180),
          child: Container(
            constraints: BoxConstraints(
              minWidth: compact ? 22 : 26,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 5 : 6,
              vertical: compact ? 2 : 3,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      },
    );
  }
}