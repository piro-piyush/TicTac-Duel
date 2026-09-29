import 'package:tictac_duel/lib.dart';

class ResultBinding extends Bindings {
  @override
  void dependencies() => Get.put<ResultController>(
    ResultController(
      initialState: Get.arguments as ResultModel,
      musicController: Get.find<MusicController>(),
    ),
  );
}
