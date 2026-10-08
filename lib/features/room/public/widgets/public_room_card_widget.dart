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

    return Material(
      color: AppColors.card,
      borderRadius: Dimens.radius14,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        borderRadius: Dimens.radius14,
        splashColor: themeColor.withValues(alpha: 0.08),
        highlightColor: themeColor.withValues(alpha: 0.04),
        child: Container(
          padding: Dimens.edgeInsets14,
          decoration: BoxDecoration(
            borderRadius: Dimens.radius14,
            border: Border.all(color: AppColors.border),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: Dimens.fortyFour,
              height: Dimens.fortyFour,
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.12),
                borderRadius: Dimens.radius12,
                border: Border.all(color: themeColor.withValues(alpha: 0.35)),
              ),
              child: Icon(
                Icons.sports_esports_rounded,
                color: themeColor,
                size: Dimens.iconMd,
              ),
            ),
            title: Text(
              room.host.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge,
            ),
            subtitle: Text(
              '${room.theme.name}  •  '
                  '${room.maxRounds} '
                  '${room.maxRounds == 1 ? 'Round' : 'Rounds'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall,
            ),
            trailing: TextButton.icon(
              onPressed: onJoin,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('JOIN'),
            ),
          ),
        ),
      ),
    );
  }
}
