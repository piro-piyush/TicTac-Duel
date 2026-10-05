import 'package:tictac_duel/lib.dart';

class GameReactionEvent {
  const GameReactionEvent({
    required this.reaction,
    required this.senderId,
    required this.targetPlayerId,
  });

  final GameReaction reaction;
  final String senderId;
  final String targetPlayerId;

  factory GameReactionEvent.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid game reaction response');
    }

    final reaction = json['reaction'];
    final senderId = json['senderId'];
    final targetPlayerId = json['targetPlayerId'];

    if (reaction is! String || reaction.isEmpty) {
      throw const FormatException('Invalid reaction');
    }

    if (senderId is! String || senderId.isEmpty) {
      throw const FormatException('Invalid sender ID');
    }

    if (targetPlayerId is! String || targetPlayerId.isEmpty) {
      throw const FormatException('Invalid target player ID');
    }

    final parsedReaction = GameReaction.values
        .where((item) => item.name == reaction)
        .firstOrNull;

    if (parsedReaction == null) {
      throw FormatException('Unknown reaction: $reaction');
    }

    return GameReactionEvent(
      reaction: parsedReaction,
      senderId: senderId,
      targetPlayerId: targetPlayerId,
    );
  }
}
