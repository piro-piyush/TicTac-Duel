import 'package:tictac_duel/lib.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({super.key, double? size})
    : size = size ?? Dimens.oneHundredTwenty;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size * 0.23),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.12),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.05),
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
                    color: AppColors.neonCyan,
                  ),
                ),
                Expanded(
                  child: _LogoCell(
                    icon: Icons.circle_outlined,
                    color: AppColors.neonPink,
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
                    color: AppColors.neonPink,
                  ),
                ),
                Expanded(
                  child: _LogoCell(
                    icon: Icons.close_rounded,
                    color: AppColors.neonCyan,
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
        borderRadius: Dimens.radius10,
        border: Border.all(color: color.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: Center(
        child: Icon(icon, color: color, size: Dimens.iconLg),
      ),
    );
  }
}
