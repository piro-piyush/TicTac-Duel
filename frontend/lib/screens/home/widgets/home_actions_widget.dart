import 'package:tictac_duel/lib.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.thirty,
      children: [
        Column(
          spacing: Dimens.fourteen,

          children: [
            MenuButtonWidget(
              title: 'Quick Start',
              subtitle: 'Find an opponent and play',
              icon: Icons.bolt_rounded,
              color: Themes.neonCyan,
              onTap: () {
                SnackbarUtils.showWarning(context, 'Coming soon...');
              },
            ),

            // Local Game
            MenuButtonWidget(
              title: 'Local Game',
              subtitle: 'Play against a friend on this device',
              icon: Icons.smartphone_rounded,
              color: Themes.neonPurple,
              onTap: () {
                SnackbarUtils.showWarning(context, 'Coming soon...');
              },
            ),
          ],
        ),

        // Room-based multiplayer
        Row(
          spacing: Dimens.twelve,
          children: [
            Expanded(
              child: QuickActionWidget(
                icon: Icons.add_rounded,
                label: 'Create Room',
                onTap: Routes.pushCreateRoom,
              ),
            ),
            Expanded(
              child: QuickActionWidget(
                icon: Icons.login_rounded,
                label: 'Join Room',
                onTap: Routes.pushJoinRoom,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
