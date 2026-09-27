import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class WaitingForPlayersWidget extends StatefulWidget {
  const WaitingForPlayersWidget({
    super.key,
    required this.room,
    required this.playerId,
    required this.waitingForNextRound,
    required this.onStartGame,
  });

  final RoomModel room;
  final String playerId;
  final bool waitingForNextRound;
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

  List<PlayerModel> get _players => widget.room.players;

  int get _playerCount => _players.length;

  bool get _isHost => widget.room.hostPlayerId == widget.playerId;

  bool get _hasOpponent =>
      _playerCount == GameConstants.maxPlayers && _opponent != null;

  PlayerModel? get _myPlayer {
    for (final player in _players) {
      if (player.id == widget.playerId) {
        return player;
      }
    }

    return null;
  }

  PlayerModel? get _opponent {
    for (final player in _players) {
      if (player.id != widget.playerId) {
        return player;
      }
    }

    return null;
  }

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

    final hadOpponent =
        oldWidget.room.players.length == GameConstants.maxPlayers;

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
    final player = _myPlayer;

    if (player == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlayers(player),
            SizedBox(height: Dimens.spaceBtwSections),
            _buildStatus(),
            SizedBox(height: Dimens.spaceBtwItems),
            _buildAction(),
            SizedBox(height: Dimens.spaceBtwSections),
            _buildRoomCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayers(PlayerModel myPlayer) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _hasOpponent
          ? _buildConnectedPlayers(myPlayer)
          : _buildWaitingPlayer(myPlayer),
    );
  }

  Widget _buildWaitingPlayer(PlayerModel player) {
    return Column(
      key: const ValueKey('waiting-player'),
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerAvatarWidget(player: player, isMe: true, isTurn: false),
        SizedBox(height: Dimens.spaceBtwItems),
        _buildPlayerName(player),
      ],
    );
  }

  Widget _buildConnectedPlayers(PlayerModel myPlayer) {
    final opponent = _opponent;

    if (opponent == null) {
      return _buildWaitingPlayer(myPlayer);
    }

    return Row(
      key: const ValueKey('connected-players'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayerColumn(player: myPlayer, isMe: true),
        SizedBox(width: Dimens.spaceBtwSections),
        _buildOpponentColumn(opponent),
      ],
    );
  }

  Widget _buildPlayerColumn({required PlayerModel player, required bool isMe}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerAvatarWidget(player: player, isMe: isMe, isTurn: false),
        SizedBox(height: Dimens.spaceBtwItems),
        _buildPlayerName(player),
      ],
    );
  }

  Widget _buildOpponentColumn(PlayerModel player) {
    return FadeTransition(
      opacity: _opponentFade,
      child: SlideTransition(
        position: _opponentSlide,
        child: ScaleTransition(
          scale: _opponentScale,
          child: _buildPlayerColumn(player: player, isMe: false),
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

  Widget _buildStatus() {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.six,
      children: [
        if (!_hasOpponent)
          _buildWaitingIndicator()
        else
          Icon(
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
        child: Icon(
          Icons.people_outline_rounded,
          color: AppColors.neonPurple,
          size: Dimens.iconMd,
        ),
      ),
    );
  }

  Widget _buildAction() {
    // Nobody should have an action while waiting for the second player.
    if (!_hasOpponent) {
      return const SizedBox.shrink();
    }

    // Only the host can start the game.
    if (_isHost) {
      return ElevatedButton.icon(
        onPressed: widget.onStartGame,
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          widget.waitingForNextRound ? 'START NEXT ROUND' : 'START GAME',
        ),
      );
    }

    // Joiner waits for the host.
    return _buildWaitingForHost();
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
          Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.neonCyan,
            size: Dimens.iconSm,
          ),
          SizedBox(width: Dimens.eight),
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
                    widget.room.roomCode,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.neonCyan,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(width: Dimens.eight),
                  Icon(
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
    // Host has created the room and is waiting for someone to join.
    if (!_hasOpponent) {
      return _isHost ? 'WAITING FOR PLAYER' : 'WAITING FOR HOST';
    }

    // Both players are connected.
    if (widget.waitingForNextRound) {
      return _isHost ? 'READY FOR NEXT ROUND' : 'WAITING FOR NEXT ROUND';
    }

    // Initial game: opponent has joined.
    return _isHost ? 'PLAYER JOINED' : 'WAITING FOR HOST';
  }

  String get _statusSubtitle {
    // Only the host can be alone in the room.
    if (!_hasOpponent) {
      return _isHost
          ? 'Share your room code to invite a player'
          : 'Waiting for the host to start the game';
    }

    // Next round.
    if (widget.waitingForNextRound) {
      return _isHost
          ? 'Both players are back. Start when you are ready.'
          : 'Waiting for the host to start the next round';
    }

    // Initial game.
    return _isHost
        ? 'Your opponent has joined. Start the game when ready.'
        : 'Waiting for the host to start.';
  }

  Color _symbolColor(PlayerSymbol symbol) {
    return symbol == PlayerSymbol.x ? AppColors.neonCyan : AppColors.neonPink;
  }

  void _copyRoomCode() {
    Clipboard.setData(ClipboardData(text: widget.room.roomCode));

    SnackbarUtils.showSuccess('Room code copied');
  }
}
