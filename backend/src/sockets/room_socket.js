const Logger = require('../core/utils/logger');
const RoomService = require('../services/room_service');

function registerRoomSocket(io, socket) {
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
          players: room.players
        },
      );

      socket.emit('room_created', {
        success: true,
        room,
      });

    } catch (error) {
      Logger.error(
        'Failed to create room',
        error,
      );

      socket.emit('room_error', {
        message: error.message,
      });
    }
  });

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
          players: room.players
        },
      );
      // Tell joining player.
      socket.emit('room_joined', {
        success: true,
        room,
      });

      // Tell everyone else in the room.
      socket.to(room.roomCode).emit('player_joined', {
        playerName,
        room,
      });

    } catch (error) {
      Logger.error(
        'Failed to join room',
        error,
      );

      socket.emit('room_error', {
        message: error.message,
      });
    }
  });
}

module.exports = registerRoomSocket;