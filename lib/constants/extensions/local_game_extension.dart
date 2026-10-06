import 'package:tictac_duel/lib.dart';

extension LocalGameTypeX on LocalGameType {
  String get displayName => switch (this) {
    LocalGameType.friend => 'Local Friend',
    LocalGameType.computer => 'Computer',
  };

  String get description => switch (this) {
    LocalGameType.friend =>
    'Play face-to-face with a friend on the same device.',
    LocalGameType.computer =>
    'Challenge the CPU and play completely offline.',
  };

  IconData get icon => switch (this) {
    LocalGameType.friend => Icons.people_alt_rounded,
    LocalGameType.computer => Icons.smart_toy_rounded,
  };

  Color get color => switch (this) {
    LocalGameType.friend => AppColors.neonCyan,
    LocalGameType.computer => AppColors.neonPink,
  };
  String get value => name;
}

extension CpuDifficultyX on CpuDifficulty {
  String get displayName => switch (this) {
    CpuDifficulty.easy => 'Easy',
    CpuDifficulty.medium => 'Medium',
    CpuDifficulty.hard => 'Hard',
  };
  String get value => name;
  String get description => switch (this) {
    CpuDifficulty.easy =>
    'A relaxed opponent that makes occasional random moves.',
    CpuDifficulty.medium =>
    'A balanced opponent that can attack and defend.',
    CpuDifficulty.hard =>
    'A strategic opponent that plays near-perfect moves.',
  };

  IconData get icon => switch (this) {
    CpuDifficulty.easy => Icons.sentiment_satisfied_alt_rounded,
    CpuDifficulty.medium => Icons.flash_on_rounded,
    CpuDifficulty.hard => Icons.local_fire_department_rounded,
  };

  Color get color => switch (this) {
    CpuDifficulty.easy => AppColors.neonGreen,
    CpuDifficulty.medium => AppColors.neonCyan,
    CpuDifficulty.hard => AppColors.neonPink,
  };
}