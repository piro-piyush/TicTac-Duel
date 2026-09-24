import 'package:tictac_duel/lib.dart';

class GamePlayerCardWidget extends StatelessWidget {
  final PlayerModel player;
  final String? webSocketId;
  final bool isMe;
  final bool isTurn;
  final RoomTheme theme;
  final bool compact;

  const GamePlayerCardWidget({
    super.key,
    required this.player,
    this.webSocketId,
    required this.isMe,
    required this.isTurn,
    required this.theme,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final color = player.symbol == PlayerSymbol.x
        ? theme.primary
        : theme.secondary;

    final avatarSize = compact ? 40.0 : 48.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: isTurn ? color.withValues(alpha: 0.07) : Themes.surface,
        borderRadius: BorderRadius.circular(compact ? 13 : 16),
        border: Border.all(
          color: isTurn ? color.withValues(alpha: 0.55) : Themes.border,
          width: isTurn ? 1.5 : 1,
        ),
        boxShadow: isTurn
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.10),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        spacing: compact ? 6 : 9,
        children: [
          PlayerAvatarWidget(
            player: player,
            isMe: isMe,
            isTurn: isTurn,
            size: avatarSize,
          ),
          Expanded(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Flexible(
                      child: Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Themes.textPrimary,
                          fontSize: compact ? 10 : 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 4 : 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? color.withValues(alpha: 0.12)
                            : Themes.card,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isMe
                              ? color.withValues(alpha: 0.25)
                              : Themes.border,
                        ),
                      ),
                      child: Text(
                        isMe ? 'YOU' : 'OPPONENT',
                        style: TextStyle(
                          color: isMe ? color : Themes.textSecondary,
                          fontSize: compact ? 6 : 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      player.symbol.value.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: compact ? 8 : 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (isTurn)
                      Flexible(
                        child: Text(
                          'TURN',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color.withValues(alpha: 0.8),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
