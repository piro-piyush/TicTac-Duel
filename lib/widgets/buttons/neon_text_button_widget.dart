import 'package:tictac_duel/lib.dart';

class NeonTextButton extends StatelessWidget {
  const NeonTextButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    this.isSmall = false,
    super.key,
  }) : icon = null,
       iconAlignment = null;

  const NeonTextButton.icon({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.color,
    this.isLoading = false,
    this.isSmall = false,
    this.iconAlignment,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final bool isSmall;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: color == null ? null : TextStyle(color: color),
    );

    final button = icon == null
        ? TextButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading ? _loader : text,
          )
        : TextButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading ? _loader : Icon(icon),
            label: text,
            iconAlignment: iconAlignment,
          );

    return isSmall ? button : SizedBox(width: double.infinity, child: button);
  }

  Widget get _loader => SizedBox(
    width: Dimens.iconMd,
    height: Dimens.iconMd,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: color ?? AppColors.neonPurple,
    ),
  );
}
