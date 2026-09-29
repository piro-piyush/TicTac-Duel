import 'dart:math';

class GameNameUtils {
  GameNameUtils._();

  static final Random _random = Random();

  static const _prefixes = [
    'Neon',
    'Cyber',
    'Shadow',
    'Pixel',
    'Nova',
    'Cosmic',
    'Mystic',
    'Turbo',
    'Phantom',
    'Vortex',
    'Blaze',
    'Frost',
    'Quantum',
    'Rogue',
    'Arc',
  ];

  static const _suffixes = [
    'Fox',
    'Wolf',
    'Knight',
    'Ninja',
    'Duelist',
    'Runner',
    'Hunter',
    'Master',
    'Striker',
    'Wizard',
    'Ace',
    'Titan',
    'Ghost',
    'Dragon',
    'Rival',
  ];

  static String random() {
    final prefix = _prefixes[_random.nextInt(_prefixes.length)];
    final suffix = _suffixes[_random.nextInt(_suffixes.length)];
    final number = _random.nextInt(100);

    return '$prefix$suffix$number';
  }
}
