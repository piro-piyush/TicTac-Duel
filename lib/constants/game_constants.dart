import 'package:tictac_duel/lib.dart';

class GameConstants {
  GameConstants._();

  // ===========================================================================
  // APP
  // ===========================================================================

  static const String appName = 'Tic Tac Duel';
  static const String appVersion = '2.0.0';
  static const String appSlogan = 'YOUR MOVE. YOUR GLORY.';
  static const String appDescription =
      'A real-time multiplayer Tic-Tac-Toe experience.';

  // ===========================================================================
  // GAME
  // ===========================================================================

  static const int boardSize = 3;
  static const int totalCells = boardSize * boardSize;

  static const List<int> roundOptions = [3, 5, 7];
  static const int defaultMaxRounds = 3;

  static const defaultLocalGameType = LocalGameType.friend;
  static const defaultLocalPlayerSymbol = PlayerSymbol.x;
  static const defaultLocalTheme = RoomTheme.classic;
  static const defaultCpuDifficulty = CpuDifficulty.medium;

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
  // LOCAL GAME
  // ===========================================================================

  static const String defaultPlayerId = 'local_player';
  static const String localPlayerOneId = 'local_player_1';
  static const String localPlayerTwoId = 'local_player_2';
  static const String localCpuId = 'local_cpu';

  static const String localPlayerName = 'You';
  static const String localPlayerOneName = 'Player One';
  static const String localPlayerTwoName = 'Player Two';
  static const String localCpuName = 'CPU';

  static const Duration cpuMoveDelay = Duration(milliseconds: 450);

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  static const Duration roundAnimationTransitionDuration = Duration(
    milliseconds: 650,
  );

  static const Duration roundAnimationDisplayDuration = Duration(
    milliseconds: 550,
  );

  static Duration roundAnimationDuration = Duration(
    milliseconds:
        roundAnimationTransitionDuration.inMilliseconds +
        roundAnimationDisplayDuration.inMilliseconds,
  );

  static const Duration winningLineAnimationDuration = Duration(
    milliseconds: 500,
  );

  static const Duration winningLineDisplayDuration = Duration(
    milliseconds: 700,
  );

  static Duration resultDelay = Duration(
    milliseconds:
        winningLineAnimationDuration.inMilliseconds +
        winningLineDisplayDuration.inMilliseconds,
  );

  // ===========================================================================
  // ROOM
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
  // NETWORK
  // ===========================================================================

  static const Duration socketConnectionTimeout = Duration(seconds: 10);

  // ===========================================================================
  // REACTION
  // ===========================================================================

  static const Duration reactionTravelDuration = Duration(milliseconds: 900);

  static const Duration reactionDisplayDuration = Duration(seconds: 1);

  static const Duration reactionFadeDuration = Duration(milliseconds: 50);

  static Duration reactionTotalDuration = Duration(
    milliseconds:
        reactionTravelDuration.inMilliseconds +
        reactionDisplayDuration.inMilliseconds +
        reactionFadeDuration.inMilliseconds,
  );

  static const String privacyPolicyText =
      'Tic Tac Duel does not collect, store, or share any personal information.\n\n'
      'No account or login is required to play. The app does not use a database '
      'to store player information, game history, scores, or other personal data.\n\n'
      'You may enter a game name to identify yourself during a game. This name '
      'is used only for gameplay and is not stored as personal information.\n\n'
      'Tic Tac Duel does not track your activity and does not use analytics, '
      'advertising, or tracking services.\n\n'
      'No personal information is required to play, and the game is designed '
      'to be accessible to players of any age.';
}
