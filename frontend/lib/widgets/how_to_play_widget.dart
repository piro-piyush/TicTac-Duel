import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class HowToPlayWidget extends StatelessWidget {
  const HowToPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      children: [
        HelpSectionTileWidget(
          icon: Icons.sports_esports_rounded,
          title: 'HOW TO PLAY',
          color: Themes.neonCyan,
        ),

        Column(
          spacing: 10,
          children: [
            SettingsHelpCardWidget(
              icon: Icons.grid_3x3_rounded,
              color: Themes.neonCyan,
              title: 'Make Your Move',
              description:
                  'Tap an empty square on the board to place your symbol. '
                  'Choose your move carefully — once placed, it cannot be changed.',
            ),

            SettingsHelpCardWidget(
              icon: Icons.emoji_events_rounded,
              color: Themes.neonGreen,
              title: 'Win the Duel',
              description:
                  'Get three of your symbols in a row — horizontally, vertically, '
                  'or diagonally — before your opponent does.',
            ),

            SettingsHelpCardWidget(
              icon: Icons.handshake_rounded,
              color: Themes.draw,
              title: 'Avoid a Draw',
              description:
                  'If every square is filled and neither player gets three in a row, '
                  'the game ends in a draw.',
            ),
          ],
        ),
      ],
    );
  }
}
