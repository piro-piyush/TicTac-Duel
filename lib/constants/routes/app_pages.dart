import 'package:tictac_duel/lib.dart';

abstract final class AppPages {
  AppPages._();

  // ===========================================================================
  // NAVIGATOR KEYS
  // ===========================================================================

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // ===========================================================================
  // ROUTER
  // ===========================================================================

  static final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.home.path,
    navigatorKey: rootNavigatorKey,
    routes: [
      // =========================================================================
      // HOME
      // =========================================================================

      GoRoute(
        name: AppRoutes.home.name,
        path: AppRoutes.home.path,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // =======================================================================
          // GENERAL
          // =======================================================================

          GoRoute(
            name: AppRoutes.settings.name,
            path: childPath(AppRoutes.settings.path),
            builder: (context, state) => const SettingsScreen(),
          ),

          GoRoute(
            name: AppRoutes.help.name,
            path: childPath(AppRoutes.help.path),
            builder: (context, state) => const HelpScreen(),
          ),

          // =======================================================================
          // ROOM
          // =======================================================================
          ControllerRoute(
            name: AppRoutes.createRoom.name,
            path: AppRoutes.createRoom.path,
            routeControllerConfig: RoomRouter(screen: RoomScreenType.create),
          ),

          ControllerRoute(
            name: AppRoutes.joinRoom.name,
            path: AppRoutes.joinRoom.path,
            routeControllerConfig: RoomRouter(screen: RoomScreenType.join),
          ),

          ControllerRoute(
            name: AppRoutes.publicRooms.name,
            path: childPath(AppRoutes.publicRooms.path),
            routeControllerConfig: PublicRoomsRouter(),
          ),

          // =======================================================================
          // LOCAL GAME
          // =======================================================================
          ControllerRoute(
            name: AppRoutes.localGame.name,
            path: childPath(AppRoutes.localGame.path),
            routeControllerConfig: LocalGameRouter(),
            routes: [
              ControllerRoute(
                name: AppRoutes.localGameBoard.name,
                path: childPath(
                  AppRoutes.localGameBoard.path.replaceFirst(
                    '${AppRoutes.localGame.path}/',
                    '',
                  ),
                ),
                routeControllerConfig: LocalGameBoardRouter(),
              ),
            ],
          ),
        ],
      ),

      // =========================================================================
      // ONLINE GAME
      // =========================================================================
      ControllerRoute(
        name: AppRoutes.game.name,
        path: AppRoutes.game.path,
        routeControllerConfig: GameRouter(),
      ),

      // =========================================================================
      // RESULT
      // =========================================================================
      ControllerRoute(
        name: AppRoutes.result.name,
        path: AppRoutes.result.path,
        routeControllerConfig: ResultRouter(),
      ),
    ],
  );

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  static String childPath(String path) {
    return path.startsWith('/') ? path.substring(1) : path;
  }
}
