import 'package:tictac_duel/lib.dart';

class HomeActionsWidget extends ConsumerWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(appNavigationProvider);
    final networkService = ref.read(networkServiceProvider);

    return Column(
      spacing: Dimens.sixteen,
      children: [
        Column(
          spacing: Dimens.fourteen,
          children: [
            // MenuButtonWidget(
            //   title: 'Quick Match',
            //   subtitle: 'Find an opponent and play',
            //   icon: Icons.bolt_rounded,
            //   color: AppColors.neonCyan,
            //   onTap: () => _checkInternetConnection(
            //     networkService,
            //     () => PopupUtils.showWarning('Coming Soon...'),
            //   ),
            // ),
            MenuButtonWidget(
              title: 'Local Game',
              subtitle: 'Play with a friend or challenge the CPU',
              icon: Icons.smartphone_rounded,
              color: AppColors.neonPurple,
              onTap: navigation.pushLocalGame,
            ),
            MenuButtonWidget(
              title: 'Public Rooms',
              subtitle: 'Browse and join open rooms',
              icon: Icons.public_rounded,
              color: AppColors.neonGreen,
              onTap: () => _checkInternetConnection(
                networkService,
                navigation.pushPublicRooms,
              ),
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
                onTap: () => _checkInternetConnection(
                  networkService,
                  navigation.pushCreateRoom,
                ),
              ),
            ),
            Expanded(
              child: QuickActionWidget(
                icon: Icons.login_rounded,
                label: 'Join Room',
                onTap: () => _checkInternetConnection(
                  networkService,
                  navigation.pushJoinRoom,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _checkInternetConnection(
    NetworkService networkService,
    VoidCallback onSuccess,
  ) async {
    final isConnected = await networkService.isConnected();

    if (!isConnected) {
      PopupUtils.showWarning(
        'No Internet Connection. Online play requires an internet connection.',
      );
      return;
    }

    onSuccess();
  }
}
