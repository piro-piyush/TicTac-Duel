import 'package:tictac_duel/lib.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // =========================================================================
    // CORE
    // =========================================================================

    Get.put<HttpService>(
      HttpService(
        baseUrl: dotenv.get(
          'API_BASE_URL',
          fallback: 'http://localhost:3000/api',
        ),
      ),
      permanent: true,
    );

    Get.put<LocalStorageService>(
      LocalStorageService(storage: const FlutterSecureStorage()),
      permanent: true,
    );

    // =========================================================================
    // PLAYER
    // =========================================================================

    // Get.put<PlayerIdentityService>(
    //   PlayerIdentityService(storage: Get.find<LocalStorageService>()),
    //   permanent: true,
    // );

    Get.lazyPut<PlayerApiService>(
      () => PlayerApiService(httpService: Get.find<HttpService>()),
    );

    Get.put<PlayerController>(
      PlayerController(
        storage: Get.find<LocalStorageService>(),
        playerApiService: Get.find<PlayerApiService>(),
      ),
      permanent: true,
    );

    // =========================================================================
    // ROOM
    // =========================================================================

    Get.lazyPut<RoomApiService>(
      () => RoomApiService(Get.find<HttpService>()),
      fenix: true,
    );

    // =========================================================================
    // SOCKET
    // =========================================================================

    Get.lazyPut<SocketService>(
      () => SocketService(
        url: dotenv.get('SOCKET_URL', fallback: 'http://localhost:3000'),
      ),
      fenix: true,
    );

    Get.lazyPut<RoomSocketService>(
      () => RoomSocketService(Get.find<SocketService>()),
      fenix: true,
    );

    // =========================================================================
    // AUDIO
    // =========================================================================

    Get.lazyPut<MusicController>(
      () => MusicController(
        player: AudioPlayer(),
        effectPlayer: AudioPlayer(),
        storage: Get.find<LocalStorageService>(),
      ),
      fenix: true,
    );
  }
}
