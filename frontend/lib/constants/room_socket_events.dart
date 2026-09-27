class RoomSocketEvents {
  RoomSocketEvents._();

  // Room connection
  static const connectRoom = 'connect_room';
  static const roomConnected = 'room_connected';

  // Move
  static const makeMove = 'make_move';
  static const moveMade = 'move_made';

  // Game result
  static const submitGameResult = 'submit_game_result';
  static const roundResult = 'round_result';

  // Ready state
  static const toggleReady = 'toggle_ready';
  static const readyUpdated = 'ready_updated';

  static const playerJoined = 'player_joined';
  static const playerLeft = 'player_left';

  // Errors
  static const roomError = 'room_error';
}

class SocketEvents {
  SocketEvents._();

  // Connection
  static const connect = 'connect';
  static const disconnect = 'disconnect';
  static const connectError = 'connect_error';
  static const error = 'error';

  // // Reconnection
  // static const reconnect = 'reconnect';
  // static const reconnectAttempt = 'reconnect_attempt';
  // static const reconnectError = 'reconnect_error';
  // static const reconnectFailed = 'reconnect_failed';
}

class SocketConstants {
  SocketConstants._();

  // ===========================================================================
  // TRANSPORT
  // ===========================================================================

  static const websocketTransport = 'websocket';

  // ===========================================================================
  // RECONNECTION
  // ===========================================================================

  static const maxReconnectionAttempts = 5;

  static const reconnectionDelay = 1000;

  static const maxReconnectionDelay = 5000;

  // ===========================================================================
  // MESSAGES
  // ===========================================================================

  static const notConnectedMessage = 'Socket is not connected.';

  static const disposedMessage = 'SocketService has already been disposed.';

  static const alreadyConnectedMessage = 'Socket is already connected.';

  static const connectingMessage = 'Connecting to Socket.IO server...';

  static const connectedMessage = 'Socket connected';

  static const disconnectedMessage = 'Socket disconnected';

  static const connectionErrorMessage = 'Socket connection error';

  static const socketErrorMessage = 'Socket error';

  static const reconnectedMessage = 'Socket reconnected';

  static const reconnectAttemptMessage = 'Socket reconnect attempt';

  static const reconnectionErrorMessage = 'Socket reconnection error';

  static const reconnectionFailedMessage = 'Socket reconnection failed';

  static const cannotEmitMessage = 'Cannot emit';

  static const emitMessage = 'Emitting socket event';

  static const disconnectingMessage = 'Disconnecting socket...';

  static const disposingMessage = 'Disposing socket service...';
  static const genericErrorMessage = 'Something went wrong.';
}
