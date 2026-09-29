import 'package:tictac_duel/lib.dart';

class GameDifficultySectionWidget extends StatelessWidget {
  const GameDifficultySectionWidget({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  final CpuDifficulty selectedDifficulty;
  final ValueChanged<CpuDifficulty> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.spaceBtwItems,
      children: [
        const SectionTitleWidget(title: 'DIFFICULTY'),
        ...CpuDifficulty.values.map(
          (difficulty) => SelectionCardWidget(
            difficulty: difficulty,
            isSelected: difficulty == selectedDifficulty,
            onDifficultyChanged: onDifficultyChanged,
          ),
        ),
      ],
    );
  }
}
