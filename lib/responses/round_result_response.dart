import 'package:tictac_duel/lib.dart';

class RoundResultResponse {
  const RoundResultResponse({
    required this.winnerId,
    required this.roundStatus,
    required this.winningIndexes,
    required this.gameFinished,
  });

  final String? winnerId;
  final RoundStatus? roundStatus;
  final List<int> winningIndexes;
  final bool gameFinished;

  factory RoundResultResponse.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid round result response');
    }

    final winnerId = json['winnerId'];
    final roundStatus = json['roundStatus'];
    final winningIndexesData = json['winningIndexes'];
    final gameFinished = json['gameFinished'];

    if (winnerId != null && winnerId is! String) {
      throw const FormatException('Invalid winner ID');
    }

    if (roundStatus != null && roundStatus is! String) {
      throw const FormatException('Invalid round status');
    }

    if (winningIndexesData is! List) {
      throw const FormatException('Invalid winning indexes');
    }

    if (winningIndexesData.any((index) => index is! int)) {
      throw const FormatException('Winning indexes must contain only integers');
    }

    if (gameFinished is! bool) {
      throw const FormatException('Invalid game finished value');
    }

    return RoundResultResponse(
      winnerId: winnerId as String?,
      roundStatus: roundStatus != null
          ? RoundStatus.values.byName(roundStatus as String)
          : null,
      winningIndexes: List<int>.from(winningIndexesData),
      gameFinished: gameFinished,
    );
  }
}
