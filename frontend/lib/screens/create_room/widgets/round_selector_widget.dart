import 'package:tictac_duel/lib.dart';

class RoundSelectorWidget extends StatelessWidget {
  const RoundSelectorWidget({
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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.eight,
      children: [
        SectionTitleWidget(title: 'ROUNDS'),

        Container(
          padding: Dimens.edgeInsets6,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: Dimens.radius14,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: roundOptions.map((rounds) {
              final isSelected = rounds == selectedRounds;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onRoundChanged(rounds),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: Dimens.edgeInsets0_12,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.neonPurple.withValues(alpha: 0.18)
                          : Colors.transparent,
                      borderRadius: Dimens.radius10,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.neonPurple
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      spacing: Dimens.two,
                      children: [
                        Text(
                          '$rounds',
                          style: textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          rounds == 1 ? 'ROUND' : 'ROUNDS',
                          style: textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? AppColors.neonPurple
                                : AppColors.textSecondary,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
