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
  late final AnimationController _glowController;

  PlayerSymbol get symbol => widget.player.symbol;

  Color get color => symbol.symbolColor;

  double get padding => widget.size * 0.025;

  double get imageSize => widget.size - (padding * 2);

  double get radius => widget.size * 0.167;

  double get imageRadius => radius - padding;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.isTurn) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PlayerAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTurn && !oldWidget.isTurn) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isTurn && oldWidget.isTurn) {
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
        final pulse = widget.isTurn
            ? Curves.easeInOut.transform(_glowController.value)
            : 0.0;

        return Container(
          width: widget.size,
          height: widget.size,
          padding: EdgeInsets.all(padding),
          decoration: _avatarDecoration(pulse),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(imageRadius),
            child: SizedBox(width: imageSize, height: imageSize, child: child),
          ),
        );
      },
      child: _buildAvatar(),
    );
  }

  BoxDecoration _avatarDecoration(double pulse) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: color.withValues(alpha: widget.isTurn ? 0.8 : 0.45),
        width: widget.isTurn ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withValues(
            alpha: widget.isTurn ? 0.20 + (pulse * 0.25) : 0.20,
          ),
          blurRadius: widget.isTurn
              ? (widget.size * 0.15) + (pulse * widget.size * 0.20)
              : widget.size * 0.15,
          spreadRadius: widget.isTurn
              ? (widget.size * 0.017) + (pulse * widget.size * 0.058)
              : widget.size * 0.017,
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return SvgPicture.network(
      widget.player.imageUrl,
      width: imageSize,
      height: imageSize,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(color: AppColors.surface),
        child: const Center(
          child: Icon(
            Icons.person_rounded,
            size: Dimens.iconLg,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
