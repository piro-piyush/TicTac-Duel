import 'package:tictac_duel/lib.dart';

class CreateRoomInfoWidget extends StatelessWidget {
  const CreateRoomInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: Dimens.eight,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'INFO'),
        Column(
          spacing: Dimens.ten,
          children: [
            InfoItemWidget(
              icon: Icons.public_rounded,
              title: 'Public Room',
              subtitle: 'Anyone can discover and join this room.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.people_alt_rounded,
              title: '2 Players',
              subtitle: 'A room starts when both players are ready.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.tag_rounded,
              title: 'Room Code',
              subtitle: 'Share the generated code with a friend to join.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.emoji_events_rounded,
              title: 'Round Based',
              subtitle: 'Win more rounds than your opponent to win the duel.',
              textTheme: textTheme,
            ),
          ],
        ),
      ],
    );
  }
}
