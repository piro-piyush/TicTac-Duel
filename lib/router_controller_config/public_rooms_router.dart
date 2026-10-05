import 'package:tictac_duel/lib.dart';

class PublicRoomsRouter extends RouteControllerConfig {
  @override
  GetxGoBuilder builder() {
    return (context, state) {
      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<PublicRoomsController>(
                () => PublicRoomsController(
              roomApiService: Get.find<RoomApiService>(),
              playerController: Get.find<PlayerController>(),
            ),
          ),
        ],
        view: () => const PublicRoomsScreen(),
      );
    };
  }
}