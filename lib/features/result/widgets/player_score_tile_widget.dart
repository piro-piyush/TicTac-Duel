import 'package:tictac_duel/lib.dart';

class PlayerScoreTileWidget extends StatelessWidget {
  const PlayerScoreTileWidget({
    super.key,
    required this.player,
    required this.points,
    required this.isWinner,
    required this.isMe,
    required this.isOnline,
  });

  final PlayerModel player;
  final int points;
  final bool isWinner;
  final bool isMe;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color = player.symbol == PlayerSymbol.x
        ? AppColors.neonCyan
        : AppColors.neonPink;

    return Padding(
      padding: Dimens.edgeInsets4_10,
      child: Row(
        spacing: Dimens.twelve,
        children: [
          Container(
            width: Dimens.icon2Xl,
            height: Dimens.icon2Xl,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: Dimens.radius12,
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Text(
              player.symbol.value.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: Dimens.font2Xl,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Row(
              spacing: Dimens.sixteen,
              children: [
                Flexible(
                  child: Text(
                    _playerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: Dimens.sixteen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isWinner) ...[
                  Container(
                    padding: Dimens.edgeInsets8_4,
                    decoration: BoxDecoration(
                      color: AppColors.neonPurple.withValues(alpha: 0.12),
                      borderRadius: Dimens.radius4,
                      border: Border.all(
                        color: AppColors.neonPurple.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Text(
                      'WINNER',
                      style: TextStyle(
                        color: AppColors.neonPurple,
                        fontSize: Dimens.font2Xs,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '$points',
            style: TextStyle(
              color: color,
              fontSize: Dimens.font2Xl,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String get _playerName {
    if (isOnline && isMe) {
      return '${player.name} (You)';
    }

    return player.name;
  }
}
