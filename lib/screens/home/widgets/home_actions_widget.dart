import 'package:tictac_duel/lib.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuButtonWidget(
      title: 'Local Game',
      subtitle: 'Play with a friend or challenge the CPU',
      icon: Icons.smartphone_rounded,
      color: AppColors.neonPurple,
      onTap: AppNavigation.pushGame,
    );
  }
}
