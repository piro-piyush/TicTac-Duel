import 'package:tictac_duel/lib.dart';

class GameRouter extends RouteControllerConfig {
  @override
  GetxGoBuilder builder() {
    return (context, state) {
      final roomCode = state.pathParameters['roomCode'];

      if (roomCode == null || roomCode.isEmpty) {
        throw Exception('Room code is required.');
      }

      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<GameController>(
                () => GameController(
              roomCode: roomCode,
              playerController: Get.find<PlayerController>(),
              roomSocketService: Get.find<RoomSocketService>(),
              musicController: Get.find<MusicController>(),
            ),
          ),
        ],
        view: () => const GameScreen(),
      );
    };
  }
}