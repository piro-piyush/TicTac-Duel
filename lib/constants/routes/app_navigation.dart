import 'package:tictac_duel/lib.dart';

abstract final class AppNavigation {
  AppNavigation._();

  // ===========================================================================
  // HOME
  // ===========================================================================

  static void goToHome() => Get.offAllNamed(AppRoutes.homePath);

  // ===========================================================================
  // GAME
  // ===========================================================================

  static void pushGame() => Get.toNamed(AppRoutes.gamePath);

  static void pushGameBoard(GameModel game) =>
      Get.toNamed(AppRoutes.gameBoardPath, arguments: game);

  static void replaceGameBoard(GameModel game) =>
      Get.offNamed(AppRoutes.gameBoardPath, arguments: game);

  // ===========================================================================
  // RESULT
  // ===========================================================================

  static void pushResult(ResultModel result) =>
      Get.toNamed(AppRoutes.resultPath, arguments: result);

  static void replaceResult(ResultModel result) =>
      Get.offNamed(AppRoutes.resultPath, arguments: result);

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  static void pushSettings() => Get.toNamed(AppRoutes.settingsPath);

  // ===========================================================================
  // HELP
  // ===========================================================================

  static void pushHelp() => Get.toNamed(AppRoutes.helpPath);

  // ===========================================================================
  // PRIVACY POLICY
  // ===========================================================================

  static void pushPrivacyPolicy() => Get.toNamed(AppRoutes.privacyPolicyPath);

  // ===========================================================================
  // BACK
  // ===========================================================================

  static void back<T>({T? result}) => Get.back<T>(result: result);
}
