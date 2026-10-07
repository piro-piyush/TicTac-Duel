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

extension RoundStatusExtension on RoomStatus {
  String get title => switch (this) {
    RoomStatus.waiting => 'Waiting',
    RoomStatus.playing => 'In Progress',
    RoomStatus.result => 'Round Complete',
    RoomStatus.finished => 'Game Over',
  };

  String get description => switch (this) {
    RoomStatus.waiting => 'Waiting for players to get ready.',
    RoomStatus.playing => 'The round is currently in progress.',
    RoomStatus.result => 'The round has ended. Check the result.',
    RoomStatus.finished => 'The game has been completed.',
  };

  IconData get icon => switch (this) {
    RoomStatus.waiting => Icons.hourglass_empty_rounded,
    RoomStatus.playing => Icons.sports_esports_rounded,
    RoomStatus.result => Icons.emoji_events_rounded,
    RoomStatus.finished => Icons.flag_rounded,
  };

  Color get color => switch (this) {
    RoomStatus.waiting => AppColors.neonPurple,
    RoomStatus.playing => AppColors.neonCyan,
    RoomStatus.result => AppColors.neonGreen,
    RoomStatus.finished => AppColors.neonPink,
  };

  String get value => name;

  bool get isWaiting => this == RoomStatus.waiting;

  bool get isPlaying => this == RoomStatus.playing;

  bool get isResult => this == RoomStatus.result;

  bool get isFinished => this == RoomStatus.finished;

  bool get isActive => isWaiting || isPlaying || isResult;
}

extension GameDismissReasonX on GameDismissReason {
  String get displayName => switch (this) {
    GameDismissReason.opponentDisconnected => 'Opponent Disconnected',
    GameDismissReason.opponentQuit => 'Opponent Quit',
  };

  String get message => switch (this) {
    GameDismissReason.opponentDisconnected =>
      'Your opponent disconnected from the game.',
    GameDismissReason.opponentQuit => 'Your opponent quit the game.',
  };

  String get value => name;

  IconData get icon => switch (this) {
    GameDismissReason.opponentDisconnected => Icons.wifi_off_rounded,
    GameDismissReason.opponentQuit => Icons.exit_to_app_rounded,
  };

  Color get color => switch (this) {
    GameDismissReason.opponentDisconnected => AppColors.neonPurple,
    GameDismissReason.opponentQuit => AppColors.neonPink,
  };
}
