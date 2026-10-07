import 'package:tictac_duel/lib.dart';

final baseUrlProvider = Provider<String>((ref) {
  return dotenv.get('BASE_URL', fallback: 'http://localhost:3000');
});

// =============================================================================
// STORAGE
// =============================================================================

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return const LocalStorageService(storage: FlutterSecureStorage());
});

// =============================================================================
// HTTP
// =============================================================================

final httpServiceProvider = Provider<HttpService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);

  return HttpService(baseUrl: '$baseUrl/api');
});

// =============================================================================
// NETWORK
// =============================================================================

final networkServiceProvider = Provider<NetworkService>((ref) {
  final service = NetworkService(connectivity: Connectivity());

  service.initialize();

  ref.onDispose(service.dispose);

  return service;
});

// =============================================================================
// SOCKET
// =============================================================================

final socketServiceProvider = Provider<SocketService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);

  return SocketService(url: baseUrl);
});

final playerApiServiceProvider = Provider<PlayerApiService>((ref) {
  return PlayerApiService(httpService: ref.watch(httpServiceProvider));
});
final roomApiServiceProvider = Provider<RoomApiService>((ref) {
  return RoomApiService(httpService: ref.watch(httpServiceProvider));
});

final roomSocketServiceProvider = Provider<RoomSocketService>((ref) {
  return RoomSocketService(socket: ref.watch(socketServiceProvider));
});
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.home.path,
    navigatorKey: AppPages.rootNavigatorKey,
    routes: [
      GoRoute(
        name: AppRoutes.home.name,
        path: AppRoutes.home.path,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            name: AppRoutes.settings.name,
            path: AppRoutes.settings.path,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            name: AppRoutes.help.name,
            path: AppRoutes.help.path,
            builder: (context, state) => const HelpScreen(),
          ),
          GoRoute(
            name: AppRoutes.createRoom.name,
            path: AppRoutes.createRoom.path,
            builder: (context, state) => const CreateRoomScreen(),
          ),
          GoRoute(
            name: AppRoutes.joinRoom.name,
            path: AppRoutes.joinRoom.path,
            builder: (context, state) {
              final roomCode = state.uri.queryParameters['code'];
              return JoinRoomScreen(roomCode: roomCode);
            },
          ),
          GoRoute(
            name: AppRoutes.publicRooms.name,
            path: AppRoutes.publicRooms.path,
            builder: (context, state) => const PublicRoomsScreen(),
          ),
          GoRoute(
            name: AppRoutes.localGame.name,
            path: AppRoutes.localGame.path,
            builder: (context, state) => const LocalGameScreen(),
            routes: [
              GoRoute(
                name: AppRoutes.localGameBoard.name,
                path: AppRoutes.localGameBoard.path,
                builder: (context, state) {
                  final game = state.extra as LocalGameModel;

                  return LocalGameBoardScreen(game: game);
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        name: AppRoutes.game.name,
        path: AppRoutes.game.path,
        builder: (context, state) {
          final room = state.extra as Room;

          return GameScreen(room: room);
        },
      ),

      GoRoute(
        name: AppRoutes.result.name,
        path: AppRoutes.result.path,
        builder: (context, state) {
          final result = state.extra as ResultModel;

          return ResultScreen(result: result);
        },
      ),
    ],
  );
});
