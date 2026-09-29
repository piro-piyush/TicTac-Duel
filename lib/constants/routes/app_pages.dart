import 'package:tictac_duel/lib.dart';

abstract final class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    // =========================================================================
    // HOME
    // =========================================================================

    GetPage(name: AppRoutes.homePath, page: HomeScreen.new),

    // =========================================================================
    // GAME
    // =========================================================================
    GetPage(
      name: AppRoutes.gamePath,
      page: GameScreen.new,
      binding: GameBinding(),
    ),
    GetPage(
      name: AppRoutes.gameBoardPath,
      page: GameBoardScreen.new,
      binding: GameBoardBinding(),
    ),

    // =========================================================================
    // RESULT
    // =========================================================================
    GetPage(
      name: AppRoutes.resultPath,
      page: ResultScreen.new,
      binding: ResultBinding(),
    ),

    // =========================================================================
    // SETTINGS
    // =========================================================================
    GetPage(name: AppRoutes.settingsPath, page: SettingsScreen.new),

    // =========================================================================
    // HELP
    // =========================================================================
    GetPage(name: AppRoutes.helpPath, page: HelpScreen.new),

    // =========================================================================
    // PRIVACY POLICY
    // =========================================================================

    // GetPage(
    //   name: AppRoutes.privacyPolicyPath,
    //   page: PrivacyPolicyScreen.new,
    // ),
  ];
}
