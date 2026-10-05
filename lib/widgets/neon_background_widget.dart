import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class NeonBackgroundWidget extends StatefulWidget {
  const NeonBackgroundWidget({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.bottom,
    this.bottomNavigationBar,
    this.showGrid = true,
    this.showParticles = true,
    this.needScroll = true,
    this.keyboardAware = false,
    this.showTapEffects = true,
    this.showVignette = true,
    this.maxWidth,
    this.floatingActionButton,
  });

  final Widget child;
  final PreferredSizeWidget? bottom;
  final String? title;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  final bool showGrid;
  final bool showParticles;
  final bool needScroll;
  final bool keyboardAware;
  final bool showTapEffects;
  final bool showVignette;

  final double? maxWidth;

  @override
  State<NeonBackgroundWidget> createState() => _NeonBackgroundWidgetState();
}

class _NeonBackgroundWidgetState extends State<NeonBackgroundWidget>
    with TickerProviderStateMixin {
  // ===========================================================================
  // CONFIG
  // ===========================================================================

  static const int _maxTapEffects = 8;

  static const Duration _tapEffectDuration = Duration(milliseconds: 650);

  static const double _gridSpacing = Dimens.fortyTwo;

  // ===========================================================================
  // STATE
  // ===========================================================================

  final List<TapEffect> _tapEffects = <TapEffect>[];

  final math.Random _random = math.Random();

  // ===========================================================================
  // TAP EFFECT
  // ===========================================================================

  void _handlePointerDown(PointerDownEvent event) {
    if (!mounted || !widget.showTapEffects) {
      return;
    }

    _removeOldestTapEffectIfNeeded();

    final controller = AnimationController(
      vsync: this,
      duration: _tapEffectDuration,
    );

    final effect = TapEffect(
      position: event.localPosition,
      color: _randomNeonColor,
      controller: controller,
    );

    setState(() {
      _tapEffects.add(effect);
    });

    controller.forward().whenCompleteOrCancel(() {
      _removeTapEffect(effect);
    });
  }

  void _removeOldestTapEffectIfNeeded() {
    if (_tapEffects.length < _maxTapEffects) {
      return;
    }

    final oldestEffect = _tapEffects.removeAt(0);

    oldestEffect.controller.dispose();
  }

  void _removeTapEffect(TapEffect effect) {
    // If the effect was already removed, its controller has already
    // been disposed. Do nothing.
    if (!_tapEffects.remove(effect)) {
      return;
    }

    effect.controller.dispose();

    if (mounted) {
      setState(() {});
    }
  }

  Color get _randomNeonColor {
    const colors = AppColors.neonColors;

    if (colors.isEmpty) {
      return AppColors.neonCyan;
    }

    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    for (final effect in _tapEffects) {
      effect.controller.dispose();
    }

    _tapEffects.clear();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      floatingActionButton:widget.floatingActionButton,
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _BackgroundBase(),

            const _AmbientGlows(),

            if (widget.showGrid) const _GridLayer(),

            if (widget.showParticles) const _ParticleLayer(),

            if (widget.showTapEffects && _tapEffects.isNotEmpty)
              _TapEffectsLayer(effects: _tapEffects),

            if (widget.showVignette) const _VignetteLayer(),

            _ForegroundLayer(
              title: widget.title,
              bottom: widget.bottom,
              actions: widget.actions,
              padding: widget.padding,
              bottomNavigationBar: widget.bottomNavigationBar,
              needScroll: widget.needScroll,
              keyboardAware: widget.keyboardAware,
              maxWidth: widget.maxWidth,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND BASE
// =============================================================================

class _BackgroundBase extends StatelessWidget {
  const _BackgroundBase();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppColors.background);
  }
}

// =============================================================================
// AMBIENT GLOWS
// =============================================================================

class _AmbientGlows extends StatelessWidget {
  const _AmbientGlows();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -150,
          right: -110,
          child: NeonGlowWidget(
            color: AppColors.neonPurple,
            size: 320,
            opacity: 0.075,
            blurRadius: 130,
          ),
        ),
        Positioned(
          bottom: -170,
          left: -130,
          child: NeonGlowWidget(
            color: AppColors.neonCyan,
            size: 340,
            opacity: 0.065,
            blurRadius: 140,
          ),
        ),
        Positioned(
          top: 250,
          left: -190,
          child: NeonGlowWidget(
            color: AppColors.neonPink,
            size: 280,
            opacity: 0.025,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// GRID
// =============================================================================

class _GridLayer extends StatelessWidget {
  const _GridLayer();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: NeonGridPainter(
              spacing: _NeonBackgroundWidgetState._gridSpacing,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PARTICLES
// =============================================================================

class _ParticleLayer extends StatelessWidget {
  const _ParticleLayer();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: NeonParticlePainter(colors: AppColors.neonColors),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TAP EFFECTS
// =============================================================================

class _TapEffectsLayer extends StatelessWidget {
  const _TapEffectsLayer({required this.effects});

  final List<TapEffect> effects;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final effect in effects)
              TapEffectWidget(key: ObjectKey(effect), effect: effect),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// VIGNETTE
// =============================================================================

class _VignetteLayer extends StatelessWidget {
  const _VignetteLayer();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.9,
              colors: [
                Colors.transparent,
                Color(0x18000000),
                Color(0x52000000),
              ],
              stops: [0.45, 0.76, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FOREGROUND
// =============================================================================

class _ForegroundLayer extends StatelessWidget {
  const _ForegroundLayer({
    required this.child,
    required this.title,
    required this.actions,
    required this.padding,
    required this.bottom,
    required this.bottomNavigationBar,
    required this.needScroll,
    required this.keyboardAware,
    required this.maxWidth,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final PreferredSizeWidget? bottom;
  final Widget? bottomNavigationBar;
  final bool needScroll;
  final bool keyboardAware;
  final double? maxWidth;

  double _getMaxWidth(double screenWidth) {
    if (maxWidth != null) {
      return maxWidth!;
    }

    if (screenWidth < Dimens.mobileBreakpoint) {
      return screenWidth;
    }

    if (screenWidth < Dimens.tabletBreakpoint) {
      return Dimens.tabletMaxContentWidth;
    }

    return Dimens.desktopMaxContentWidth;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final contentMaxWidth = _getMaxWidth(screenSize.width);

    return Positioned.fill(
      child: SafeArea(
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentMaxWidth,
                  maxHeight: constraints.maxHeight,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      _NeonAppBar(
                        title: title,
                        bottom: bottom,
                        actions: actions,
                      ),
                      Expanded(
                        child: _NeonContent(
                          padding: padding,
                          needScroll: needScroll,
                          keyboardAware: keyboardAware,
                          child: child,
                        ),
                      ),
                      if (bottomNavigationBar != null)
                        _NeonBottomNavigation(
                          navigationBar: bottomNavigationBar!,
                          padding: padding,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
// =============================================================================
// APP BAR
// =============================================================================

class _NeonAppBar extends StatelessWidget {
  const _NeonAppBar({required this.title, required this.actions, this.bottom});

  final String? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      child: AppBar(
        title: title != null
            ? Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        actions: actions,
        bottom: bottom,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
// =============================================================================
// CONTENT
// =============================================================================

class _NeonContent extends StatelessWidget {
  const _NeonContent({
    required this.child,
    required this.padding,
    required this.needScroll,
    required this.keyboardAware,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool needScroll;
  final bool keyboardAware;

  EdgeInsets get _contentPadding {
    return padding ?? Dimens.defaultPadding;
  }

  @override
  Widget build(BuildContext context) {
    if (needScroll) {
      return _buildScrollableContent();
    }

    if (!keyboardAware) {
      return Padding(padding: _contentPadding, child: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: _contentPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - _contentPadding.vertical,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: _contentPadding,
      child: child,
    );
  }
}
// =============================================================================
// BOTTOM NAVIGATION
// =============================================================================

class _NeonBottomNavigation extends StatelessWidget {
  const _NeonBottomNavigation({
    required this.navigationBar,
    required this.padding,
  });

  final Widget navigationBar;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final contentPadding = padding ?? Dimens.defaultPadding;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: contentPadding.left,
          right: contentPadding.right,
          bottom: contentPadding.bottom / 2,
        ),
        child: navigationBar,
      ),
    );
  }
}
