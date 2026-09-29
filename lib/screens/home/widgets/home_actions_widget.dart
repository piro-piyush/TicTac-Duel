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
              title: 'Quick Match',
              subtitle: 'Find an opponent and play',
              icon: Icons.bolt_rounded,
              color: AppColors.neonCyan,
              onTap: () => _checkInternetConnection(
                () => PopupUtils.showWarning('Coming Soon...'),
              ),
            ),
            const MenuButtonWidget(
              title: 'Local Game',
              subtitle: 'Play with a friend or challenge the CPU',
              icon: Icons.smartphone_rounded,
              color: AppColors.neonPurple,
              onTap: AppNavigation.pushLocalGame,
            ),
          ],
        ),
        Row(
          spacing: Dimens.twelve,
          children: [
            Expanded(
              child: QuickActionWidget(
                icon: Icons.add_rounded,
                label: 'Create Room',
                onTap: () =>
                    _checkInternetConnection(AppNavigation.pushCreateRoom),
              ),
            ),
            Expanded(
              child: QuickActionWidget(
                icon: Icons.login_rounded,
                label: 'Join Room',
                onTap: () =>
                    _checkInternetConnection(AppNavigation.pushJoinRoom),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _checkInternetConnection(VoidCallback onSuccess) async {
    final isConnected = await Get.find<NetworkService>().isConnected();

    if (!isConnected) {
      PopupUtils.showWarning(
        'No Internet Connection. Online play requires an internet connection.',
      );
      return;
    }

    onSuccess();
  }
}
