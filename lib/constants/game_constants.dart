import 'package:tictac_duel/lib.dart';

class GameConstants {
  GameConstants._();

  // ─────────────────────────────────────────────────────────────
  // App
  // ─────────────────────────────────────────────────────────────

  static const String appName = 'Tic Tac Duel';
  static const String appVersion = '1.0.0';
  static const String appSlogan = 'YOUR MOVE. YOUR GLORY.';
  static const String appDescription =
      'A real-time multiplayer Tic-Tac-Toe experience.';

  // ─────────────────────────────────────────────────────────────
  // Game
  // ─────────────────────────────────────────────────────────────

  static const int boardSize = 3;
  static const int totalCells = boardSize * boardSize;

  static const List<int> roundOptions = [3, 5, 7];

  static const List<PlayerSymbol?> themePreviewSymbols = [
    PlayerSymbol.x,
    null,
    PlayerSymbol.o,
    null,
    PlayerSymbol.x,
    null,
    PlayerSymbol.o,
    null,
    PlayerSymbol.x,
  ];

  // ─────────────────────────────────────────────────────────────
  // Local Game
  // ─────────────────────────────────────────────────────────────

  static const String localPlayerOneId = 'local_player_1';
  static const String localPlayerTwoId = 'local_player_2';
  static const String localCpuId = 'local_cpu';

  static const String localPlayerName = 'You';
  static const String localPlayerOneName = 'Player One';
  static const String localPlayerTwoName = 'Player Two';
  static const String localCpuName = 'CPU';

  static const Duration cpuMoveDelay = Duration(milliseconds: 450);

  static const Duration resultDelay = Duration(seconds: 1);

  static const Duration roundAnimationDuration = Duration(milliseconds: 1200);
}
