import 'package:tictac_duel/lib.dart';

class NeonGlowWidget extends StatelessWidget {
  const NeonGlowWidget({super.key,
    required this.color,
    required this.size,
    this.opacity = 0.07,
    this.blurRadius = 120.0,
    this.spreadRadius = 40.0,
  });

  final Color color;
  final double size;
  final double opacity;
  final double blurRadius;
  final double spreadRadius;

  @override
  Widget build(BuildContext context) {
    final glowColor = color.withValues(alpha: opacity);

    return IgnorePointer(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glowColor,
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}