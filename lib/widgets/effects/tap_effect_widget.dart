import 'package:tictac_duel/lib.dart';

class TapEffect {
  const TapEffect({
    required this.position,
    required this.color,
    required this.controller,
  });

  final Offset position;
  final Color color;
  final AnimationController controller;
}

class TapEffectWidget extends StatelessWidget {
  const TapEffectWidget({super.key, required this.effect});

  static const double _initialRadius = 7.0;
  static const double _radiusGrowth = 52.0;
  static const double _borderWidth = 1.5;
  static const double _glowBlurRadius = 18.0;
  static const double _glowSpreadRadius = 3.0;
  static const double _borderOpacityFactor = 0.7;
  static const double _glowOpacityFactor = 0.3;

  final TapEffect effect;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: effect.controller,
    builder: (context, child) {
      final progress = Curves.easeOutCubic.transform(effect.controller.value);

      final radius = _initialRadius + (progress * _radiusGrowth);
      final opacity = 1.0 - progress;

      return Positioned(
        left: effect.position.dx - radius,
        top: effect.position.dy - radius,
        child: IgnorePointer(
          child: RepaintBoundary(
            child: _buildRipple(radius: radius, opacity: opacity),
          ),
        ),
      );
    },
  );

  Widget _buildRipple({required double radius, required double opacity}) {
    final borderColor = effect.color.withValues(
      alpha: opacity * _borderOpacityFactor,
    );

    final glowColor = effect.color.withValues(
      alpha: opacity * _glowOpacityFactor,
    );

    return SizedBox.square(
      dimension: radius * 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: _borderWidth),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: _glowBlurRadius,
              spreadRadius: _glowSpreadRadius,
            ),
          ],
        ),
      ),
    );
  }
}
