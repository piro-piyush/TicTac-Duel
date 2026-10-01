import 'package:tictac_duel/lib.dart';

extension RoomThemeX on RoomTheme {
  String get displayName => switch (this) {
    RoomTheme.classic => 'Classic',
    RoomTheme.inferno => 'Inferno',
    RoomTheme.cyber => 'Cyber',
  };

  String get subtitle => switch (this) {
    RoomTheme.classic => 'Cyan & Purple',
    RoomTheme.inferno => 'Pink & Red',
    RoomTheme.cyber => 'Green & Cyan',
  };

  Color get primary => switch (this) {
    RoomTheme.classic => AppColors.neonCyan,
    RoomTheme.inferno => AppColors.neonPink,
    RoomTheme.cyber => AppColors.neonGreen,
  };

  Color get secondary => switch (this) {
    RoomTheme.classic => AppColors.neonPurple,
    RoomTheme.inferno => const Color(0xFFFF4D4D),
    RoomTheme.cyber => AppColors.neonCyan,
  };
  String get value => name;
}

extension RoundStatusExtension on RoundStatus {
  String get displayName => switch (this) {
    RoundStatus.waiting => 'Waiting',
    RoundStatus.playing => 'Playing',
    RoundStatus.result => 'Result',
  };

  bool get isWaiting => this == RoundStatus.waiting;

  bool get isPlaying => this == RoundStatus.playing;

  bool get isResult => this == RoundStatus.result;
  String get value => name;
}
