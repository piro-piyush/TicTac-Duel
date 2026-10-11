import 'package:tictac_duel/lib.dart';

// =============================================================================
// CONFIGURATION
// =============================================================================

final baseUrlProvider = Provider<String>(
  (ref) => dotenv.get('BASE_URL', fallback: 'http://localhost:3000'),
);

// =============================================================================
// STORAGE
// =============================================================================

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => const LocalStorageService(storage: FlutterSecureStorage()),
);

// =============================================================================
// HTTP
// =============================================================================

final httpServiceProvider = Provider<HttpService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);

  return HttpService(baseUrl: '$baseUrl/api');
});

final playerApiServiceProvider = Provider<PlayerApiService>(
  (ref) => PlayerApiService(httpService: ref.watch(httpServiceProvider)),
);

final roomApiServiceProvider = Provider<RoomApiService>(
  (ref) => RoomApiService(httpService: ref.watch(httpServiceProvider)),
);

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

final socketServiceProvider = Provider<SocketService>(
  (ref) => SocketService(url: ref.watch(baseUrlProvider)),
);

final roomSocketServiceProvider = Provider<RoomSocketService>(
  (ref) => RoomSocketService(socket: ref.watch(socketServiceProvider)),
);

// =============================================================================
// ROUTING
// =============================================================================

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: AppPages.rootNavigatorKey,
    initialLocation: AppRoutes.splash.path,
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.scheme != 'tictacduel') return null;
      final path = uri.host.isNotEmpty && uri.host != 'localhost'
          ? '/${uri.host}'
          : uri.path;
      final destination = Uri(
        path: path,
        queryParameters: uri.queryParameters.isEmpty
            ? null
            : uri.queryParameters,
      ).toString();
      return destination == state.matchedLocation && uri.queryParameters.isEmpty
          ? null
          : destination;
    },
    routes: [
      GoRoute(
        name: AppRoutes.splash.name,
        path: AppRoutes.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
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
          // -----------------------------------------------------------------------
          // RESULT
          // -----------------------------------------------------------------------
          GoRoute(
            name: AppRoutes.result.name,
            path: AppRoutes.result.path,
            builder: (context, state) {
              final result = state.extra as ResultModel;
              return ResultScreen(result: result);
            },
          ),
          GoRoute(
            name: AppRoutes.game.name,
            path: AppRoutes.game.path,
            builder: (context, state) {
              final room = state.extra as RoomModel;
              return GameScreen(room: room);
            },
          ),
        ],
      ),
    ],
  ),
);
