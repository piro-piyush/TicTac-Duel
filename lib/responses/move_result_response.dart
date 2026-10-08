class MoveResultResponse {
  const MoveResultResponse({
    required this.index,
    required this.playerId,
    required this.turnPlayerId,
  });

  final int index;
  final String playerId;
  final String? turnPlayerId;

  factory MoveResultResponse.fromSocket(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid move result response');
    }

    final index = json['index'];
    final playerId = json['playerId'];
    final turnPlayerId = json['turnPlayerId'];

    if (index is! int) {
      throw const FormatException('Invalid move index');
    }

    if (playerId is! String || playerId.isEmpty) {
      throw const FormatException('Invalid move player ID');
    }

    if (turnPlayerId != null &&
        (turnPlayerId is! String || turnPlayerId.isEmpty)) {
      throw const FormatException('Invalid turn player ID');
    }

    return MoveResultResponse(
      index: index,
      playerId: playerId,
      turnPlayerId: turnPlayerId as String?,
    );
  }
}
