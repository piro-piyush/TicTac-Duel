import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class WaitingForPlayersWidget extends StatefulWidget {
  const WaitingForPlayersWidget({
    super.key,
    required this.host,
    required this.guest,
    required this.playerId,
    required this.roomCode,
    required this.status,
    required this.hostReady,
    required this.guestReady,
    required this.onStartGame,
  });

  final PlayerModel host;
  final PlayerModel? guest;

  final String playerId;
  final String roomCode;

  final RoomStatus status;

  final bool hostReady;
  final bool guestReady;

  final VoidCallback onStartGame;

  @override
  State<WaitingForPlayersWidget> createState() =>
      _WaitingForPlayersWidgetState();
}

class _WaitingForPlayersWidgetState extends State<WaitingForPlayersWidget>
    with TickerProviderStateMixin {
  static const _waitingAnimationDuration = Duration(seconds: 2);
  static const _opponentAnimationDuration = Duration(milliseconds: 600);

  late final AnimationController _waitingAnimationController;
  late final AnimationController _opponentAnimationController;

  late final Animation<double> _opponentScale;
  late final Animation<double> _opponentFade;
  late final Animation<Offset> _opponentSlide;

  bool get _isHost => widget.host.id == widget.playerId;

  bool get _hasOpponent => widget.guest != null;

  bool get _isWaiting => widget.status == RoomStatus.waiting;

  bool get _isResult => widget.status == RoomStatus.result;

  bool get _isMyReady {
    if (widget.host.id == widget.playerId) {
      return widget.hostReady;
    }

    if (widget.guest?.id == widget.playerId) {
      return widget.guestReady;
    }

    return false;
  }

  bool get _bothPlayersReady =>
      _hasOpponent && widget.hostReady && widget.guestReady;

  @override
  void initState() {
    super.initState();

    _waitingAnimationController = AnimationController(
      vsync: this,
      duration: _waitingAnimationDuration,
    )..repeat();

    _opponentAnimationController = AnimationController(
      vsync: this,
      duration: _opponentAnimationDuration,
    );

    _opponentScale = CurvedAnimation(
      parent: _opponentAnimationController,
      curve: Curves.easeOutBack,
    );

    _opponentFade = CurvedAnimation(
      parent: _opponentAnimationController,
      curve: Curves.easeOut,
    );

    _opponentSlide =
        Tween<Offset>(begin: const Offset(0.35, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _opponentAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    if (_hasOpponent) {
      _opponentAnimationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant WaitingForPlayersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hadOpponent = oldWidget.guest != null;

    if (!hadOpponent && _hasOpponent) {
      _opponentAnimationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _waitingAnimationController.dispose();
    _opponentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlayers(),
            const SizedBox(height: Dimens.spaceBtwSections),
            _buildStatus(),
            const SizedBox(height: Dimens.spaceBtwItems),
            _buildAction(),
            const SizedBox(height: Dimens.spaceBtwSections),
            if (_isWaiting && !_hasOpponent) ...[_buildRoomCode()],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayers() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _hasOpponent ? _buildConnectedPlayers() : _buildWaitingPlayer(),
    );
  }

  Widget _buildConnectedPlayers() {
    final guest = widget.guest;

    if (guest == null) {
      return _buildWaitingPlayer();
    }

    return Row(
      key: const ValueKey('connected-players'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayerColumn(widget.host),
        const SizedBox(width: Dimens.spaceBtwSections),
        _buildGuestColumn(guest),
      ],
    );
  }

  Widget _buildWaitingPlayer() {
    return Column(
      key: const ValueKey('waiting-player'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlayerColumn(widget.host),
      ],
    );
  }

  Widget _buildPlayerColumn(PlayerModel player) {
    final isMe = player.id == widget.playerId;
    final isReady = player.id == widget.host.id
        ? widget.hostReady
        : widget.guestReady;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerAvatarWidget(
          player: player,
          isMe: isMe,
        ),
        const SizedBox(height: Dimens.spaceBtwItems),
        _buildPlayerName(player),
        if (_isResult) ...[
          const SizedBox(height: Dimens.eight),
          _buildReadyStatus(isReady),
        ],
      ],
    );
  }

  Widget _buildGuestColumn(PlayerModel player) {
    return FadeTransition(
      opacity: _opponentFade,
      child: SlideTransition(
        position: _opponentSlide,
        child: ScaleTransition(
          scale: _opponentScale,
          child: _buildPlayerColumn(player),
        ),
      ),
    );
  }

  Widget _buildPlayerName(PlayerModel player) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.four,
      children: [
        Text(
          player.name,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'PLAYER ${player.symbol.value.toUpperCase()}',
          style: textTheme.labelSmall?.copyWith(
            color: _symbolColor(player.symbol),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildReadyStatus(bool isReady) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isReady ? Icons.check_circle_rounded : Icons.schedule_rounded,
          color: isReady ? AppColors.neonGreen : AppColors.textSecondary,
          size: Dimens.iconXs,
        ),
        const SizedBox(width: Dimens.four),
        Text(
          isReady ? 'READY' : 'NOT READY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isReady ? AppColors.neonGreen : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    if (_isResult && !_isMyReady) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.six,
      children: [
        if (!_hasOpponent)
          _buildWaitingIndicator()
        else
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.neonGreen,
            size: Dimens.iconLg,
          ),
        Text(
          _statusTitle,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            _statusSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingIndicator() {
    return SizedBox.square(
      dimension: Dimens.sixtyFour,
      child: AnimatedBuilder(
        animation: _waitingAnimationController,
        builder: (context, child) {
          return CustomPaint(
            painter: WaitingIndicatorPainter(
              progress: _waitingAnimationController.value,
            ),
            child: child,
          );
        },
        child: const Icon(
          Icons.people_outline_rounded,
          color: AppColors.neonPurple,
          size: Dimens.iconMd,
        ),
      ),
    );
  }

  Widget _buildAction() {
    if (!_hasOpponent) {
      return const SizedBox.shrink();
    }

    // Result dialog handles SET_READY.
    // This widget only shows the waiting state after
    // the current player has closed the result dialog.
    if (_isResult) {
      if (!_isMyReady || _bothPlayersReady) {
        return const SizedBox.shrink();
      }

      return _buildWaitingForOtherPlayer();
    }

    if (_isWaiting && _isHost) {
      return ElevatedButton.icon(
        onPressed: widget.onStartGame,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('START GAME'),
      );
    }

    return _buildWaitingForHost();
  }

  Widget _buildWaitingForOtherPlayer() {
    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets14,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: Dimens.radius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.neonCyan,
            size: Dimens.iconSm,
          ),
          const SizedBox(width: Dimens.eight),
          Flexible(
            child: Text(
              'WAITING FOR OTHER PLAYER',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForHost() {
    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets14,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: Dimens.radius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.neonCyan,
            size: Dimens.iconSm,
          ),
          const SizedBox(width: Dimens.eight),
          Flexible(
            child: Text(
              'WAITING FOR HOST TO START',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCode() {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.eight,
      children: [
        Text(
          'ROOM CODE',
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        Material(
          color: AppColors.card,
          borderRadius: Dimens.radius12,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _copyRoomCode,
            child: Padding(
              padding: Dimens.edgeInsets12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.roomCode,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.neonCyan,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: Dimens.eight),
                  const Icon(
                    Icons.copy_rounded,
                    color: AppColors.neonCyan,
                    size: Dimens.iconSm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get _statusTitle {
    if (!_hasOpponent) {
      return 'WAITING FOR PLAYER';
    }

    if (_isResult) {
      return _isMyReady ? 'WAITING FOR OTHER PLAYER' : '';
    }

    return _isHost ? 'PLAYER JOINED' : 'WAITING FOR HOST';
  }

  String get _statusSubtitle {
    if (!_hasOpponent) {
      return 'Share your room code to invite a player';
    }

    if (_isResult) {
      return _isMyReady
          ? 'Waiting for the other player to finish the round.'
          : '';
    }

    return _isHost
        ? 'Your opponent has joined. Start the game when ready.'
        : 'Waiting for the host to start.';
  }

  Color _symbolColor(PlayerSymbol symbol) {
    return symbol == PlayerSymbol.x ? AppColors.neonCyan : AppColors.neonPink;
  }

  void _copyRoomCode() {
    Clipboard.setData(ClipboardData(text: widget.roomCode));

    PopupUtils.showToast('Room code copied');
  }
}
