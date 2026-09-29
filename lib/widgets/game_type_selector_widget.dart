import 'package:tictac_duel/lib.dart';

class GameTypeSelectorWidget extends StatelessWidget {
  const GameTypeSelectorWidget({
    super.key,
    required this.gameType,
    required this.onGameTypeChanged,
  });

  final LocalGameType gameType;
  final ValueChanged<LocalGameType> onGameTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.spaceBtwItems,
      children: [
        Expanded(
          child: GameTypeOptionWidget(
            icon: Icons.people_alt_rounded,
            title: 'FRIEND',
            subtitle: '2 Players',
            isSelected: gameType == LocalGameType.friend,
            onTap: () => onGameTypeChanged(LocalGameType.friend),
          ),
        ),
        Expanded(
          child: GameTypeOptionWidget(
            icon: Icons.smart_toy_rounded,
            title: 'COMPUTER',
            subtitle: 'VS CPU',
            isSelected: gameType == LocalGameType.computer,
            onTap: () => onGameTypeChanged(LocalGameType.computer),
          ),
        ),
      ],
    );
  }
}