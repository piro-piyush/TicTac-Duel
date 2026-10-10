import 'package:tictac_duel/lib.dart';

class TicTacToeStatusWidget extends StatelessWidget {
  const TicTacToeStatusWidget({
    super.key,
    required this.player,
    required this.isMe,
    required this.theme,
    this.isOnline = false,
    this.compact = false,
  });

  final PlayerModel player;
  final bool Function(String id) isMe;
  final RoomTheme theme;
  final bool isOnline;
  final bool compact;

  String get _status {
    if (isMe(player.id) || player.name == 'You') {
      return 'Your turn';
    }

    return "${player.name}'s turn";
  }

  @override
  Widget build(BuildContext context) {
    final color = PlayerSymbolX.color(player.symbol, theme);

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusIndicator(color: color, isOnline: isOnline),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              _status,
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
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.color, required this.isOnline});

  final Color color;
  final bool isOnline;

  @override
  Widget build(BuildContext context) => Container(
    width: Dimens.six,
    height: Dimens.six,
    decoration: BoxDecoration(
      color: isOnline ? color : AppColors.textSecondary,
      shape: BoxShape.circle,
      boxShadow: isOnline
          ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 7)]
          : null,
    ),
  );
}
