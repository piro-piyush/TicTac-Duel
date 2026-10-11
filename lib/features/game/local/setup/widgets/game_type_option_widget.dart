import 'package:tictac_duel/lib.dart';

class GameTypeOptionWidget extends StatelessWidget {
  const GameTypeOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: Dimens.radius16,
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: Dimens.edgeInsets16,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.neonPurple.withValues(alpha: 0.12)
            : AppColors.card,
        borderRadius: Dimens.radius16,
        border: Border.all(
          color: isSelected ? AppColors.neonPurple : AppColors.border,
        ),
      ),
      child: Column(
        spacing: Dimens.spaceBtwItems,
        children: [
          Icon(
            icon,
            size: Dimens.iconXl,
            color: isSelected ? AppColors.neonPurple : AppColors.textSecondary,
          ),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}
