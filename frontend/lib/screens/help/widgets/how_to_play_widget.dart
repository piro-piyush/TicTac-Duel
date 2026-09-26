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
          icon: Icons.grid_3x3_rounded,
          color: AppColors.neonCyan,
          title: 'Make Your Move',
          subtitle:
              'Tap an empty square on the board to place your symbol. '
              'Choose your move carefully — once placed, it cannot be changed.',
        ),

        SectionTileWidget(
          icon: Icons.emoji_events_rounded,
          color: AppColors.neonGreen,
          title: 'Win the Duel',
          subtitle:
              'Get three of your symbols in a row — horizontally, vertically, '
              'or diagonally — before your opponent does.',
        ),

        SectionTileWidget(
          icon: Icons.handshake_rounded,
          color: AppColors.draw,
          title: 'Avoid a Draw',
          subtitle:
              'If every square is filled and neither player gets three in a row, '
              'the game ends in a draw.',
        ),
      ],
    );
  }
}
