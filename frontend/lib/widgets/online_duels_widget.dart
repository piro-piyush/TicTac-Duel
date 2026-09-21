import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class OnlineDuelsWidget extends StatelessWidget {
  const OnlineDuelsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      children: [
         HelpSectionTileWidget(
          icon: Icons.public_rounded,
          title: 'ONLINE DUELS',
          color: Themes.neonPurple,
        ),

        Column(
          spacing: 10,
          children: [
            SettingsHelpCardWidget(
              icon: Icons.add_circle_outline_rounded,
              color: Themes.neonPurple,
              title: 'Create a Game',
              description:
              'Create a room, choose your symbol and game mode, then share '
                  'the room code with your opponent.',
            ),

            SettingsHelpCardWidget(
              icon: Icons.login_rounded,
              color: Themes.neonPink,
              title: 'Join a Game',
              description:
              'Enter your opponent’s room code to join their duel and get '
                  'ready to play.',
            ),

            SettingsHelpCardWidget(
              icon: Icons.lock_outline_rounded,
              color: Themes.neonCyan,
              title: 'Private Rooms',
              description:
              'Private rooms are accessible through their room code, making '
                  'them useful when playing directly with a friend.',
            ),
          ],
        ),
      ],
    );
  }
}
