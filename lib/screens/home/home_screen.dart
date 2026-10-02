import 'package:tictac_duel/lib.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return NeonBackgroundWidget(
      needScroll: false,
      padding: Dimens.edgeInsets10_4,
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Dimens.twelve,
        children: [
          QuickActionWidget(
            icon: Icons.settings_rounded,
            label: 'Settings',
            onTap: AppNavigation.pushSettings,
          ),
          QuickActionWidget(
            icon: Icons.help_outline_rounded,
            label: 'Help',
            onTap: AppNavigation.pushHelp,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Dimens.fortyEight,
        children: [
          Column(
            spacing: Dimens.twentyTwo,
            children: [
              const AppLogoWidget(),
              Column(
                spacing: Dimens.eight,
                children: [
                  Text(GameConstants.appName, style: textTheme.headlineLarge),
                  Text(GameConstants.appSlogan, style: textTheme.labelSmall),
                ],
              ),
            ],
          ),
          const Column(
            spacing: Dimens.twenty,
            children: [HomeActionsWidget(), ReadyIndicatorWidget()],
          ),
        ],
      ),
    );
  }
}
