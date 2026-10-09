import 'package:tictac_duel/lib.dart';

class ReactionReceivedResponse {
  const ReactionReceivedResponse({
    required this.reaction,
    required this.senderId,
    required this.targetPlayerId,
  });

  final GameReaction reaction;
  final String senderId;
  final String targetPlayerId;

  factory ReactionReceivedResponse.fromSocket(dynamic json) {
    try {
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

      final parsedReaction = GameReactionX.tryParse(reaction);

      if (parsedReaction == null) {
        throw FormatException('Unknown reaction: $reaction');
      }

      return ReactionReceivedResponse(
        reaction: parsedReaction,
        senderId: senderId,
        targetPlayerId: targetPlayerId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
