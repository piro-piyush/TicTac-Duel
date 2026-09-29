import 'package:tictac_duel/lib.dart';

enum RoomTheme {
  classic(
    value: 'classic',
    name: 'Classic',
    subtitle: 'Cyan & Purple',
    primary: AppColors.neonCyan,
    secondary: AppColors.neonPurple,
  ),
  inferno(
    value: 'inferno',
    name: 'Inferno',
    subtitle: 'Pink & Red',
    primary: AppColors.neonPink,
    secondary: Color(0xFFFF4D4D),
  ),
  cyber(
    value: 'cyber',
    name: 'Cyber',
    subtitle: 'Green & Cyan',
    primary: AppColors.neonGreen,
    secondary: AppColors.neonCyan,
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
}

enum PlayerSymbol {
  x(name: 'Cross', value: 'x'),
  o(name: 'Circle', value: 'o');

  const PlayerSymbol({required this.name, required this.value});

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

enum GameResult {
  xWins(value: 'x_wins', name: 'X Wins', message: 'Player X wins the round!'),
  oWins(value: 'o_wins', name: 'O Wins', message: 'Player O wins the round!'),
  draw(value: 'draw', name: 'Draw', message: 'The round ended in a draw!'),
  inProgress(
    value: 'in_progress',
    name: 'In Progress',
    message: 'The game is still ongoing.',
  );

  const GameResult({
    required this.value,
    required this.name,
    required this.message,
  });

  final String value;
  final String name;
  final String message;

  bool get isFinished => this != GameResult.inProgress;

  bool get hasWinner => this == GameResult.xWins || this == GameResult.oWins;

  PlayerSymbol? get winner => switch (this) {
    GameResult.xWins => PlayerSymbol.x,
    GameResult.oWins => PlayerSymbol.o,
    _ => null,
  };

  static GameResult fromValue(String value) {
    return GameResult.values.firstWhere(
      (result) => result.value == value,
      orElse: () => GameResult.inProgress,
    );
  }
}

enum RoundStatus {
  waiting(value: 'waiting'),
  playing(value: 'playing'),
  result(value: 'result');

  const RoundStatus({required this.value});

  final String value;
}

enum LocalGameType {
  friend(
    value: 'friend',
    name: 'Local Friend',
    description: 'Play face-to-face with a friend on the same device.',
    icon: Icons.people_alt_rounded,
    color: AppColors.neonCyan,
  ),
  computer(
    value: 'computer',
    name: 'Computer',
    description: 'Challenge the CPU and play completely offline.',
    icon: Icons.smart_toy_rounded,
    color: AppColors.neonPink,
  );

  const LocalGameType({
    required this.value,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String value;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
}

enum CpuDifficulty {
  easy(
    value: 'easy',
    name: 'Easy',
    description: 'A relaxed opponent that makes occasional random moves.',
    icon: Icons.sentiment_satisfied_alt_rounded,
    color: AppColors.neonGreen,
  ),
  medium(
    value: 'medium',
    name: 'Medium',
    description: 'A balanced opponent that can attack and defend.',
    icon: Icons.flash_on_rounded,
    color: AppColors.neonCyan,
  ),
  hard(
    value: 'hard',
    name: 'Hard',
    description: 'A strategic opponent that plays near-perfect moves.',
    icon: Icons.local_fire_department_rounded,
    color: AppColors.neonPink,
  );

  const CpuDifficulty({
    required this.value,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String value;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
}
