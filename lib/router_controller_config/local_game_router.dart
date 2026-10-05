import 'package:tictac_duel/lib.dart';

class LocalGameRouter extends RouteControllerConfig {
  @override
  GetxGoBuilder builder() {
    return (context, state) {
      return ControllerBindingEntry(
        controllers: [
          ControllerEntry<LocalGameController>(LocalGameController.new),
        ],
        view: () => const LocalGameScreen(),
      );
    };
  }
}
