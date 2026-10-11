import 'package:tictac_duel/lib.dart';

class ResultScoreCardWidget extends StatelessWidget {
  const ResultScoreCardWidget({
    super.key,
    required this.state,
    required this.isPlayerOneMe,
    required this.isPlayerTwoMe,
    required this.isOnline,
  });

  final ResultModel state;
  final bool isPlayerOneMe;
  final bool isPlayerTwoMe;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final players = _buildPlayers();

    return Container(
      padding: Dimens.edgeInsets12_8,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Dimens.radius16,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildPlayerTile(players[0]),
          const Divider(color: AppColors.border),
          _buildPlayerTile(players[1]),
        ],
      ),
    );
  }

  List<({PlayerModel player, int points, bool isMe})> _buildPlayers() {
    final players = [
      (player: state.host, points: state.hostPoints, isMe: isPlayerOneMe),
      (player: state.guest, points: state.guestPoints, isMe: isPlayerTwoMe),
    ];

    final winnerId = state.gameWinner?.id;

    if (winnerId == null) {
      return players;
    }

    players.sort((a, b) => _winnerFirst(a.player.id, b.player.id, winnerId));

    return players;
  }

  int _winnerFirst(String firstId, String secondId, String winnerId) {
    if (firstId == winnerId) return -1;
    if (secondId == winnerId) return 1;

    return 0;
  }

  Widget _buildPlayerTile(({PlayerModel player, int points, bool isMe}) data) =>
      PlayerScoreTileWidget(
        player: data.player,
        points: data.points,
        isWinner: data.player.id == state.gameWinner?.id,
        isMe: data.isMe,
        isOnline: isOnline,
      );
}
