import 'package:tictac_duel/lib.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    final id = Get.parameters['id'];

    if (id == null || id.isEmpty) {
      throw Exception('Room code is required.');
    }

    Get.put<GameController>(
      GameController(
        id: id,
        socketService: Get.find<SocketService>(),
        roomSocketService: Get.find<RoomSocketService>(),
        musicController: Get.find<MusicController>(),
        playerController: Get.find<PlayerController>(),
        roomApiService: Get.find<RoomApiService>(),
      ),
    );
  }
}
