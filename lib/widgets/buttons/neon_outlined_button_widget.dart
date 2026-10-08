import 'package:tictac_duel/lib.dart';

class NeonOutlinedButtonWidget extends StatelessWidget {
  const NeonOutlinedButtonWidget({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    super.key,
  }) : icon = null,
       iconAlignment = null;

  const NeonOutlinedButtonWidget.icon({
    required this.label,
    required this.onPressed,
    required IconData this.icon,
    this.isLoading = false,
    this.color,
    super.key,
    this.iconAlignment,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final label = Text(this.label);
    return icon == null
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading ? _loader : label,
          )
        : OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading ? _loader : Icon(icon),
            label: label,
            iconAlignment: iconAlignment,
          );
  }

  Widget get _loader => const SizedBox(
    width: Dimens.iconMd,
    height: Dimens.iconMd,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
