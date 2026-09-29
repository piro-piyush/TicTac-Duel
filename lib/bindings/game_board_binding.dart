import 'package:tictac_duel/lib.dart';

class GameBoardBinding extends Bindings {
  @override
  void dependencies() => Get.put<GameBoardController>(
    GameBoardController(
      game: Get.arguments as GameModel,
      musicController: Get.find<MusicController>(),
    ),
  );
}
