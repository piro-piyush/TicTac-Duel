import 'package:tictac_duel/lib.dart';

class LocalGameBoardRouter extends RouteControllerConfig {
  @override
  GetxGoBuilder builder() {
    return (context, state) {
      final game = state.extra as LocalGameModel;

      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<LocalGameBoardController>(
            () => LocalGameBoardController(
              game: game,
              musicController: Get.find<MusicController>(),
            ),
          ),
        ],
        view: () => const LocalGameBoardScreen(),
      );
    };
  }
}
