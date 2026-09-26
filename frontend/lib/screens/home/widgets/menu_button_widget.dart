import 'package:tictac_duel/lib.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Themes.surface,
      shape: RoundedRectangleBorder(
        borderRadius: Dimens.radius16,
        side: const BorderSide(color: Themes.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: Dimens.edgeInsets16_4,
        splashColor: color.withValues(alpha: 0.08),
        hoverColor: color.withValues(alpha: 0.04),
        leading: _IconContainer(icon: icon, color: color),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall,
        ),
        trailing: const Icon(
          Icons.arrow_forward_rounded,
          color: Themes.textSecondary,
        ),
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.fiftySix,
      height: Dimens.fiftySix,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: Dimens.radius16,
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Icon(icon, color: color, size: Dimens.iconLg),
    );
  }
}
