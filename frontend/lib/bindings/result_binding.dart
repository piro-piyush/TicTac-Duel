import 'package:tictac_duel/lib.dart';

class ResultBinding extends Bindings {
  @override
  void dependencies() {
    final resultState = Get.arguments as ResultModel;

    Get.put<ResultController>(ResultController(initialState: resultState));
  }
}
