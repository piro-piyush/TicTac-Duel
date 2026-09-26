import 'package:tictac_duel/lib.dart';

class PublicRoomCardWidget extends StatelessWidget {
  const PublicRoomCardWidget({
    super.key,
    required this.room,
    required this.onJoin,
  });

  final RoomModel room;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeColor = room.theme.primary;

    return Container(
      padding: Dimens.edgeInsets14,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: Dimens.radius14,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: Dimens.fortyFour,
            height: Dimens.fortyFour,
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeColor.withValues(alpha: 0.35)),
            ),
            child: Icon(
              Icons.sports_esports_rounded,
              color: themeColor,
              size: Dimens.twentyTwo,
            ),
          ),
          SizedBox(width: Dimens.twelve),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.players.first.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${room.theme.name}  •  '
                  '${room.maxRounds} '
                  '${room.maxRounds == 1 ? 'Round' : 'Rounds'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimens.eight),
          TextButton.icon(
            onPressed: onJoin,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('JOIN'),
          ),
        ],
      ),
    );
  }
}
