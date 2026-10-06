class AppRouteModel {
  const AppRouteModel({required this.name, required this.path});

  final String name;
  final String path;
}

abstract final class AppRoutes {
  AppRoutes._();

  // ===========================================================================
  // HOME
  // ===========================================================================

  static const home = AppRouteModel(name: 'home', path: '/');

  // ===========================================================================
  // GENERAL
  // ===========================================================================

  static const settings = AppRouteModel(name: 'settings', path: '/settings');

  static const help = AppRouteModel(name: 'help', path: '/help');

  // ===========================================================================
  // ROOM
  // ===========================================================================

  static const createRoom = AppRouteModel(
    name: 'create-room',
    path: '/create-room',
  );

  static const joinRoom = AppRouteModel(name: 'join-room', path: '/join-room');

  static const publicRooms = AppRouteModel(
    name: 'public-rooms',
    path: '/public-rooms',
  );

  // ===========================================================================
  // LOCAL GAME
  // ===========================================================================

  static const localGame = AppRouteModel(
    name: 'local-game',
    path: '/local-game',
  );

  static const localGameBoard = AppRouteModel(
    name: 'local-game-board',
    path: '/board',
  );

  // ===========================================================================
  // ONLINE GAME
  // ===========================================================================

  static const game = AppRouteModel(name: 'game', path: '/game/:roomCode');

  // ===========================================================================
  // RESULT
  // ===========================================================================

  static const result = AppRouteModel(name: 'result', path: '/result');
}
