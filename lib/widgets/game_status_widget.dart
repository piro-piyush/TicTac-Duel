import 'package:tictac_duel/lib.dart';

class GameStatusWidget extends StatelessWidget {
  const GameStatusWidget({
    super.key,
    required this.player,
    required this.status,
    required this.theme,
    this.compact = false,
  });

  final PlayerModel player;
  final String status;
  final RoomTheme theme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = player.symbol == PlayerSymbol.x
        ? theme.primary
        : theme.secondary;

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
          _StatusIndicator(color: color),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              status,
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
  const _StatusIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 7),
      ],
    ),
  );
}
