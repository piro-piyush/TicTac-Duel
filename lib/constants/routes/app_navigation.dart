import 'package:tictac_duel/lib.dart';

abstract final class AppNavigation {
  AppNavigation._();

  // ===========================================================================
  // HOME
  // ===========================================================================

  static void goToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  static void replaceHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  static void pushCreateRoom() {
    Get.toNamed(AppRoutes.createRoom);
  }

  static void replaceCreateRoom() {
    Get.offNamed(AppRoutes.createRoom);
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  static void pushJoinRoom() {
    Get.toNamed(AppRoutes.joinRoom);
  }

  static void replaceJoinRoom() {
    Get.offNamed(AppRoutes.joinRoom);
  }

  // ===========================================================================
  // WAITING ROOM
  // ===========================================================================

  static void replaceWaitingRoom(RoomModel room) {
    Get.offNamed(AppRoutes.waitingRoom, arguments: room);
  }

  // ===========================================================================
  // ONLINE GAME
  // ===========================================================================

  static void replaceGame(String roomCode) {
    Get.offNamed(
      AppRoutes.game.replaceFirst(':roomCode', roomCode),
      arguments: roomCode,
    );
  }

  // ===========================================================================
  // QUICK MATCH
  // ===========================================================================

  static void pushQuickMatch() {
    Get.toNamed(AppRoutes.quickMatch);
  }

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  static void pushLocalGame() {
    Get.toNamed(AppRoutes.localGame);
  }

  static void pushPublicRooms() {
    Get.toNamed(AppRoutes.publicRooms);
  }
  static void replacePublicRooms() {
    Get.offNamed(AppRoutes.publicRooms);
  }

  static void pushLocalGameBoard(LocalGameModel localGame) {
    Get.toNamed(AppRoutes.localGameBoard, arguments: localGame);
  }

  static void replaceLocalGameBoard(LocalGameModel localGame) {
    Get.offNamed(AppRoutes.localGameBoard, arguments: localGame);
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  static void pushResult(ResultModel result) {
    Get.toNamed(AppRoutes.result, arguments: result);
  }

  static void replaceResult(ResultModel result) {
    Get.offNamed(AppRoutes.result, arguments: result);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  static void pushSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  static void pushHelp() {
    Get.toNamed(AppRoutes.help);
  }

  // ===========================================================================
  // PRIVACY POLICY
  // ===========================================================================

  static void pushPrivacyPolicy() {
    Get.toNamed(AppRoutes.privacyPolicy);
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  static void back() {
    if (Get.isDialogOpen == true ||
        Get.isBottomSheetOpen == true ||
        Get.isSnackbarOpen) {
      Get.back();
      return;
    }

    // if (Get.canPop()) {
    //   Get.back();
    // }
  }
}
