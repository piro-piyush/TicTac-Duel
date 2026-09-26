import 'package:tictac_duel/lib.dart';

abstract final class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.home, page: HomeScreen.new),

    GetPage(
      name: AppRoutes.createRoom,
      page: CreateRoomScreen.new,
      binding: RoomBinding(),
    ),

    GetPage(
      name: AppRoutes.joinRoom,
      page: JoinRoomScreen.new,
      binding: RoomBinding(),
    ),

    // GetPage(
    //   name: AppRoutes.waitingRoom,
    //   page: WaitingRoomScreen.new,
    //   binding: WaitingRoomBinding(),
    // ),
    GetPage(name: AppRoutes.game, page: GameScreen.new, binding: GameBinding()),

    GetPage(
      name: AppRoutes.result,
      page: ResultScreen.new,
      // binding: ResultBinding(),
    ),

    GetPage(name: AppRoutes.settings, page: SettingsScreen.new),

    // GetPage(name: AppRoutes.privacyPolicy, page: PrivacyPolicyScreen.new),

    GetPage(name: AppRoutes.help, page: HelpScreen.new),
  ];
}
