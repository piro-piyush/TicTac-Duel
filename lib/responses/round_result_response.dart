class RoundResultResponse {
  const RoundResultResponse({
    required this.winnerPlayerId,
    required this.winningIndexes,
    required this.completedRound,
    required this.gameFinished,
  });

  final String? winnerPlayerId;
  final List<int> winningIndexes;
  final int completedRound;
  final bool gameFinished;

  factory RoundResultResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid round result response');
    }

    final winnerPlayerId = json['winnerPlayerId'];
    final winningIndexesData = json['winningIndexes'];
    final completedRound = json['completedRound'];
    final gameFinished = json['gameFinished'];

    if (winnerPlayerId != null && winnerPlayerId is! String) {
      throw const FormatException('Invalid winner player ID');
    }

    if (winningIndexesData is! List) {
      throw const FormatException('Invalid winning indexes');
    }

    if (winningIndexesData.any((index) => index is! int)) {
      throw const FormatException('Winning indexes must contain only integers');
    }

    if (completedRound is! int) {
      throw const FormatException('Invalid completed round');
    }

    if (gameFinished is! bool) {
      throw const FormatException('Invalid game finished value');
    }

    return RoundResultResponse(
      winnerPlayerId: winnerPlayerId as String?,
      winningIndexes: List<int>.from(winningIndexesData),
      completedRound: completedRound,
      gameFinished: gameFinished,
    );
  }
}
