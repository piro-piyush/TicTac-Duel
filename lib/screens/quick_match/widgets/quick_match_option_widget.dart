import 'package:tictac_duel/lib.dart';

class QuickMatchOptionWidget extends StatelessWidget {
  const QuickMatchOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets20_24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.card, AppColors.card.withValues(alpha: 0.72)],
        ),
        borderRadius: Dimens.radius16,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        spacing: Dimens.spaceBtwItems,
        children: [
          _buildIcon(),
          _buildContent(theme),
          SizedBox(
            width: double.infinity,
            child: NeonElevatedButton(
              label: buttonLabel,
              icon: icon,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: Dimens.icon4Xl,
      height: Dimens.icon4Xl,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.neonCyan.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.18),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, size: Dimens.icon2Xl, color: AppColors.neonCyan),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      spacing: Dimens.spaceBtwItems,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
