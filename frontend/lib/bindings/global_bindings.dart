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

    // =========================================================================
    // PLAYER
    // =========================================================================

    Get.put<PlayerIdentityService>(
      PlayerIdentityService(Get.find<SharedPreferences>()),
      permanent: true,
    );

    Get.put<PlayerApiService>(
      PlayerApiService(httpService: Get.find<HttpService>()),
      permanent: true,
    );

    Get.put<PlayerController>(
      PlayerController(
        identityService: Get.find<PlayerIdentityService>(),
        playerApiService: Get.find<PlayerApiService>(),
      ),
      permanent: true,
    );

    // =========================================================================
    // ROOM API
    // =========================================================================

    Get.put<RoomApiService>(
      RoomApiService(Get.find<HttpService>()),
      permanent: true,
    );

    // =========================================================================
    // SOCKET
    // =========================================================================

    Get.put<SocketService>(
      SocketService(
        url: dotenv.get('SOCKET_URL', fallback: 'http://localhost:3000'),
      ),
      permanent: true,
    );

    Get.put<RoomSocketService>(
      RoomSocketService(Get.find<SocketService>()),
      permanent: true,
    );

    // =========================================================================
    // AUDIO
    // =========================================================================

    Get.put<MusicController>(
      MusicController(player: AudioPlayer(), effectPlayer: AudioPlayer()),
      permanent: true,
    );
  }
}
