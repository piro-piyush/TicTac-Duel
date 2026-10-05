import 'dart:math' as math;

import 'package:tictac_duel/lib.dart';

class GamePlayerCardWidget extends StatefulWidget {
  const GamePlayerCardWidget({
    super.key,
    required this.player,
    required this.points,
    required this.isMe,
    required this.isTurn,
    required this.theme,
    required this.compact,
    this.isOnline = false,
  });

  final PlayerModel player;
  final int points;
  final bool Function(String id) isMe;
  final bool isTurn;
  final RoomTheme theme;
  final bool compact;
  final bool isOnline;

  @override
  State<GamePlayerCardWidget> createState() => _GamePlayerCardWidgetState();
}

class _GamePlayerCardWidgetState extends State<GamePlayerCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool get _isMe => widget.isMe(widget.player.id);

  Color get _color => widget.player.symbol == PlayerSymbol.x
      ? widget.theme.primary
      : widget.theme.secondary;

  double get _borderRadius => widget.compact ? 13 : 16;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isTurn) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GamePlayerCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTurn && !oldWidget.isTurn) {
      _animationController
        ..reset()
        ..repeat();
    } else if (!widget.isTurn && oldWidget.isTurn) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = widget.compact ? 40.0 : 48.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: widget.isTurn
              ? TurnBorderPainter(
                  progress: _animationController.value,
                  color: _color,
                  borderRadius: _borderRadius,
                )
              : null,
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 7 : 10,
          vertical: widget.compact ? 7 : 9,
        ),
        decoration: BoxDecoration(
          color: widget.isTurn
              ? _color.withValues(alpha: 0.075)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(_borderRadius),
          // IMPORTANT:
          // Always keep exactly the same border width.
          border: Border.all(
            color: widget.isTurn
                ? _color.withValues(alpha: 0.18)
                : AppColors.border,
          ),
          boxShadow: [
            if (widget.isTurn)
              BoxShadow(
                color: _color.withValues(alpha: 0.12),
                blurRadius: 18,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          spacing: widget.compact ? 6 : 9,
          children: [
            _buildAvatar(avatarSize),
            Flexible(
              child: Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildPlayerHeader(), _buildPlayerStatus()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: widget.isTurn
            ? [
                BoxShadow(
                  color: _color.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: PlayerAvatarWidget(
        player: widget.player,
        isMe: _isMe,
        isTurn: widget.isTurn,
        size: size,
      ),
    );
  }

  Widget _buildPlayerHeader() {
    return Row(
      spacing: Dimens.six,
      children: [
        Flexible(
          child: Text(
            widget.player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: widget.compact ? Dimens.ten : Dimens.twelve,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (widget.isOnline) _buildPlayerBadge(),
      ],
    );
  }

  Widget _buildPlayerBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? Dimens.four : Dimens.six,
        vertical: Dimens.two,
      ),
      decoration: BoxDecoration(
        color: _isMe ? _color.withValues(alpha: 0.12) : AppColors.card,
        borderRadius: Dimens.radius6,
        border: Border.all(
          color: _isMe ? _color.withValues(alpha: 0.30) : AppColors.border,
        ),
      ),
      child: Text(
        _isMe ? 'YOU' : 'OPPONENT',
        style: TextStyle(
          color: _isMe ? _color : AppColors.textSecondary,
          fontSize: widget.compact ? 6 : 7,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _buildPlayerStatus() {
    return Row(
      spacing: Dimens.six,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            color: _color,
            fontSize: widget.compact ? 8 : 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
          child: Text(widget.player.symbol.value.toUpperCase()),
        ),

        if (widget.isTurn) _buildTurnIndicator(),

        const Spacer(),

        _buildPoints(),
      ],
    );
  }

  Widget _buildTurnIndicator() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final pulse =
            0.65 + (math.sin(_animationController.value * math.pi * 2) * 0.35);

        return Opacity(
          opacity: pulse.clamp(0.45, 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: _color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _color.withValues(alpha: 0.8),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              Text(
                'TURN',
                style: TextStyle(
                  color: _color,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPoints() {
    return TweenAnimationBuilder<int>(
      key: ValueKey(widget.points),
      tween: IntTween(
        begin: widget.points > 0 ? widget.points - 1 : 0,
        end: widget.points,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return AnimatedScale(
          scale: value == widget.points && widget.points > 0 ? 1.0 : 0.88,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            constraints: BoxConstraints(minWidth: widget.compact ? 22 : 26),
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 5 : 6,
              vertical: widget.compact ? 2 : 3,
            ),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: widget.isTurn ? 0.14 : 0.10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _color.withValues(alpha: widget.isTurn ? 0.40 : 0.25),
              ),
              boxShadow: widget.isTurn
                  ? [
                      BoxShadow(
                        color: _color.withValues(alpha: 0.12),
                        blurRadius: 7,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _color,
                fontSize: widget.compact ? 10 : 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      },
    );
  }
}
