import 'package:tictac_duel/lib.dart';

class PublicRoomWidget extends StatelessWidget {
  const PublicRoomWidget({
    super.key,
    required this.rooms,
    required this.onRefresh,
    required this.onJoinRoom,
  });

  final List<RoomModel> rooms;
  final VoidCallback onRefresh;
  final ValueChanged<RoomModel> onJoinRoom;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.eight,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'PUBLIC ROOMS',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              visualDensity: VisualDensity.compact,
              tooltip: 'Refresh',
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.textSecondary,
                size: Dimens.iconMd,
              ),
            ),
          ],
        ),
        if (rooms.isEmpty)
          const EmptyPublicRoomWidget()
        else
          Column(
            spacing: Dimens.ten,
            children: rooms.map((room) {
              return SectionTileWidget.withAction(
                icon: Icons.sports_esports_rounded,
                title: room.players.first.name,
                subtitle:
                    '${room.theme.displayName} • '
                    '${room.maxRounds} '
                    '${room.maxRounds == 1 ? 'Round' : 'Rounds'}',
                color: room.theme.primary,
                actionIcon: Icons.arrow_forward_rounded,
                onTap: () => onJoinRoom(room),
              );
            }).toList(),
          ),
      ],
    );
  }
}
