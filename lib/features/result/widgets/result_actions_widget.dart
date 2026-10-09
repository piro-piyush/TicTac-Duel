import 'package:tictac_duel/lib.dart';

class ResultActionsWidget extends ConsumerWidget {
  const ResultActionsWidget({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(appNavigationProvider);

    return Row(
      spacing: Dimens.sixteen,
      children: [
        Expanded(
          child: NeonOutlinedButtonWidget(
            label: 'HOME',
            onPressed: navigation.goToHome,
          ),
        ),
        Expanded(
          child: NeonElevatedButtonWidget(
            label: isOnline ? 'NEW ROOM' : 'NEW GAME',
            onPressed: () => _onNewGame(navigation),
          ),
        ),
      ],
    );
  }

  void _onNewGame(AppNavigation navigation) {
    if (isOnline) {
      navigation.goToCreateRoom();
      return;
    }

    navigation.goToLocalGame();
  }
}
