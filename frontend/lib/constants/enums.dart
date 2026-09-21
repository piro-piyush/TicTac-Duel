import 'dart:ui';

import 'package:tictac_duel/lib.dart';

enum RoomTheme {
  classic(
    value: 'classic',
    name: 'Classic',
    subtitle: 'Cyan & Purple',
    primary: Themes.neonCyan,
    secondary: Themes.neonPurple,
  ),
  inferno(
    value: 'inferno',
    name: 'Inferno',
    subtitle: 'Pink & Red',
    primary: Themes.neonPink,
    secondary: Color(0xFFFF4D4D),
  ),
  cyber(
    value: 'cyber',
    name: 'Cyber',
    subtitle: 'Green & Cyan',
    primary: Themes.neonGreen,
    secondary: Themes.neonCyan,
  );

  const RoomTheme({
    required this.value,
    required this.name,
    required this.subtitle,
    required this.primary,
    required this.secondary,
  });

  final String value;
  final String name;
  final String subtitle;
  final Color primary;
  final Color secondary;

  static RoomTheme fromValue(String value) {
    return RoomTheme.values.firstWhere(
          (theme) => theme.value == value,
      orElse: () => RoomTheme.classic,
    );
  }
}

enum PlayerSymbol {
  x(
    name: 'Cross',
    value: 'x',
  ),
  o(
    name: 'Circle',
    value: 'o',
  );

  const PlayerSymbol({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  static PlayerSymbol fromValue(String value) {
    return PlayerSymbol.values.firstWhere(
          (symbol) => symbol.value == value.toLowerCase(),
      orElse: () => PlayerSymbol.x,
    );
  }
}

enum GameMode {
  classic('classic'),
  blitz('blitz');

  const GameMode(this.value);

  final String value;

  static GameMode fromValue(String value) {
    return GameMode.values.firstWhere(
          (mode) => mode.value == value,
      orElse: () => GameMode.classic,
    );
  }
}