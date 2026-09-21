import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class NeonBackgroundWidget extends StatelessWidget {
  const NeonBackgroundWidget({
    super.key,
    required this.child,
    this.showGrid = true,
    this.showParticles = true,
  });

  final Widget child;
  final bool showGrid;
  final bool showParticles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(
          color: Themes.background,
        ),

        // Ambient neon glow.
        const Positioned(
          top: -140,
          right: -100,
          child: _NeonGlow(
            color: Themes.neonPurple,
            size: 300,
          ),
        ),

        const Positioned(
          bottom: -150,
          left: -120,
          child: _NeonGlow(
            color: Themes.neonCyan,
            size: 320,
          ),
        ),

        const Positioned(
          top: 260,
          left: -180,
          child: _NeonGlow(
            color: Themes.neonPink,
            size: 260,
            opacity: 0.025,
          ),
        ),

        if (showGrid)
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _NeonGridPainter(),
              ),
            ),
          ),

        if (showParticles)
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _NeonParticlePainter(),
              ),
            ),
          ),

        // Vignette keeps the edges darker.
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    Colors.transparent,
                    Color(0x22000000),
                    Color(0x66000000),
                  ],
                  stops: [0.45, 0.78, 1.0],
                ),
              ),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

class _NeonGlow extends StatelessWidget {
  const _NeonGlow({
    required this.color,
    required this.size,
    this.opacity = 0.07,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 120,
              spreadRadius: 45,
            ),
          ],
        ),
      ),
    );
  }
}

class _NeonGridPainter extends CustomPainter {
  const _NeonGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Themes.neonCyan.withValues(alpha: 0.025)
      ..strokeWidth = 1;

    const spacing = 42.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NeonParticlePainter extends CustomPainter {
  const _NeonParticlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    final colors = [
      Themes.neonCyan,
      Themes.neonPurple,
      Themes.neonPink,
    ];

    for (var i = 0; i < 35; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.5 + random.nextDouble() * 1.2;
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color.withValues(
          alpha: 0.08 + random.nextDouble() * 0.12,
        );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}