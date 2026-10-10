import 'package:tictac_duel/lib.dart';

/// Provides centralized navigation methods for the application.
final appNavigationProvider = Provider<AppNavigation>((ref) {
  return AppNavigation(ref.watch(appRouterProvider));
});

/// Encapsulates application navigation using the configured [GoRouter].
///
/// Use this class instead of calling [GoRouter] directly from widgets,
/// controllers, or state notifiers.
class AppNavigation {
  const AppNavigation(this._router);

  final GoRouter _router;

  // ===========================================================================
  // HOME
  // ===========================================================================

  /// Navigates to the home screen, replacing the current location.
  void goToHome() {
    _router.goNamed(AppRoutes.home.name);
  }

  // ===========================================================================
  // ROOM
  // ===========================================================================

  /// Opens the create-room screen on top of the current route.
  void pushCreateRoom() {
    _router.pushNamed(AppRoutes.createRoom.name);
  }

  /// Opens the join-room screen on top of the current route.
  void pushJoinRoom() {
    _router.pushNamed(AppRoutes.joinRoom.name);
  }

  /// Navigates directly to the create-room screen.
  ///
  /// The current location is replaced rather than pushed onto the stack.
  void goToCreateRoom() {
    _router.goNamed(AppRoutes.createRoom.name);
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  /// Navigates directly to the public rooms screen.
  void goToPublicRooms() {
    _router.goNamed(AppRoutes.publicRooms.name);
  }

  /// Opens the public rooms screen on top of the current route.
  void pushPublicRooms() {
    _router.pushNamed(AppRoutes.publicRooms.name);
  }

  // ===========================================================================
  // ONLINE GAME
  // ===========================================================================

  /// Opens the online game screen for the given [room].
  ///
  /// Passes the room model to the destination through the route's `extra`.
  void pushGame(RoomModel room) {
    _router.pushNamed(AppRoutes.game.name, extra: room);
  }

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  /// Opens the local game setup screen on top of the current route.
  void pushLocalGame() {
    _router.pushNamed(AppRoutes.localGame.name);
  }

  /// Opens the local game board using the provided [game] configuration.
  ///
  /// Passes the local game model to the destination through the route's
  /// `extra`.
  void pushLocalGameBoard({required LocalGameModel game}) {
    _router.pushNamed(AppRoutes.localGameBoard.name, extra: game);
  }

  /// Navigates directly to the local game setup screen.
  void goToLocalGame() {
    _router.goNamed(AppRoutes.localGame.name);
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  /// Navigates to the result screen with the provided [result].
  ///
  /// Passes the result model to the destination through the route's `extra`.
  void goToResult(ResultModel result) {
    _router.goNamed(AppRoutes.result.name, extra: result);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  /// Opens the settings screen on top of the current route.
  void pushSettings() {
    _router.pushNamed(AppRoutes.settings.name);
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  /// Opens the help screen on top of the current route.
  void pushHelp() {
    _router.pushNamed(AppRoutes.help.name);
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  /// Returns to the previous route if the router can pop the current route.
  ///
  /// Does nothing when there is no previous route to return to.
  void back() {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}
