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
}