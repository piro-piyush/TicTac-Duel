import 'package:tictac_duel/lib.dart';

class PlayerAvatarWidget extends StatefulWidget {
  const PlayerAvatarWidget({
    super.key,
    required this.player,
    this.isMe = false,
    this.isTurn = false,
    this.size = 120,
  });

  final PlayerModel player;
  final bool isMe;
  final bool isTurn;
  final double size;

  @override
  State<PlayerAvatarWidget> createState() => _PlayerAvatarWidgetState();
}

class _PlayerAvatarWidgetState extends State<PlayerAvatarWidget>
    with SingleTickerProviderStateMixin {
  static const _glowDuration = Duration(milliseconds: 1200);

  late final AnimationController _glowController;

  PlayerSymbol get _symbol => widget.player.symbol;

  Color get _color =>
      _symbol == PlayerSymbol.x ? AppColors.neonCyan : AppColors.neonPink;

  double get _padding => widget.size * 0.025;

  double get _radius => widget.size * 0.167;

  double get _imageRadius => _radius - _padding;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(vsync: this, duration: _glowDuration);

    _updateGlowAnimation();
  }

  @override
  void didUpdateWidget(covariant PlayerAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTurn != oldWidget.isTurn) {
      _updateGlowAnimation();
    }
  }

  void _updateGlowAnimation() {
    if (widget.isTurn) {
      _glowController.repeat(reverse: true);
    } else {
      _glowController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return _buildAvatar(pulse: _getPulse(), child: child!);
      },
      child: _buildAvatarImage(),
    );
  }

  double _getPulse() {
    if (!widget.isTurn) {
      return 0;
    }

    return Curves.easeInOut.transform(_glowController.value);
  }

  Widget _buildAvatar({required double pulse, required Widget child}) {
    final borderWidth = widget.isTurn ? 2.0 : 1.0;

    final glowAlpha = widget.isTurn ? 0.20 + (pulse * 0.25) : 0.20;

    final blurRadius = widget.isTurn
        ? (widget.size * 0.15) + (pulse * widget.size * 0.20)
        : widget.size * 0.15;

    final spreadRadius = widget.isTurn
        ? (widget.size * 0.017) + (pulse * widget.size * 0.058)
        : widget.size * 0.017;

    return SizedBox.square(
      dimension: widget.size,
      child: Padding(
        padding: EdgeInsets.all(_padding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(
              color: _color.withValues(alpha: widget.isTurn ? 0.8 : 0.45),
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: _color.withValues(alpha: glowAlpha),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_imageRadius),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    return SizedBox.square(
      dimension: widget.size - (_padding * 2),
      child: SvgPicture.asset(widget.player.avatarAsset, fit: BoxFit.cover),
    );
  }
}
