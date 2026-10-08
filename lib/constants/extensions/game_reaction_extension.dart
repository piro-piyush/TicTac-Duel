import 'package:tictac_duel/lib.dart';

extension GameReactionX on GameReaction {
  String get emoji => switch (this) {
    GameReaction.laugh => '😂',
    GameReaction.love => '❤️',
    GameReaction.angry => '😡',
    GameReaction.wow => '😮',
    GameReaction.fire => '🔥',
    GameReaction.clap => '👏',
    GameReaction.party => '🎉',
    GameReaction.cool => '😎',
  };

  String get animation => switch (this) {
    GameReaction.laugh =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f602/lottie.json',
    GameReaction.love =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/2764_fe0f/lottie.json',
    GameReaction.angry =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f620/lottie.json',
    GameReaction.wow =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f62f/lottie.json',
    GameReaction.fire =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f525/lottie.json',
    GameReaction.clap =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f44f/lottie.json',
    GameReaction.party =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f389/lottie.json',
    GameReaction.cool =>
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f60e/lottie.json',
  };
}
