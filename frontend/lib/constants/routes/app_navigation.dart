import 'package:tictac_duel/lib.dart';

abstract final class AppNavigation {
  AppNavigation._();

  // ===========================================================================
  // HOME
  // ===========================================================================

  static void goToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  static void goToCreateRoom() {
    Get.toNamed(AppRoutes.createRoom);
  }

  static void replaceCreateRoom() {
    Get.offNamed(AppRoutes.createRoom);
  }

  static void pushCreateRoom() {
    Get.toNamed(AppRoutes.createRoom);
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  static void goToJoinRoom() {
    Get.toNamed(AppRoutes.joinRoom);
  }

  static void replaceJoinRoom() {
    Get.offNamed(AppRoutes.joinRoom);
  }

  static void pushJoinRoom() {
    Get.toNamed(AppRoutes.joinRoom);
  }

  // ===========================================================================
  // WAITING ROOM
  // ===========================================================================

  static void replaceWaitingRoom(RoomModel room) {
    Get.offNamed(AppRoutes.waitingRoom, arguments: room);
  }

  // ===========================================================================
  // GAME
  // ===========================================================================

  static void goToGame(String id) {
    Get.toNamed(AppRoutes.game.replaceFirst(':id', id), arguments: id);
  }

  static void replaceToGame(String id) {
    Get.offNamed(AppRoutes.game.replaceFirst(':id', id), arguments: id);
  }

  // ===========================================================================
  // RESULT
  // ===========================================================================

  static void goToResult() {
    Get.toNamed(AppRoutes.result);
  }

  static void replaceToResult() {
    Get.offNamed(AppRoutes.result);
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  static void pushToSettings() {
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
    if (Get.isOverlaysOpen) {
      Get.back();
      return;
    }

    if (Get.isDialogOpen == true) {
      Get.back();
      return;
    }

    if (Get.isSnackbarOpen) {
      Get.back();
      return;
    }

    if (Get.currentRoute != AppRoutes.home) {
      Get.back();
    }
  }
}
