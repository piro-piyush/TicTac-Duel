import 'package:tictac_duel/lib.dart';

class ResultRouter extends RouteControllerConfig {
  @override
  GetxGoBuilder builder() {
    return (context, state) {
      final result = state.extra;

      if (result is! ResultModel) {
        throw Exception('Result data is required.');
      }

      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<ResultController>(
            () => ResultController(
              initialState: result,
              playerController: Get.find<PlayerController>(),
              musicController: Get.find<MusicController>(),
            ),
          ),
        ],
        view: () => const ResultScreen(),
      );
    };
  }
}
