import 'package:tictac_duel/lib.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key, double? size})
    : size = size ?? Dimens.oneHundredTwenty;

  final double size;

  @override
  Widget build(BuildContext context) =>
      Container(
            key: const ValueKey('app-logo'),
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(size * 0.23),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.22),
                  blurRadius: 32,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: AppColors.neonCyan.withValues(alpha: 0.12),
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
                      const Expanded(
                        child: _LogoCell(
                          icon: Icons.close_rounded,
                          color: AppColors.neonCyan,
                          delay: Duration.zero,
                          rotation: -0.35,
                        ),
                      ),
                      const Expanded(
                        child: _LogoCell(
                          icon: Icons.circle_outlined,
                          color: AppColors.neonPink,
                          delay: AnimationConstants.staggerShort,
                          rotation: 0.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    spacing: size * 0.07,
                    children: [
                      const Expanded(
                        child: _LogoCell(
                          icon: Icons.circle_outlined,
                          color: AppColors.neonPink,
                          delay: AnimationConstants.staggerMedium,
                          rotation: -0.35,
                        ),
                      ),
                      const Expanded(
                        child: _LogoCell(
                          icon: Icons.close_rounded,
                          color: AppColors.neonCyan,
                          delay: AnimationConstants.staggerLong,
                          rotation: 0.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          // Strong entrance: fade, zoom, and overshoot.
          .animate()
          .fadeIn(duration: AnimationConstants.medium, curve: Curves.easeOut)
          .scale(
            begin: const Offset(0.25, 0.25),
            end: const Offset(1, 1),
            duration: AnimationConstants.long,
            curve: Curves.elasticOut,
          )
          // Pronounced floating motion.
          .then()
          .moveY(
            begin: 0,
            end: -size * 0.07,
            duration: AnimationConstants.extraLong,
            curve: Curves.easeInOut,
          )
          .moveY(
            begin: -size * 0.07,
            end: 0,
            duration: AnimationConstants.extraLong,
            curve: Curves.easeInOut,
          )
          // Repeat the floating cycle.
          .then()
          .shimmer(
            duration: AnimationConstants.long,
            color: AppColors.neonCyan.withValues(alpha: 0.35),
          );
}

class _LogoCell extends StatelessWidget {
  const _LogoCell({
    required this.icon,
    required this.color,
    required this.delay,
    required this.rotation,
  });

  final IconData icon;
  final Color color;
  final Duration delay;
  final double rotation;

  @override
  Widget build(BuildContext context) =>
      Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: Dimens.radius10,
              border: Border.all(color: color.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.16),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: color, size: Dimens.iconLg),
            ),
          )
          // Each cell pops in with a larger rotation.
          .animate(delay: delay)
          .fadeIn(duration: AnimationConstants.medium, curve: Curves.easeOut)
          .scale(
            begin: const Offset(0.1, 0.1),
            end: const Offset(1, 1),
            duration: AnimationConstants.long,
            curve: Curves.elasticOut,
          )
          .rotate(
            begin: rotation,
            end: 0,
            duration: AnimationConstants.long,
            curve: Curves.elasticOut,
          );
}
