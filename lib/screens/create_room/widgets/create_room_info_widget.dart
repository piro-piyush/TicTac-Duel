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
        const SectionTitleWidget(title: 'HOW IT WORKS'),

        Column(
          spacing: Dimens.ten,
          children: [
            InfoItemWidget(
              icon: Icons.people_alt_rounded,
              title: '2 Players',
              subtitle: 'Each room supports a maximum of two players.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.lock_open_rounded,
              title: 'Public or Private',
              subtitle: 'Public rooms are discoverable. Private rooms require a room code.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.tag_rounded,
              title: 'Share Room Code',
              subtitle: 'Share your room code with a friend to invite them.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.check_circle_outline_rounded,
              title: 'Ready to Start',
              subtitle: 'The duel begins when both players are ready.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.emoji_events_rounded,
              title: 'Round Based',
              subtitle:
                  'Play multiple rounds and earn points for each round won.',
              textTheme: textTheme,
            ),
            InfoItemWidget(
              icon: Icons.flag_rounded,
              title: 'Win the Duel',
              subtitle: 'The player with the most round wins takes the match.',
              textTheme: textTheme,
            ),
          ],
        ),
      ],
    );
  }
}
