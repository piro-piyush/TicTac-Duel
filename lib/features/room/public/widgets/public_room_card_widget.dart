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
    return SectionTileWidget(
      icon: Icons.sports_esports_rounded,
      title: room.host.name,
      subtitle:
          '${room.theme.displayName} • '
          '${room.maxRounds} '
          '${room.maxRounds == 1 ? 'Round' : 'Rounds'}',
      color: room.theme.primary,
      onTap: onJoin,
      trailing: TextButton.icon(
        onPressed: onJoin,
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: const Text('JOIN'),
      ),
    );
  }
}
