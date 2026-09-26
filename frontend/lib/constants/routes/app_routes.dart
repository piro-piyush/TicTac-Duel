
abstract final class AppRoutes {
  AppRoutes._();

  // ===========================================================================
  // PATHS
  // ===========================================================================

  static const home = '/';

  static const createRoom = '/create-room';
  static const waitingRoom = '/waiting-room';
  static const joinRoom = '/join-room';
  static const game = '/game/:id';
  static const result = '/result';
  static const settings = '/settings';
  static const privacyPolicy = '/privacy-policy';
  static const help = '/help';

  // ===========================================================================
  // NAMES
  // ===========================================================================

  static const homeName = 'home';
  static const createRoomName = 'createRoom';
  static const waitingRoomName = 'waitingRoom';
  static const joinRoomName = 'joinRoom';
  static const gameName = 'game';
  static const resultName = 'result';
  static const settingsName = 'settings';
  static const privacyPolicyName = 'privacyPolicy';
  static const helpName = 'help';
}