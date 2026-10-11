import 'package:tictac_duel/lib.dart';

extension GameReactionX on GameReaction {
  String get emoji => switch (this) {
    // Emotions
    GameReaction.laugh => '😂',
    GameReaction.angry => '😡',
    GameReaction.cool => '😎',
    GameReaction.cry => '😭',

    GameReaction.mindBlown => '🤯',
    GameReaction.sick => '🤢',
    GameReaction.sleepy => '😴',

    // Celebration
    GameReaction.fire => '🔥',
    GameReaction.clap => '👏',

    GameReaction.confetti => '🎉',

    GameReaction.ez => '😏',
    GameReaction.oops => '😬',

    GameReaction.clown => '🤡',

    // Friendly
    GameReaction.wave => '👋',

    GameReaction.lightning => '⚡',
    GameReaction.bomb => '💣',
    // Fun
    GameReaction.wink => '😉',
    GameReaction.tongue => '😛',
    GameReaction.poop => '💩',
    GameReaction.monkey => '🙈',
    // Hearts
    GameReaction.heart => '❤️',
    GameReaction.brokenHeart => '💔',
    GameReaction.kiss => '😘',
    GameReaction.rose => '🌹',
    GameReaction.eyes => '👀',
  };

  String get animationUrl {
    final codePoints = emoji.runes
        .map((rune) => rune.toRadixString(16))
        .join('_');

    return 'https://fonts.gstatic.com/s/e/notoemoji/latest/'
        '$codePoints/lottie.json';
  }

  static GameReaction? tryParse(String emoji) {
    for (final reaction in GameReaction.values) {
      if (reaction.emoji == emoji) {
        return reaction;
      }
    }

    return null;
  }
}
