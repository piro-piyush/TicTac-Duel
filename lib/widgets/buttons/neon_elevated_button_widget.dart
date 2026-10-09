import 'package:tictac_duel/lib.dart';

class NeonElevatedButton extends StatelessWidget {
  const NeonElevatedButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isSmall = false,
    super.key,
  }) : icon = null,
       iconAlignment = null;

  const NeonElevatedButton.icon({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.isSmall = false,
    this.iconAlignment,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSmall;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    final button = icon == null
        ? ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading ? _loader : Text(label),
          )
        : ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading ? _loader : Icon(icon),
            label: Text(label),
            iconAlignment: iconAlignment,
          );

    return isSmall ? button : SizedBox(width: double.infinity, child: button);
  }

  Widget get _loader => const SizedBox(
    width: Dimens.iconMd,
    height: Dimens.iconMd,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
