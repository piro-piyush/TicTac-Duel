import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictac_duel/lib.dart';
import 'package:tictac_duel/screens/settings_screen.dart';

abstract final class Routes {
  Routes._();

  // ---------------------------------------------------------------------------
  // Paths
  // ---------------------------------------------------------------------------

  static const String mainMenu = '/';
  static const String createRoom = '/create-room';
  static const String joinRoom = '/join-room';
  static const String game = '/game';
  static const String settings = '/settings';
  static const String help = '/help';

  // ---------------------------------------------------------------------------
  // Names
  // ---------------------------------------------------------------------------
  static const String mainMenuName = 'mainMenu';
  static const String createRoomName = 'createRoom';
  static const String joinRoomName = 'joinRoom';
  static const String gameName = 'game';
  static const String settingsName = 'settings';
  static const String helpName = 'help';

  // ---------------------------------------------------------------------------
  // Router
  // ---------------------------------------------------------------------------

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: mainMenu,
    routes: [
      GoRoute(
        path: mainMenu,
        name: mainMenuName,
        builder: (context, state) => const MainMenuScreen(),
      ),

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
        path: '$game/:roomId',
        name: gameName,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;

          return const GameScreen();
        },
      ),
      GoRoute(
        path: settings,
        name: settingsName,
        builder: (context, state) => const SettingsScreen(),
      ),GoRoute(
        path: help,
        name: helpName,
        builder: (context, state) => const HelpScreen(),
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

  static void goMainMenu() => router.goNamed(mainMenuName);

  static void pushSettings() => router.pushNamed(settingsName);
  static void pushHelp() => router.pushNamed(helpName);

  static void pushCreateRoom() => router.pushNamed(createRoomName);
  static void replaceJoinRoom() => router.replaceNamed(joinRoomName);
  static void replaceCreateRoom() => router.replaceNamed(createRoomName);
  static void pushJoinRoom() => router.pushNamed(joinRoomName);

  static void pushGame(String roomId) =>
      router.pushNamed(gameName, pathParameters: {'roomId': roomId});
}
