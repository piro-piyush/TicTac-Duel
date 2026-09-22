import 'package:tictac_duel/lib.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogoWidget(),

                      const SizedBox(height: 22),

                      const Text(
                        'Tic Tac Duel',
                        style: TextStyle(
                          color: Themes.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'YOUR MOVE. YOUR GLORY.',
                        style: TextStyle(
                          color: Themes.textSecondary.withValues(
                            alpha: 0.85,
                          ),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      MenuButtonWidget(
                        title: 'Create Game',
                        subtitle: 'Start a new duel',
                        icon: Icons.add_rounded,
                        color: Themes.neonCyan,
                        secondaryColor: Themes.neonPurple,
                        onTap: Routes.pushCreateRoom,
                      ),

                      const SizedBox(height: 14),

                      MenuButtonWidget(
                        title: 'Invite Friend',
                        subtitle: 'Challenge someone to play',
                        icon: Icons.person_add_alt_1_rounded,
                        color: Themes.neonPurple,
                        secondaryColor: Themes.neonPink,
                        onTap: Routes.pushJoinRoom,
                      ),

                      const SizedBox(height: 30),

                      ReadyIndicatorWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                QuickActionWidget(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: Routes.pushSettings,
                ),
                QuickActionWidget(
                  icon: Icons.help_outline_rounded,
                  label: 'Help',
                  onTap: Routes.pushHelp,
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
