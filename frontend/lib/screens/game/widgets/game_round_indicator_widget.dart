import 'package:tictac_duel/lib.dart';

class GameRoundIndicatorWidget extends StatelessWidget {
  final RoomModel room;
  final bool compact;

  const GameRoundIndicatorWidget({
    super.key,
    required this.room,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 14,
        vertical: compact ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: room.theme.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 7,
        children: [
          Icon(
            Icons.sports_esports_outlined,
            color: room.theme.primary,
            size: compact ? 14 : 15,
          ),
          Text(
            'ROUND ${room.currentRound}',
            style: TextStyle(
              color: room.theme.primary,
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          Text(
            '/',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
          Text(
            '${room.maxRounds}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
