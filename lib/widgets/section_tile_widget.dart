import 'package:tictac_duel/lib.dart';

class SectionTileWidget extends StatelessWidget {
  const SectionTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.tileColor,
    this.trailing,
    this.onTap,
    this.borderRadius,
    this.borderColor,
  }) : _type = SectionTileType.normal,
       value = false,
       isSelected = false, actionIcon  = null,
       onChanged = null;

  const SectionTileWidget.withSwitch({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
    this.tileColor,
    this.borderRadius,
    this.borderColor,
  }) : _type = SectionTileType.switchTile,
       trailing = null, actionIcon  = null,
       isSelected = false,
       onTap = null;

  const SectionTileWidget.withAction({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.tileColor,
    this.actionIcon,
    this.borderRadius,
    this.borderColor,
  }) : _type = SectionTileType.action,
       value = false,
       isSelected = false,
       trailing = null,
       onChanged = null;

  const SectionTileWidget.withSelect({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.tileColor,
    this.borderRadius,
    this.borderColor,
  }) : _type = SectionTileType.select,
       value = false,
       trailing = null,
        actionIcon  = null,
       onChanged = null;

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color? tileColor;

  final bool value;
  final bool isSelected;

  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final Widget? trailing;

  final BorderRadius? borderRadius;
  final Color? borderColor;
  final IconData? actionIcon;
  final SectionTileType _type;

  BorderRadius get _resolvedBorderRadius => borderRadius ?? Dimens.radius14;

  bool get _hasSelection => _type == SectionTileType.select && isSelected;

  Color? get _resolvedBorderColor {
    if (_hasSelection) {
      return borderColor ?? color.withValues(alpha: 0.6);
    }

    return borderColor;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = _resolvedBorderRadius;

    return Material(
      color: tileColor ?? AppColors.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: _resolvedBorderColor != null
              ? Border.all(color: _resolvedBorderColor!)
              : null,
          boxShadow: _buildBoxShadow(),
        ),
        child: InkWell(
          borderRadius: radius,
          splashColor: color.withValues(alpha: 0.08),
          highlightColor: color.withValues(alpha: 0.04),
          child: ListTile(
            onTap: onTap ?? () {},
            contentPadding: Dimens.edgeInsets16_4,
            leading: Icon(icon, color: color),
            title: Text(title, style: textTheme.labelLarge),
            subtitle: Text(subtitle, style: textTheme.bodySmall),
            trailing: _buildTrailing(),
          ),
        ),
      ),
    );
  }

  List<BoxShadow>? _buildBoxShadow() {
    if (!_hasSelection) {
      return null;
    }

    return [
      BoxShadow(
        color: color.withValues(alpha: 0.12),
        blurRadius: 16,
        spreadRadius: -4,
      ),
    ];
  }

  Widget? _buildTrailing() {
    switch (_type) {
      case SectionTileType.normal:
        return trailing;

      case SectionTileType.switchTile:
        return Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: color.withValues(alpha: 0.35),
          activeThumbColor: color,
          inactiveTrackColor: AppColors.card,
          inactiveThumbColor: AppColors.disabled,
        );

      case SectionTileType.action:
        return Icon(
          actionIcon ?? Icons.chevron_right_rounded,
          color: color,
        );

      case SectionTileType.select:
        return _SelectionIndicator(color: color, isSelected: isSelected);
    }
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.color, required this.isSelected});

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: Dimens.iconLg,
      height: Dimens.iconLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? color : Colors.transparent,
        border: Border.all(
          color: isSelected ? color : AppColors.border,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: isSelected
            ? const Icon(
                Icons.check_rounded,
                key: ValueKey('selected'),
                size: 16,
                color: Colors.white,
              )
            : const SizedBox(key: ValueKey('unselected')),
      ),
    );
  }
}

enum SectionTileType { normal, switchTile, action, select }
