import 'package:tictac_duel/lib.dart';

abstract final class Routes {
  Routes._();

  // ---------------------------------------------------------------------------
  // Paths
  // ---------------------------------------------------------------------------

  static const String home = '/';

  static const String createRoom = 'create-room';
  static const String waitingRoom = 'waiting-room';
  static const String joinRoom = 'join-room';
  static const String result = 'result';
  static const String game = 'game';
  static const String settings = 'settings';
  static const String help = 'help';

  // ---------------------------------------------------------------------------
  // Names
  // ---------------------------------------------------------------------------

  static const String homeName = 'home';
  static const String createRoomName = 'createRoom';
  static const String waitingRoomName = 'waitingRoom';
  static const String resultName = 'result';
  static const String joinRoomName = 'joinRoom';
  static const String gameName = 'game';
  static const String settingsName = 'settings';
  static const String helpName = 'help';

  // ---------------------------------------------------------------------------
  // Router
  // ---------------------------------------------------------------------------

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    extraCodec: const JsonCodec(),
    routes: [
      GoRoute(
        path: home,
        name: homeName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: createRoom,
            name: createRoomName,
            builder: (context, state) => const CreateRoomScreen(),
          ),
          GoRoute(
            path: joinRoom,
            name: joinRoomName,
            builder: (context, state) => const JoinRoomScreen(),
          ),
          GoRoute(
            path: game,
            name: gameName,
            builder: (context, state) => const GameScreen(),
          ),
          GoRoute(
            path: result,
            name: resultName,
            builder: (context, state) => const ResultScreen(),
          ),
          GoRoute(
            path: settings,
            name: settingsName,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: help,
            name: helpName,
            builder: (context, state) => const HelpScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Page not found\n${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  static void goToHome() => router.goNamed(homeName);

  static void goToCreateRoom() => router.goNamed(createRoomName);

  static void pushSettings() => router.pushNamed(settingsName);

  static void pushHelp() => router.pushNamed(helpName);
  static void pushResult() => router.pushNamed(resultName);

  static void pushCreateRoom() => router.pushNamed(createRoomName);

  static void replaceJoinRoom() => router.replaceNamed(joinRoomName);

  static void replaceCreateRoom() => router.replaceNamed(createRoomName);

  static void replaceWaitingRoom(RoomModel room) =>
      router.replaceNamed(waitingRoomName, extra: room);

  static void replaceToGame() => router.replaceNamed(gameName);

  static void replaceToResult() => router.replaceNamed(resultName);

  static void pushJoinRoom() => router.pushNamed(joinRoomName);

  static void pushGame(String roomId) =>
      router.pushNamed(gameName, pathParameters: {'roomId': roomId});
}
