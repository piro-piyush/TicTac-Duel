import 'package:tictac_duel/lib.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    final roomCode = Get.parameters['roomCode'];

    if (roomCode == null || roomCode.isEmpty) {
      throw Exception('Room code is required.');
    }

    Get.put<GameController>(
      GameController(
        roomCode: roomCode,
        playerController: Get.find<PlayerController>(),
        roomSocketService: Get.find<RoomSocketService>(),
        musicController: Get.find<MusicController>(),
      ),
    );
  }
}
