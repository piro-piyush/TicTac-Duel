import 'package:tictac_duel/lib.dart';

class InfoItemWidget extends StatelessWidget {
  const InfoItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textTheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.twelve,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: Dimens.iconMd),
        Expanded(
          child: Column(
            spacing: Dimens.four,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
