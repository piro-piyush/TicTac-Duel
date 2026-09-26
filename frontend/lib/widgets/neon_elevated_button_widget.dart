import 'package:tictac_duel/lib.dart';

class NeonElevatedButton extends StatelessWidget {
  const NeonElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.neonCyan,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: Dimens.iconMd),
      label:Text(
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
