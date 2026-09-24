import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class WaitingForPlayersWidget extends StatefulWidget {
  const WaitingForPlayersWidget({
    super.key,
    required this.room,
    required this.waitingForNextRound,
  });

  final RoomModel room;
  final bool waitingForNextRound;

  @override
  State<WaitingForPlayersWidget> createState() =>
      _WaitingForPlayersWidgetState();
}

class _WaitingForPlayersWidgetState extends State<WaitingForPlayersWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.room.players.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height - 120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerAvatarWidget(
              player: player,
              isMe: true,
              isTurn: false,
            ),
            const SizedBox(height: 16),
            _buildPlayerName(player),
            const SizedBox(height: 36),
            _buildWaitingIndicator(),
            const SizedBox(height: 18),
            _buildWaitingInfo(),
            const SizedBox(height: 32),
            _buildRoomCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerName(PlayerModel player) {
    final color = player.symbol == PlayerSymbol.x
        ? Themes.neonCyan
        : Themes.neonPink;

    return Column(
      children: [
        Text(
          player.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Themes.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PLAYER ${player.symbol.value.toUpperCase()}',
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingIndicator() {
    return SizedBox(
      width: 54,
      height: 54,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: _WaitingIndicatorPainter(
              progress: _animationController.value,
            ),
            child: child,
          );
        },
        child: Icon(
          _waitingIcon,
          color: Themes.neonPurple,
          size: 21,
        ),
      ),
    );
  }

  IconData get _waitingIcon {
    if (widget.waitingForNextRound) {
      return Icons.replay_rounded;
    }

    if (widget.room.players.length < 2) {
      return Icons.people_outline_rounded;
    }

    final readyPlayers = widget.room.players
        .where((player) => player.isReady)
        .length;

    if (readyPlayers == 2) {
      return Icons.play_arrow_rounded;
    }

    if (readyPlayers == 1) {
      return Icons.person_outline_rounded;
    }

    return Icons.sports_esports_outlined;
  }

  Widget _buildWaitingInfo() {
    final title = _waitingTitle;
    final subtitle = _waitingSubtitle;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Themes.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Themes.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String get _waitingTitle {
    if (widget.waitingForNextRound) {
      return 'WAITING FOR NEXT ROUND';
    }

    if (widget.room.players.length < 2) {
      return 'WAITING FOR PLAYER';
    }

    final readyPlayers = widget.room.players
        .where((player) => player.isReady)
        .length;

    if (readyPlayers == 2) {
      return 'STARTING ROUND';
    }

    if (readyPlayers == 1) {
      return 'WAITING FOR PLAYER TO READY';
    }

    return 'READY UP TO START';
  }

  String get _waitingSubtitle {
    if (widget.waitingForNextRound) {
      return 'Both players need to ready up for the next round';
    }

    if (widget.room.players.length < 2) {
      return 'Share your room code to invite a player';
    }

    final readyPlayers = widget.room.players
        .where((player) => player.isReady)
        .length;

    if (readyPlayers == 2) {
      return 'Both players are ready';
    }

    if (readyPlayers == 1) {
      return 'Waiting for the other player to ready up';
    }

    return 'Both players must ready up to begin';
  }

  Widget _buildRoomCode() {
    return Column(
      spacing: 8,
      children: [
        const Text(
          'ROOM CODE',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            iconAlignment: IconAlignment.end,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            backgroundColor: Themes.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Themes.border,
              ),
            ),
          ),
          onPressed: _copyRoomCode,
          icon: const Icon(
            Icons.copy_rounded,
            color: Themes.neonCyan,
            size: 18,
          ),
          label: Text(
            widget.room.code,
            style: const TextStyle(
              color: Themes.neonCyan,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
            ),
          ),
        ),
      ],
    );
  }

  void _copyRoomCode() {
    Clipboard.setData(
      ClipboardData(text: widget.room.code),
    );

    SnackbarUtils.showSuccess(
      context,
      'Room code copied',
    );
  }
}

class _WaitingIndicatorPainter extends CustomPainter {
  const _WaitingIndicatorPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 3;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Themes.border;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Themes.neonPurple;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      progress * 2 * 3.14159265359,
      4.2,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _WaitingIndicatorPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}