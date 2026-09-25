import 'package:tictac_duel/lib.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SocketService.instance.connect();
  }

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      needScroll: false,
      padding: Dimens.edgeInsets10_4,

      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Dimens.twentyTwo),
                  const AppLogoWidget(),

                  SizedBox(height: Dimens.twentyTwo),

                  const Text(
                    'Tic Tac Duel',
                    style: TextStyle(
                      color: Themes.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: Dimens.eight),
                  Text(
                    'YOUR MOVE. YOUR GLORY.',
                    style: TextStyle(
                      color: Themes.textSecondary.withValues(alpha: 0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.5,
                    ),
                  ),

                  SizedBox(height: Dimens.fortyEight),

                  // Quick Start
                  HomeActionsWidget(),

                  SizedBox(height: Dimens.twenty),

                  const ReadyIndicatorWidget(),
                ],
              ),
            ),
          ),

          Padding(
            padding: Dimens.edgeInsets8_12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Dimens.twelve,
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
