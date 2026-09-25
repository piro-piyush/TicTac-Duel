import 'package:tictac_duel/lib.dart';

class NeonElevatedButton extends StatelessWidget {
  const NeonElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = Themes.neonCyan,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.elevatedButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Themes.background,
          elevation: 0,
          padding: Dimens.edgeInsets24_0,
          shape: RoundedRectangleBorder(borderRadius: Dimens.radius16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Dimens.ten,
          children: [
            if (icon != null) Icon(icon, size: Dimens.iconMd),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
