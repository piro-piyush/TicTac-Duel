import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class NeonBackgroundWidget extends StatefulWidget {
  const NeonBackgroundWidget({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.showGrid = true,
    this.showParticles = true,
    this.needScroll = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final bool showGrid;
  final bool needScroll;
  final bool showParticles;
  final List<Widget>? actions;

  @override
  State<NeonBackgroundWidget> createState() => _NeonBackgroundWidgetState();
}

class _NeonBackgroundWidgetState extends State<NeonBackgroundWidget>
    with TickerProviderStateMixin {
  final List<_TapEffect> _tapEffects = [];

  void _handleTap(PointerDownEvent event) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    final effect = _TapEffect(
      position: event.localPosition,
      color: _randomNeonColor(),
      controller: controller,
    );

    setState(() {
      _tapEffects.add(effect);
    });

    controller.forward().whenCompleteOrCancel(() {
      if (!mounted) {
        return;
      }
      if (!_tapEffects.contains(effect)) {
        return;
      }
      setState(() {
        _tapEffects.remove(effect);
      });
      controller.dispose();
    });
  }

  Color _randomNeonColor() {
    final colors = [Themes.neonCyan, Themes.neonPink, Themes.neonPurple];

    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    for (final effect in List<_TapEffect>.from(_tapEffects)) {
      effect.controller.dispose();
    }
    _tapEffects.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      body: Listener(
        onPointerDown: _handleTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Base background
            const ColoredBox(color: Themes.background),

            // Ambient neon glows
            const Positioned(
              top: -140,
              right: -100,
              child: _NeonGlow(color: Themes.neonPurple, size: 300),
            ),

            const Positioned(
              bottom: -150,
              left: -120,
              child: _NeonGlow(color: Themes.neonCyan, size: 320),
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

            // Grid
            if (widget.showGrid)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _NeonGridPainter()),
                ),
              ),

            // Particles
            if (widget.showParticles)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _NeonParticlePainter()),
                ),
              ),

            // Tap effects
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: [
                    for (final effect in _tapEffects)
                      _TapEffectWidget(effect: effect),
                  ],
                ),
              ),
            ),

            // Vignette
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

            // Foreground
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Dimens.fourHundredSixty,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        if (widget.title != null) _buildAppBar(context),

                        Expanded(
                          child: widget.needScroll
                              ? SingleChildScrollView(
                                  padding: widget.padding?? Dimens.defaultPadding ,
                                  child: widget.child,
                                )
                              : Padding(
                                  padding:
                                      widget.padding ?? Dimens.defaultPadding,
                                  child: widget.child,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Themes.textPrimary),

          Text(
            widget.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Themes.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),

          if (widget.actions != null)
            Row(children: widget.actions!)
          else
            const SizedBox(),
        ],
      ),
    );
  }
}

class _TapEffect {
  _TapEffect({
    required this.position,
    required this.color,
    required this.controller,
  });

  final Offset position;
  final Color color;
  final AnimationController controller;
}

class _TapEffectWidget extends StatelessWidget {
  const _TapEffectWidget({required this.effect});

  final _TapEffect effect;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: effect.controller,
      builder: (context, child) {
        final progress = Curves.easeOutCubic.transform(effect.controller.value);

        final radius = 8.0 + (progress * 55.0);

        final opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Positioned(
          left: effect.position.dx - radius,
          top: effect.position.dy - radius,
          child: IgnorePointer(
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: effect.color.withValues(alpha: opacity * 0.65),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: effect.color.withValues(alpha: opacity * 0.35),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
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

    final colors = [Themes.neonCyan, Themes.neonPurple, Themes.neonPink];

    for (var i = 0; i < 35; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.5 + random.nextDouble() * 1.2;
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color.withValues(alpha: 0.08 + random.nextDouble() * 0.12);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
