import 'package:tictac_duel/lib.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // =========================================================================
    // CORE
    // =========================================================================

    Get.put<LocalStorageService>(
      LocalStorageService(storage: const FlutterSecureStorage()),
      permanent: true,
    );

    // =========================================================================
    // AUDIO
    // =========================================================================

    Get.put<MusicController>(
      MusicController(
        player: AudioPlayer(),
        effectPlayer: AudioPlayer(),
        storage: Get.find<LocalStorageService>(),
      ),
      permanent: true,
    );
  }
}
