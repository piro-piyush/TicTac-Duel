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
    final textTheme = Theme.of(context).textTheme;
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
                  AppLogoWidget(),

                  SizedBox(height: Dimens.twentyTwo),

                  Text(GameConstants.appName, style: textTheme.headlineLarge),

                  SizedBox(height: Dimens.eight),
                  Text(GameConstants.appSlogan, style: textTheme.labelSmall),

                  SizedBox(height: Dimens.fortyEight),

                  // Quick Start
                  HomeActionsWidget(),

                  SizedBox(height: Dimens.twenty),

                  const ReadyIndicatorWidget(),
                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }
}
