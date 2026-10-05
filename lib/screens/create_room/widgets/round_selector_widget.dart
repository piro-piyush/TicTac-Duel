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
        const SectionTitleWidget(
          title: 'ROUNDS',
        ),
        Container(
          padding: Dimens.edgeInsets6,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: Dimens.radius16,
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            spacing: Dimens.six,
            children: roundOptions.map((rounds) {
              final isSelected = rounds == selectedRounds;

              return Expanded(
                child: _RoundOption(
                  rounds: rounds,
                  isSelected: isSelected,
                  textTheme: textTheme,
                  onTap: () => onRoundChanged(rounds),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RoundOption extends StatelessWidget {
  const _RoundOption({
    required this.rounds,
    required this.isSelected,
    required this.textTheme,
    required this.onTap,
  });

  final int rounds;
  final bool isSelected;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: Dimens.radius12,
        splashColor: AppColors.neonPurple.withValues(alpha: 0.08),
        highlightColor: AppColors.neonPurple.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 68,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neonPurple.withValues(alpha: 0.14)
                : AppColors.surface,
            borderRadius: Dimens.radius12,
            border: Border.all(
              color: isSelected
                  ? AppColors.neonPurple.withValues(alpha: 0.75)
                  : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.neonPurple.withValues(alpha: 0.10),
                blurRadius: 12,
              ),
            ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: Dimens.two,
            children: [
              Text(
                '$rounds',
                style: textTheme.titleLarge?.copyWith(
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
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}