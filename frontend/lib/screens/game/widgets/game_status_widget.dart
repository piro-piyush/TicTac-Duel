import 'package:tictac_duel/lib.dart';

class GameStatusWidget extends StatelessWidget {
  final RoomModel room;
  final String? webSocketId;
  final bool compact;

  const GameStatusWidget({
    super.key,
    required this.room,
    this.webSocketId,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final player = room.turn;
    if (player == null) {
      return const SizedBox.shrink();
    }
    final isMyTurn = player.socketId == webSocketId;
    final color = player.symbol == PlayerSymbol.x
        ? room.theme.primary
        : room.theme.secondary;
    final text = isMyTurn ? 'Your turn' : '${player.name}\'s turn';
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 7),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
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
