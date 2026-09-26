import 'package:tictac_duel/lib.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PlayerController>(
      PlayerController(
        identityService: Get.find<PlayerIdentityService>(),
        playerApiService: Get.find<PlayerApiService>(),
      ),
      permanent: true,
    );
  }
}
