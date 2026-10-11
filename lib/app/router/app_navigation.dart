import 'package:tictac_duel/lib.dart';

/// Provides centralized navigation methods for the application.
final appNavigationProvider = Provider<AppNavigation>(
  (ref) => AppNavigation(ref.watch(appRouterProvider)),
);

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

  /// Navigates to the home screen.
  void goToHome() {
    _router.goNamed(AppRoutes.home.name);
  }

  // ===========================================================================
  // ROOM
  // ===========================================================================

  /// Navigates to the create-room screen.
  void goToCreateRoom() {
    _router.goNamed(AppRoutes.createRoom.name);
  }

  /// Navigates to the join-room screen.
  void goToJoinRoom() {
    _router.goNamed(AppRoutes.joinRoom.name);
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  /// Navigates to the public rooms screen.
  void goToPublicRooms() {
    _router.goNamed(AppRoutes.publicRooms.name);
  }

  // ===========================================================================
  // ONLINE GAME
  // ===========================================================================

  /// Navigates to the online game screen with the provided [room].
  ///
  /// Passes the room model through the route's `extra`.
  void goToGame(RoomModel room) {
    _router.goNamed(AppRoutes.game.name, extra: room);
  }

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  /// Navigates to the local game setup screen.
  void goToLocalGame() {
    _router.goNamed(AppRoutes.localGame.name);
  }

  /// Navigates to the local game board with the provided [game].
  ///
  /// Passes the local game model through the route's `extra`.
  void goToLocalGameBoard({required LocalGameModel game}) {
    _router.goNamed(AppRoutes.localGameBoard.name, extra: game);
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  /// Navigates to the result screen with the provided [result].
  ///
  /// Passes the result model through the route's `extra`.
  void goToResult(ResultModel result) {
    _router.goNamed(AppRoutes.result.name, extra: result);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  /// Navigates to the settings screen.
  void goToSettings() {
    _router.goNamed(AppRoutes.settings.name);
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  /// Navigates to the help screen.
  void goToHelp() {
    _router.goNamed(AppRoutes.help.name);
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  /// Returns to the previous route when possible.
  void back() {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}
