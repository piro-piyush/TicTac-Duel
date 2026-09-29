import 'package:tictac_duel/lib.dart';

class LocalGameBinding extends Bindings {
  @override
  void dependencies() =>
    Get.put<LocalGameController>(LocalGameController());

}
