import 'package:tictac_duel/lib.dart';

class SelectionCardWidget extends StatelessWidget {
  const SelectionCardWidget({
    super.key,
    required this.difficulty,
    required this.onDifficultyChanged,
    required this.isSelected,
  });

  final CpuDifficulty difficulty;
  final ValueChanged<CpuDifficulty> onDifficultyChanged;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => SectionTileWidget.withSelect(
    borderRadius: Dimens.radius14,
    onTap: () => onDifficultyChanged(difficulty),
    isSelected: isSelected,
    title: difficulty.name,
    subtitle: difficulty.description,
    icon: difficulty.icon,
    color: difficulty.color,
  );
}
