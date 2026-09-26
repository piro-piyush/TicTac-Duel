import 'package:tictac_duel/lib.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RoomController>(
      RoomController(
        roomApiService: Get.find<RoomApiService>(),
        playerController: Get.find<PlayerController>(),
      ),
    );
  }
}
