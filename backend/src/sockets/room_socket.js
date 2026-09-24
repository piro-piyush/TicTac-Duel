const Logger = require('../core/utils/logger');
const RoomService = require('../services/room_service');
const SocketResponse = require('../core/utils/socket_response');
const {
  ROOM_SOCKET_EVENTS,
} = require('../core/constants/socket_events');

function registerRoomSocket(io, socket) {
  // ---------------------------------------------------------------------------
  // Create Room
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.CREATE_ROOM,
    async (data) => {
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
            roundStatus: room.roundStatus,
            isPlaying: room.isPlaying,
            turnIndex: room.turnIndex,
            turn: room.turn,
            players: room.players,
          },
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_CREATED,
          SocketResponse.success(room),
        );
      } catch (error) {
        Logger.error(
          'Failed to create room',
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(error.message),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Join Room
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.JOIN_ROOM,
    async (data) => {
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
            roundStatus: room.roundStatus,
            isPlaying: room.isPlaying,
            turnIndex: room.turnIndex,
            turn: room.turn,
            players: room.players,
          },
        );

        // Tell joining player.
        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_JOINED,
          SocketResponse.success(room),
        );

        // Tell existing player.
        socket.to(room.code).emit(
          ROOM_SOCKET_EVENTS.PLAYER_JOINED,
          SocketResponse.success(room),
        );
      } catch (error) {
        Logger.error(
          'Failed to join room',
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(error.message),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Make Move
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.MAKE_MOVE,
    async (data) => {
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
          `Move made in room: ${result.room.code}`,
        );

        Logger.info(
          'Move details',
          result,
        );

        // Notify both players.
        io.to(result.room.code).emit(
          ROOM_SOCKET_EVENTS.MOVE_MADE,
          SocketResponse.success(result),
        );
      } catch (error) {
        Logger.error(
          'Failed to make move',
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(error.message),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Submit Game Result
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.SUBMIT_GAME_RESULT,
    async (data) => {
      try {
        Logger.info(
          'Submit game result request received',
          data,
        );

        const {
          roomCode,
          winnerSocketId,
          winningIndexes,
        } = data;

        const result =
          await RoomService.submitGameResult({
            roomCode,
            winnerSocketId,
            winningIndexes,
            socket,
          });

        Logger.success(
          `Round result submitted for room: ${result.room.code}`,
        );

        Logger.info(
          'Round result',
          {
            roomCode: result.room.code,
            round: result.room.currentRound,
            roundStatus: result.room.roundStatus,
            winnerSocketId: result.winnerSocketId,
            winningIndexes: result.winningIndexes,
            gameFinished: result.gameFinished,
          },
        );

        // Notify both players.
        io.to(result.room.code).emit(
          ROOM_SOCKET_EVENTS.ROUND_RESULT,
          SocketResponse.success(result),
        );
      } catch (error) {
        Logger.error(
          'Failed to submit game result',
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(error.message),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Toggle Player Ready Status
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.TOGGLE_READY,
    async (data) => {
      try {
        Logger.info(
          'Toggle ready request received',
          data,
        );

        const {
          roomCode,
          isReady,
        } = data;

        const room =
          await RoomService.setPlayerReady({
            roomCode,
            isReady,
            socket,
          });

        Logger.success(
          `Player ${isReady ? 'ready' : 'unready'} in room: ${room.code}`,
        );

        Logger.info(
          'Ready status updated',
          {
            roomCode: room.code,
            round: room.currentRound,
            roundStatus: room.roundStatus,
            isPlaying: room.isPlaying,
            players: room.players,
          },
        );

        // Notify both players with updated room state.
        io.to(room.code).emit(
          ROOM_SOCKET_EVENTS.READY_UPDATED,
          SocketResponse.success(room),
        );
      } catch (error) {
        Logger.error(
          'Failed to update player ready status',
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(error.message),
        );
      }
    },
  );
}

module.exports = registerRoomSocket;