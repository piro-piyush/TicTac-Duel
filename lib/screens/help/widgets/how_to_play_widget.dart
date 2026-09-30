import 'package:tictac_duel/lib.dart';

class HowToPlayWidget extends StatelessWidget {
  const HowToPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionTitleAndOptionsWidget(
      titleIcon: Icons.sports_esports_rounded,
      title: 'HOW TO PLAY',
      children: [
        SectionTileWidget(
          icon: Icons.touch_app_rounded,
          color: AppColors.neonCyan,
          title: 'Make Your Move',
          subtitle:
          'Tap an empty square to place your symbol. '
              'Once placed, a move cannot be changed.',
        ),
        SectionTileWidget(
          icon: Icons.emoji_events_rounded,
          color: AppColors.neonGreen,
          title: 'Get Three in a Row',
          subtitle:
          'Complete a horizontal, vertical, or diagonal line with '
              'three of your symbols to win the round.',
        ),
        SectionTileWidget(
          icon: Icons.handshake_rounded,
          color: AppColors.draw,
          title: 'Draw Game',
          subtitle:
          'If all nine squares are filled without either player '
              'getting three in a row, the round ends in a draw.',
        ),
      ],
    );
  }
}