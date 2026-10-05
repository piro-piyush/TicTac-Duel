import 'package:tictac_duel/lib.dart';

class LocalGameBoardBinding extends Bindings {
  @override
  void dependencies() => Get.put<LocalGameBoardController>(
    LocalGameBoardController(
      game: Get.arguments as LocalGameModel,
      musicController: Get.find<MusicController>(),
      playerController: Get.find<PlayerController>(),
    ),
  );
}
