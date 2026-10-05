import 'package:go_router/go_router.dart';
import 'package:tictac_duel/lib.dart';

abstract final class AppNavigation {
  AppNavigation._();

  static GoRouter get router => AppPages.router;

  // ===========================================================================
  // HOME
  // ===========================================================================

  static void goToHome() {
    router.goNamed(AppRoutes.home.name);
  }

  // ===========================================================================
  // ROOM
  // ===========================================================================

  static void pushCreateRoom() {
    router.pushNamed(AppRoutes.createRoom.name);
  }

  static void pushJoinRoom() {
    router.pushNamed(AppRoutes.joinRoom.name);
  }

  static void goToCreateRoom() {
    router.goNamed(AppRoutes.createRoom.name);
  }

  static void replaceCreateRoom() {
    router.pushReplacementNamed(AppRoutes.createRoom.name);
  }

  // ===========================================================================
  // GAME
  // ===========================================================================

  static void pushGame(String roomCode) {
    router.pushNamed(
      AppRoutes.game.name,
      pathParameters: {'roomCode': roomCode},
    );
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  static void replaceResult(ResultModel result) {
    final navigator = AppPages.rootNavigatorKey.currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    }

    router.pushReplacementNamed(AppRoutes.result.name, extra: result);
  }

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  static void pushLocalGame() {
    router.pushNamed(AppRoutes.localGame.name);
  }

  static void pushLocalGameBoard({required LocalGameModel game}) {
    router.pushNamed(AppRoutes.localGameBoard.name, extra: game);
  }

  static void goToLocalGame() {
    router.goNamed(AppRoutes.localGame.name);
  }

  // ===========================================================================
  // PUBLIC ROOMS
  // ===========================================================================

  static void pushPublicRooms() {
    router.pushNamed(AppRoutes.publicRooms.name);
  }

  static void replacePublicRooms() {
    router.pushReplacementNamed(AppRoutes.publicRooms.name);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  static void pushSettings() {
    router.pushNamed(AppRoutes.settings.name);
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  static void pushHelp() {
    router.pushNamed(AppRoutes.help.name);
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  static void back() {
    if (router.canPop()) {
      router.pop();
    }
  }
}
