import 'package:tictac_duel/lib.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final navigation = ref.read(appNavigationProvider);

    return NeonBackgroundWidget(
      padding: Dimens.edgeInsets10_4,
      needScroll: false,
      keyboardAware: true,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Dimens.twelve,
        children: [
          QuickActionWidget(
            icon: Icons.settings_rounded,
            label: 'Settings',
            onTap: navigation.pushSettings,
          ),
          QuickActionWidget(
            icon: Icons.help_outline_rounded,
            label: 'Help',
            onTap: navigation.pushHelp,
          ),
        ],
      ),
      child: Column(
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
