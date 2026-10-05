import 'package:tictac_duel/lib.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // =========================================================================
    // CORE
    // =========================================================================

    final baseUrl = dotenv.get(
      'BASE_URL',
      fallback: 'http://localhost:3000',
    );

    Get.put<HttpService>(
      HttpService(
        baseUrl: '$baseUrl/api',
      ),
      permanent: true,
    );

    Get.put<LocalStorageService>(
      const LocalStorageService(storage: FlutterSecureStorage()),
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
          () => PlayerApiService(
        httpService: Get.find<HttpService>(),
      ),
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
          () => RoomApiService(
        Get.find<HttpService>(),
      ),
      fenix: true,
    );

    // =========================================================================
    // SOCKET
    // =========================================================================

    Get.lazyPut<SocketService>(
          () => SocketService(
        url: baseUrl,
      ),
      fenix: true,
    );

    Get.lazyPut<RoomSocketService>(
          () => RoomSocketService(
        Get.find<SocketService>(),
      ),
      fenix: true,
    );

    // =========================================================================
    // AUDIO
    // =========================================================================

    Get.put<MusicController>(
      MusicController(
        backgroundPlayer: AudioPlayer(),
        touchPlayer:AudioPlayer() ,
        effectPlayer: AudioPlayer(),
        storage: Get.find<LocalStorageService>(),
      ),
      permanent: true,
    );

    Get.put<NetworkService>(
      NetworkService(
        connectivity: Connectivity(),
      ),
    );
  }
}