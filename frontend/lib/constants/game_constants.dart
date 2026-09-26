class GameConstants {
  GameConstants._();

  // ─────────────────────────────────────────────────────────────
  // App
  // ─────────────────────────────────────────────────────────────

  static const String appName = 'Tic Tac Duel';
  static const String appVersion = '2.0.0';
  static const String appSlogan = 'YOUR MOVE. YOUR GLORY.';
  static const String appDescription =
      'A real-time multiplayer Tic-Tac-Toe experience.';

  // ─────────────────────────────────────────────────────────────
  // Game
  // ─────────────────────────────────────────────────────────────

  static const int boardSize = 3;
  static const int totalCells = boardSize * boardSize;

  static const List<int> roundOptions = [1, 3, 5, 7];

  // ─────────────────────────────────────────────────────────────
  // Room
  // ─────────────────────────────────────────────────────────────

  static const int roomCodeLength = 6;
  static const int maxPlayers = 2;

  static const Duration roomExpiryDuration = Duration(hours: 24);


  // ─────────────────────────────────────────────────────────────
  // Network
  // ─────────────────────────────────────────────────────────────

  static const Duration socketConnectionTimeout = Duration(seconds: 10);
}
