import 'package:tictac_duel/lib.dart';

class NeonTextButton extends StatelessWidget {
  const NeonTextButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    super.key,
  }) : icon = null,
       iconAlignment = null;

  const NeonTextButton.icon({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.color,
    this.isLoading = false,
    this.iconAlignment,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      style: color == null ? null : TextStyle(color: color),
    );

    return icon == null
        ? TextButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading ? _loader : label,
          )
        : TextButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading ? _loader : Icon(icon),
            label: label,
            iconAlignment: iconAlignment,
          );
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
