import 'package:tictac_duel/lib.dart';

class NeonElevatedButton extends StatelessWidget {
  const NeonElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.neonCyan,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: Dimens.iconMd,
              height: Dimens.iconMd,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          : Icon(icon, size: Dimens.iconMd),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
