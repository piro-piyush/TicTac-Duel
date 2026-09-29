import 'package:tictac_duel/lib.dart';

class HeaderSectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const HeaderSectionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.fourteen,
      children: [
        Container(
          width: Dimens.fortyEight,
          height: Dimens.fortyEight,
          decoration: BoxDecoration(
            color: AppColors.neonCyan.withValues(alpha: 0.08),
            borderRadius: Dimens.radius14,
            border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, color: AppColors.neonCyan),
        ),
        Expanded(
          child: Column(
            spacing: Dimens.two,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
