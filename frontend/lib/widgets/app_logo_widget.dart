import 'package:tictac_duel/lib.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.15),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(size * 0.23),
        border: Border.all(color: Themes.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Themes.neonPurple.withValues(alpha: 0.12),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Themes.neonCyan.withValues(alpha: 0.05),
            blurRadius: 18,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        spacing: size * 0.07,
        children: [
          Expanded(
            child: Row(
              spacing: size * 0.07,
              children: [
                Expanded(
                  child: _LogoCell(
                    icon: Icons.close_rounded,
                    color: Themes.neonCyan,
                  ),
                ),
                Expanded(
                  child: _LogoCell(
                    icon: Icons.circle_outlined,
                    color: Themes.neonPink,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: size * 0.07,
              children: [
                Expanded(
                  child: _LogoCell(
                    icon: Icons.circle_outlined,
                    color: Themes.neonPink,
                  ),
                ),
                Expanded(
                  child: _LogoCell(
                    icon: Icons.close_rounded,
                    color: Themes.neonCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoCell extends StatelessWidget {
  const _LogoCell({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: Center(child: Icon(icon, color: color, size: 26)),
    );
  }
}
