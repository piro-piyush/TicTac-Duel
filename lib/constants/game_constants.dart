import 'package:tictac_duel/lib.dart';

class GameConstants {
  GameConstants._();

  // ===========================================================================
  // App
  // ===========================================================================

  static const String appName = 'Tic Tac Duel';
  static const String appVersion = '2.0.0';
  static const String appSlogan = 'YOUR MOVE. YOUR GLORY.';
  static const String appDescription =
      'A real-time multiplayer Tic-Tac-Toe experience.';

  // ===========================================================================
  // Game
  // ===========================================================================

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

  // ===========================================================================
  // Local Game
  // ===========================================================================

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

  // ===========================================================================
  // Room
  // ===========================================================================

  static const int roomCodeLength = 6;
  static const int maxPlayers = 2;
  static const int minPlayerNameLength = 2;
  static const int maxPlayerNameLength = 20;

  static const String roomCodeCharacters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static const Duration roomExpiryDuration = Duration(hours: 24);

  static final RegExp roomCodeCharacterPattern = RegExp(
    '[$roomCodeCharacters]',
  );

  static final RegExp roomCodePattern = RegExp(
    '^[$roomCodeCharacters]{$roomCodeLength}\$',
  );
  static const String roomJoinUrl = 'https://tictacduel.app/join-room';

  static String getRoomJoinLink(String roomCode) {
    return '$roomJoinUrl?code=$roomCode';
  }

  static String getRoomShareText(String roomCode) {
    final joinLink = getRoomJoinLink(roomCode);

    return '''
🎮 Join me in $appName!

Let's play a game of Tic-Tac-Toe.

🔑 Room Code: $roomCode

Tap the link below to join:
$joinLink

See you in the arena! ⚡
''';
  }

  // ===========================================================================
  // Network
  // ===========================================================================

  static const Duration socketConnectionTimeout = Duration(seconds: 10);
}
