import 'package:tictac_duel/lib.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return NeonBackgroundWidget(
      needScroll: false,
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickActionWidget(
            icon: Icons.settings,
            label: 'Settings',
            onTap: AppNavigation.pushSettings,
          ),
          QuickActionWidget(
            icon: Icons.info_outline,
            label: 'Help',
            onTap: AppNavigation.pushHelp,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Dimens.twentyTwo),
                  const AppLogoWidget(),
                  const SizedBox(height: Dimens.twentyTwo),
                  Text(GameConstants.appName, style: textTheme.headlineLarge),
                  const SizedBox(height: Dimens.eight),
                  Text(GameConstants.appSlogan, style: textTheme.labelSmall),
                  const SizedBox(height: Dimens.fortyEight),
                  const HomeActionsWidget(),
                  const SizedBox(height: Dimens.twenty),
                  const ReadyIndicatorWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
