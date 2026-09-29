import 'package:tictac_duel/lib.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() =>
    Get.put<GameController>(GameController());

}
