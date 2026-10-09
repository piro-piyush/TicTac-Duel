import 'package:tictac_duel/lib.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key, double? size})
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
                color: AppColors.neonPurple.withValues(alpha: 0.16),
                blurRadius: 32,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.neonCyan.withValues(alpha: 0.07),
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
                      ),
                    ),
                    const Expanded(
                      child: _LogoCell(
                        icon: Icons.circle_outlined,
                        color: AppColors.neonPink,
                        delay: AnimationConstants.staggerShort,
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
                      ),
                    ),
                    const Expanded(
                      child: _LogoCell(
                        icon: Icons.close_rounded,
                        color: AppColors.neonCyan,
                        delay: AnimationConstants.staggerLong,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // Main logo entrance.
        .animate()
        .fadeIn(
          duration: AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        )
        .scale(
          begin: const Offset(
            AnimationConstants.scaleSmall,
            AnimationConstants.scaleSmall,
          ),
          end: const Offset(
            AnimationConstants.scaleNormal,
            AnimationConstants.scaleNormal,
          ),
          duration: AnimationConstants.long,
          curve: AnimationConstants.entranceCurve,
        )
        // Gentle floating effect after the entrance.
        .then()
        .moveY(
          begin: 0,
          end: -size * 0.035,
          duration: AnimationConstants.extraLong,
          curve: Curves.easeInOut,
        )
        .moveY(
          begin: -size * 0.035,
          end: 0,
          duration: AnimationConstants.extraLong,
          curve: Curves.easeInOut,
        )
        .then()
        .shimmer(
          duration: AnimationConstants.extraLong,
          color: AppColors.neonCyan.withValues(alpha: 0.16),
        );
  }
}

class _LogoCell extends StatelessWidget {
  const _LogoCell({
    required this.icon,
    required this.color,
    required this.delay,
  });

  final IconData icon;
  final Color color;
  final Duration delay;

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
        )
        // Each cell enters in sequence.
        .animate(delay: delay)
        .fadeIn(
          duration: AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        )
        .scale(
          begin: const Offset(0.4, 0.4),
          end: const Offset(1, 1),
          duration: AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        )
        .rotate(
          begin: -0.08,
          end: 0,
          duration: AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        );
  }
}
