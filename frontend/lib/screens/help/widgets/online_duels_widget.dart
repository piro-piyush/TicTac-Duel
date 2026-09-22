import 'package:tictac_duel/lib.dart';

class OnlineDuelsWidget extends StatelessWidget {
  const OnlineDuelsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTitleAndOptionsWidget(
      title: 'ONLINE DUELS',
      children: [
        SectionTileWidget(
          icon: Icons.add_circle_outline_rounded,
          color: Themes.neonPurple,
          title: 'Create a Game',
          subtitle:
              'Create a room, choose your symbol and game mode, then share '
              'the room code with your opponent.',
        ),

        SectionTileWidget(
          icon: Icons.login_rounded,
          color: Themes.neonPink,
          title: 'Join a Game',
          subtitle:
              'Enter your opponent’s room code to join their duel and get '
              'ready to play.',
        ),

        SectionTileWidget(
          icon: Icons.lock_outline_rounded,
          color: Themes.neonCyan,
          title: 'Private Rooms',
          subtitle:
              'Private rooms are accessible through their room code, making '
              'them useful when playing directly with a friend.',
        ),
      ],
    );
  }
}
