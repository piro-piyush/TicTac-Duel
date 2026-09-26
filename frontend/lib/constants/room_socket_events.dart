class RoomSocketEvents {
  RoomSocketEvents._();

  // Requests
  static const createRoom = 'create_room';
  static const joinRoom = 'join_room';
  static const leaveRoom = 'leave_room';

  // Room events
  static const roomCreated = 'room_created';
  static const roomJoined = 'room_joined';
  static const roomUpdated = 'room_updated';
  static const roomError = 'room_error';

  // Player events
  static const playerJoined = 'player_joined';
  static const playerLeft = 'player_left';

  // Game events
  static const gameStarted = 'game_started';
  static const gameEnded = 'game_ended';
  static const gameError = 'game_error';

  // Move events
  static const makeMove = 'make_move';
  static const moveMade = 'move_made';

  static const submitGameResult = 'submit_game_result';
  static const roundResult = 'round_result';
  static const toggleReady = 'toggle_ready';
  static const readyUpdated = 'ready_updated';
  static const connectRoom = 'connect_room';
}