import 'package:tictac_duel/lib.dart';

class NeonOutlinedButtonWidget extends StatelessWidget {
  const NeonOutlinedButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : null,
      label: Text(label, style: TextStyle(color: color)),
    );
  }
}
