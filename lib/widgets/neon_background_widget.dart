import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class NeonBackgroundWidget extends StatefulWidget {
  const NeonBackgroundWidget({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.bottomNavigationBar,
    this.showGrid = true,
    this.showParticles = true,
    this.needScroll = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showGrid;
  final bool showParticles;
  final bool needScroll;

  @override
  State<NeonBackgroundWidget> createState() => _NeonBackgroundWidgetState();
}

class _NeonBackgroundWidgetState extends State<NeonBackgroundWidget>
    with TickerProviderStateMixin {
  static const int _maxTapEffects = 8;
  static const Duration _tapEffectDuration = Duration(milliseconds: 650);

  final math.Random _random = math.Random();
  final List<_TapEffect> _tapEffects = [];

  static const List<Color> _neonColors = [
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonPurple,
  ];

  void _handleTap(PointerDownEvent event) {
    if (!mounted) {
      return;
    }

    final controller = AnimationController(
      vsync: this,
      duration: _tapEffectDuration,
    );

    final effect = _TapEffect(
      position: event.localPosition,
      color: _neonColors[_random.nextInt(_neonColors.length)],
      controller: controller,
    );

    // Prevent too many simultaneous animations during rapid tapping.
    if (_tapEffects.length >= _maxTapEffects) {
      final oldestEffect = _tapEffects.removeAt(0);
      oldestEffect.controller.dispose();
    }

    setState(() {
      _tapEffects.add(effect);
    });

    controller.forward().whenCompleteOrCancel(() {
      if (!mounted) {
        return;
      }

      if (!_tapEffects.remove(effect)) {
        return;
      }

      setState(() {});

      controller.dispose();
    });
  }

  @override
  void dispose() {
    for (final effect in _tapEffects) {
      effect.controller.dispose();
    }

    _tapEffects.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handleTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // -----------------------------------------------------------------
            // Background
            // -----------------------------------------------------------------

            const ColoredBox(color: AppColors.background),

            // -----------------------------------------------------------------
            // Ambient glows
            // -----------------------------------------------------------------
            const Positioned(
              top: -140,
              right: -100,
              child: _NeonGlow(color: AppColors.neonPurple, size: 300),
            ),

            const Positioned(
              bottom: -150,
              left: -120,
              child: _NeonGlow(color: AppColors.neonCyan, size: 320),
            ),

            const Positioned(
              top: 260,
              left: -180,
              child: _NeonGlow(
                color: AppColors.neonPink,
                size: 260,
                opacity: 0.025,
              ),
            ),

            // -----------------------------------------------------------------
            // Grid
            // -----------------------------------------------------------------
            if (widget.showGrid)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _NeonGridPainter()),
                ),
              ),

            // -----------------------------------------------------------------
            // Particles
            // -----------------------------------------------------------------
            if (widget.showParticles)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _NeonParticlePainter()),
                ),
              ),

            // -----------------------------------------------------------------
            // Tap effects
            // -----------------------------------------------------------------
            if (_tapEffects.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      for (final effect in _tapEffects)
                        _TapEffectWidget(
                          key: ObjectKey(effect),
                          effect: effect,
                        ),
                    ],
                  ),
                ),
              ),

            // -----------------------------------------------------------------
            // Vignette
            // -----------------------------------------------------------------
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

            // -----------------------------------------------------------------
            // Foreground
            // -----------------------------------------------------------------
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Dimens.fourHundredSixty,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        if (widget.title != null) _buildAppBar(),

                        Expanded(child: _buildContent()),

                        if (widget.bottomNavigationBar != null)
                          _buildBottomNavigationBar(),
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

  Widget _buildAppBar() {
    final title = widget.title;

    if (title == null) {
      return const SizedBox.shrink();
    }

    return AppBar(title: Text(title), actions: widget.actions);
  }

  Widget _buildContent() {
    final padding = widget.padding ?? Dimens.defaultPadding;

    if (!widget.needScroll) {
      return Padding(
        padding: padding,
        child: Center(child: widget.child),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(child: widget.child),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    final padding = widget.padding ?? Dimens.defaultPadding;

    return Padding(
      padding: padding.copyWith(top: 0, bottom: Dimens.eight),
      child: widget.bottomNavigationBar!,
    );
  }
}

// =============================================================================
// TAP EFFECT
// =============================================================================

class _TapEffect {
  const _TapEffect({
    required this.position,
    required this.color,
    required this.controller,
  });

  final Offset position;
  final Color color;
  final AnimationController controller;
}

class _TapEffectWidget extends StatelessWidget {
  const _TapEffectWidget({super.key, required this.effect});

  final _TapEffect effect;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: effect.controller,
      builder: (context, child) {
        final progress = Curves.easeOutCubic.transform(effect.controller.value);

        final radius = 8.0 + (progress * 55.0);
        final opacity = 1.0 - progress;

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

// =============================================================================
// NEON GLOW
// =============================================================================

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

// =============================================================================
// GRID
// =============================================================================

class _NeonGridPainter extends CustomPainter {
  const _NeonGridPainter();

  static const double _spacing = 42.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.025)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += _spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += _spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonGridPainter oldDelegate) {
    return false;
  }
}

// =============================================================================
// PARTICLES
// =============================================================================

class _NeonParticlePainter extends CustomPainter {
  const _NeonParticlePainter();

  static const List<Color> _colors = [
    AppColors.neonCyan,
    AppColors.neonPurple,
    AppColors.neonPink,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (var i = 0; i < 35; i++) {
      final position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      final radius = 0.5 + random.nextDouble() * 1.2;

      final paint = Paint()
        ..color = _colors[i % _colors.length].withValues(
          alpha: 0.08 + random.nextDouble() * 0.12,
        );

      canvas.drawCircle(position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonParticlePainter oldDelegate) {
    return false;
  }
}
