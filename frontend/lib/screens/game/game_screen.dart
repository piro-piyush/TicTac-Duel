import 'package:tictac_duel/lib.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.room});

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      needScroll: false,
      title: 'Tic Tac Duel',
      child: Column(
        children: [
          _buildPlayers(),
          const SizedBox(height: 20),
          Expanded(child: _buildBoardPlaceholder()),
          _buildRoomInfo(),
        ],
      ),
    );
  }

  Widget _buildPlayers() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: _buildPlayerCard(
            player: room.players[0],
            isTurn: room.turnIndex == 0,
          ),
        ),
        Expanded(
          child: room.players.length > 1
              ? _buildPlayerCard(
                  player: room.players[1],
                  isTurn: room.turnIndex == 1,
                )
              : _buildWaitingCard(),
        ),
      ],
    );
  }

  Widget _buildPlayerCard({required PlayerModel player, required bool isTurn}) {
    final color = player.symbol == PlayerSymbol.x
        ? Themes.neonCyan
        : Themes.neonPink;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isTurn ? color : Themes.border,
          width: isTurn ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            player.symbol == PlayerSymbol.x
                ? Icons.close_rounded
                : Icons.circle_outlined,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Themes.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${player.points} PTS',
                  style: const TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Themes.border),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.person_add_alt_1_rounded,
            color: Themes.textSecondary,
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'WAITING FOR PLAYER',
              style: TextStyle(
                color: Themes.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardPlaceholder() {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Themes.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Themes.border),
        ),
        child: const Center(
          child: Text(
            'GAME BOARD',
            style: TextStyle(
              color: Themes.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text(
            'ROUND ${room.currentRound}/${room.maxRounds}',
            style: const TextStyle(
              color: Themes.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Themes.neonPurple,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            room.code,
            style: const TextStyle(
              color: Themes.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
