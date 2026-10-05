import 'package:tictac_duel/lib.dart';

class PublicRoomsBinding extends Bindings {
  @override
  void dependencies() => Get.put<PublicRoomsController>(
    PublicRoomsController(
      roomApiService: Get.find<RoomApiService>(),
      playerController: Get.find<PlayerController>(),
    ),
  );
}
