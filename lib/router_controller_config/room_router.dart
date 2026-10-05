import 'package:tictac_duel/lib.dart';

class RoomRouter extends RouteControllerConfig {
  RoomRouter({
    required this.screen,
  });

  final RoomScreenType screen;

  @override
  GetxGoBuilder builder() {
    return (context, state) {
      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<RoomController>(
                () => RoomController(
              roomApiService: Get.find<RoomApiService>(),
              playerController: Get.find<PlayerController>(),
            ),
          ),
        ],
        view: () => switch (screen) {
          RoomScreenType.create => const CreateRoomScreen(),
          RoomScreenType.join => const JoinRoomScreen(),
        },
      );
    };
  }
}