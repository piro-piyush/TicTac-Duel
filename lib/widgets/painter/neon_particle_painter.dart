import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class NeonParticlePainter extends CustomPainter {
  NeonParticlePainter({
    required this.colors,
    this.particleCount = 35,
    this.minRadius = 0.5,
    this.maxRadius = 1.7,
    this.minOpacity = 0.06,
    this.maxOpacity = 0.18,
    this.seed = 42,
  }) : _particles = _generateParticles(count: particleCount, seed: seed);

  final List<Color> colors;

  final int particleCount;
  final double minRadius;
  final double maxRadius;
  final double minOpacity;
  final double maxOpacity;
  final int seed;

  final List<_Particle> _particles;

  static List<_Particle> _generateParticles({
    required int count,
    required int seed,
  }) {
    final random = math.Random(seed);

    return List.generate(
      count,
      (_) => _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: 0.5 + random.nextDouble() * 1.2,
        opacity: 0.06 + random.nextDouble() * 0.12,
        colorIndex: random.nextInt(1000),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty || size.isEmpty) {
      return;
    }

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (final particle in _particles) {
      final color = colors[particle.colorIndex % colors.length];

      final radius = _lerp(
        minRadius,
        maxRadius,
        _normalize(particle.radius, 0.5, 1.7),
      );

      final opacity = _lerp(
        minOpacity,
        maxOpacity,
        _normalize(particle.opacity, 0.06, 0.18),
      );

      paint.color = color.withValues(alpha: opacity);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeonParticlePainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.particleCount != particleCount ||
        oldDelegate.minRadius != minRadius ||
        oldDelegate.maxRadius != maxRadius ||
        oldDelegate.minOpacity != minOpacity ||
        oldDelegate.maxOpacity != maxOpacity ||
        oldDelegate.seed != seed;
  }

  static double _normalize(double value, double min, double max) {
    if (max == min) {
      return 0;
    }

    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }

  static double _lerp(double min, double max, double value) {
    return min + ((max - min) * value);
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.colorIndex,
  });

  /// Normalized horizontal position: 0 → 1.
  final double x;

  /// Normalized vertical position: 0 → 1.
  final double y;

  final double radius;

  final double opacity;

  final int colorIndex;
}
