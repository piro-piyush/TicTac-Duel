const Logger = require('../core/utils/logger');
const RoomService = require('../services/room_service');
const SocketResponse = require('../core/utils/socket_response');

function registerRoomSocket(io, socket) {
  // ---------------------------------------------------------------------------
  // Create Room
  // ---------------------------------------------------------------------------

  socket.on('create_room', async (data) => {
    try {
      Logger.info(
        'Create room request received',
        data,
      );

      const {
        playerName,
        symbol,
        theme,
      } = data;

      const room = await RoomService.createRoom({
        playerName,
        symbol,
        theme,
        socket,
      });

      Logger.success(
        `Room created: ${room.code}`,
      );

      Logger.info(
        'Room details',
        {
          id: room._id,
          code: room.code,
          occupancy: room.occupancy,
          maxRounds: room.maxRounds,
          currentRound: room.currentRound,
          theme: room.theme,
          isPlaying: room.isPlaying,
          turnIndex: room.turnIndex,
          turn: room.turn,
          players: room.players,
        },
      );

      socket.emit(
        'room_created',
        SocketResponse.success(room),
      );
    } catch (error) {
      Logger.error(
        'Failed to create room',
        error,
      );

      socket.emit(
        'room_error',
        SocketResponse.error(error.message),
      );
    }
  });

  // ---------------------------------------------------------------------------
  // Join Room
  // ---------------------------------------------------------------------------

  socket.on('join_room', async (data) => {
    try {
      Logger.info(
        'Join room request received',
        data,
      );

      const {
        roomCode,
        playerName,
      } = data;

      const room = await RoomService.joinRoom({
        roomCode,
        playerName,
        socket,
      });

      Logger.success(
        `Player "${playerName}" joined room: ${room.code}`,
      );

      Logger.info(
        'Room details',
        {
          id: room._id,
          code: room.code,
          occupancy: room.occupancy,
          maxRounds: room.maxRounds,
          currentRound: room.currentRound,
          theme: room.theme,
          isPlaying: room.isPlaying,
          turnIndex: room.turnIndex,
          turn: room.turn,
          players: room.players,
        },
      );

      // Tell the joining player.
      socket.emit(
        'room_joined',
        SocketResponse.success(room),
      );

      // Tell the existing player.
      socket.to(room.code).emit(
        'player_joined',
        SocketResponse.success(room),
      );
    } catch (error) {
      Logger.error(
        'Failed to join room',
        error,
      );

      socket.emit(
        'room_error',
        SocketResponse.error(error.message),
      );
    }
  });

  // ---------------------------------------------------------------------------
  // Make Move
  // ---------------------------------------------------------------------------

  socket.on('make_move', async (data) => {
    try {
      Logger.info(
        'Make Move request received',
        data,
      );

      const {
        roomCode,
        index,
      } = data;

      const result = await RoomService.makeMove({
        roomCode,
        index,
        socket,
      });

      Logger.success(
        `Move made in room: ${result.room.code}`
      );

      Logger.info(
        'Move details',
        result,
      );

      // Notify both players that the move was made.
      io.to(result.room.code).emit(
        'move_made',
        SocketResponse.success(result),
      );
    } catch (error) {
      Logger.error(
        'Failed to make move',
        error,
      );

      socket.emit(
        'room_error',
        SocketResponse.error(error.message),
      );
    }
  });
}

module.exports = registerRoomSocket;