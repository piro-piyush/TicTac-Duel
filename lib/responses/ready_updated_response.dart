class ReadyUpdatedResponse {
  const ReadyUpdatedResponse({required this.playerId, required this.isReady});

  final String playerId;
  final bool isReady;

  factory ReadyUpdatedResponse.fromSocket(dynamic json) {
    try {
      if (json is! Map) {
        throw const FormatException('Invalid ready updated response');
      }

      final playerId = json['playerId'];
      final isReady = json['isReady'];

      if (playerId is! String) {
        throw const FormatException('Invalid player ID');
      }

      if (isReady is! bool) {
        throw const FormatException('Invalid ready state');
      }

      return ReadyUpdatedResponse(playerId: playerId, isReady: isReady);
    } catch (e) {
      rethrow;
    }
  }
}
