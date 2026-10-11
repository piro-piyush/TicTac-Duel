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
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    minTileHeight: 0,
    horizontalTitleGap: Dimens.twelve,
    leading: Icon(icon, color: AppColors.textSecondary, size: Dimens.iconMd),
    title: Text(
      title,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
    ),
  );
}
