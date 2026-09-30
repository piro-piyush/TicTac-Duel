import 'package:tictac_duel/lib.dart';

class GameModesWidget extends StatelessWidget {
  const GameModesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionTitleAndOptionsWidget(
      title: 'GAME OPTIONS',
      children: [
        SectionTileWidget(
          icon: Icons.people_outline_rounded,
          color: AppColors.neonPurple,
          title: 'Choose Your Opponent',
          subtitle:
          'Play with a friend on the same device or challenge the CPU '
              'in a local match.',
        ),
        SectionTileWidget(
          icon: Icons.tune_rounded,
          color: AppColors.neonPink,
          title: 'Customize Your Game',
          subtitle:
          'Choose your game theme and set the number of rounds before '
              'starting a match.',
        ),
        SectionTileWidget(
          icon: Icons.smart_toy_outlined,
          color: AppColors.neonCyan,
          title: 'CPU Difficulty',
          subtitle:
          'When playing against the CPU, choose a difficulty level '
              'that matches your skill.',
        ),
      ],
    );
  }
}