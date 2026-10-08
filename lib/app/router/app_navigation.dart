import 'package:tictac_duel/lib.dart';

final appNavigationProvider = Provider<AppNavigation>((ref) {
  return AppNavigation(ref.watch(appRouterProvider));
});

class AppNavigation {
  const AppNavigation(this._router);

  final GoRouter _router;

  // ===========================================================================
  // HOME
  // ===========================================================================

  void goToHome() {
    _router.goNamed(AppRoutes.home.name);
  }

  // ===========================================================================
  // ROOM
  // ===========================================================================

  void pushCreateRoom() {
    _router.pushNamed(AppRoutes.createRoom.name);
  }

  void pushJoinRoom() {
    _router.pushNamed(AppRoutes.joinRoom.name);
  }

  void goToCreateRoom() {
    _router.goNamed(AppRoutes.createRoom.name);
  }

  void replaceCreateRoom() {
    _router.pushReplacementNamed(AppRoutes.createRoom.name);
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  void pushPublicRooms() {
    _router.pushNamed(AppRoutes.publicRooms.name);
  }

  void replacePublicRooms() {
    _router.pushReplacementNamed(AppRoutes.publicRooms.name);
  }

  // ===========================================================================
  // ONLINE GAME
  // ===========================================================================

  void pushGame(RoomModel room) {
    _router.pushNamed(
      AppRoutes.game.name,
      extra:  room,
    );
  }

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  void pushLocalGame() {
    _router.pushNamed(AppRoutes.localGame.name);
  }

  void pushLocalGameBoard({required LocalGameModel game}) {
    _router.pushNamed(AppRoutes.localGameBoard.name, extra: game);
  }

  void goToLocalGame() {
    _router.goNamed(AppRoutes.localGame.name);
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  void replaceResult(ResultModel result) {
    _router.pushReplacementNamed(AppRoutes.result.name, extra: result);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  void pushSettings() {
    _router.pushNamed(AppRoutes.settings.name);
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  void pushHelp() {
    _router.pushNamed(AppRoutes.help.name);
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  void back() {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}
