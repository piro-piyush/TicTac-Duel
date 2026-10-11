import 'package:tictac_duel/lib.dart';

class GameRoundIndicatorWidget extends StatelessWidget {
  const GameRoundIndicatorWidget({
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
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 11 : 14,
      vertical: compact ? 6 : 7,
    ),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.20)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 7,
      children: [
        Icon(
          Icons.sports_esports_outlined,
          color: color,
          size: compact ? 14 : 15,
        ),
        Text(
          'ROUND $currentRound',
          style: TextStyle(
            color: color,
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
          '$maxRounds',
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
