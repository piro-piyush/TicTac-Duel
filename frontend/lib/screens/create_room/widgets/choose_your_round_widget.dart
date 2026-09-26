import 'package:tictac_duel/lib.dart';

class ChooseYourRoundWidget extends StatelessWidget {
  const ChooseYourRoundWidget({
    super.key,
    required this.selectedRounds,
    required this.onRoundChanged,
    this.roundOptions = GameConstants.roundOptions,
  });

  final int selectedRounds;
  final ValueChanged<int> onRoundChanged;
  final List<int> roundOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.eight,
      children: [
        const Text(
          'ROUNDS',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        Container(
          padding: Dimens.edgeInsets8,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: Dimens.radius14,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: roundOptions.map((rounds) {
              final isSelected = rounds == selectedRounds;

              return RoundCardWidget(
                rounds: rounds,
                isSelected: isSelected,
                onRoundChanged: onRoundChanged,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
