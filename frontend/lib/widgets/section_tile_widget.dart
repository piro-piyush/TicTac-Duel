import 'package:tictac_duel/lib.dart';

class SectionTileWidget extends StatelessWidget {
  const SectionTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : _type = SectionTileType.none,
       value = false,
       onChanged = null,
       onTap = null;

  const SectionTileWidget.withSwitch({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.onChanged,
  }) : _type = SectionTileType.switchTile,
       onTap = null;

  const SectionTileWidget.withAction({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : _type = SectionTileType.action,
       value = false,
       onChanged = null;

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  final SectionTileType _type;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: Dimens.edgeInsets16_4,
      leading: Icon(icon, color: color),
      title: Text(title, style: textTheme.labelLarge),
      subtitle: Text(subtitle, style: textTheme.bodySmall),
      trailing: _buildTrailing(),
    );
  }

  Widget? _buildTrailing() {
    switch (_type) {
      case SectionTileType.switchTile:
        return Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: color.withValues(alpha: 0.35),
          activeThumbColor: color,
          inactiveTrackColor: Themes.card,
          inactiveThumbColor: Themes.disabled,
        );
      case SectionTileType.action:
        return Icon(Icons.chevron_right_rounded, color: color);
      case SectionTileType.none:
        return null;
    }
  }
}

enum SectionTileType { none, switchTile, action }
