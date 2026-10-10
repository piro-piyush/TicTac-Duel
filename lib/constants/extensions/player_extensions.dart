import 'package:tictac_duel/lib.dart';

extension PlayerSymbolX on PlayerSymbol {
  String get displayName => switch (this) {
    PlayerSymbol.x => 'Cross',
    PlayerSymbol.o => 'Circle',
  };

  Color get symbolColor => switch (this) {
    PlayerSymbol.x => AppColors.neonCyan,
    PlayerSymbol.o => AppColors.neonPink,
  };

  String get value => name;

  static Color color(PlayerSymbol? symbol, RoomTheme theme) => switch (symbol) {
    PlayerSymbol.x => theme.primary,
    PlayerSymbol.o => theme.secondary,
    null => AppColors.textSecondary,
  };

  IconData get icon => switch (this) {
    PlayerSymbol.x => Icons.close_rounded,
    PlayerSymbol.o => Icons.circle_outlined,
  };
}
