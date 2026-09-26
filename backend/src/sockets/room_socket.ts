import type { Server, Socket } from "socket.io";

import { ROOM_SOCKET_EVENTS } from "../core/constants/socket_events.js";
import Logger from "../core/utils/logger.js";
import SocketResponse from "../core/utils/socket_response.js";
import RoomService from "../services/room_service.js";

// -----------------------------------------------------------------------------
// Socket Request Types
// -----------------------------------------------------------------------------

interface ConnectRoomData {
  roomCode: string;
  playerId: string;
}

interface MakeMoveData {
  roomCode: string;
  playerId: string;
  index: number;
}

interface SubmitGameResultData {
  roomCode: string;
  playerId: string;
  winnerPlayerId: string | null;
  winningIndexes: number[];
}

interface ToggleReadyData {
  roomCode: string;
  playerId: string;
  isReady: boolean;
}

// -----------------------------------------------------------------------------
// Room Socket
// -----------------------------------------------------------------------------

function registerRoomSocket(
  io: Server,
  socket: Socket,
): void {
  // ---------------------------------------------------------------------------
  // Connect Player To Room
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.CONNECT_ROOM,
    async (data: ConnectRoomData): Promise<void> => {
      try {
        const {
          roomCode,
          playerId,
        } = data;

        if (
          typeof roomCode !== "string" ||
          !roomCode.trim()
        ) {
          throw new Error("Room code is required");
        }

        if (
          typeof playerId !== "string" ||
          !playerId.trim()
        ) {
          throw new Error("Player ID is required");
        }

        const normalizedRoomCode = roomCode
          .trim()
          .toUpperCase();

        const normalizedPlayerId = playerId.trim();

        Logger.info(
          "Connect room request received",
          {
            roomCode: normalizedRoomCode,
            playerId: normalizedPlayerId,
          },
        );

        const room = await RoomService.getRoom(
          normalizedRoomCode,
        );

        if (!room) {
          throw new Error("Room not found");
        }

        const player = room.players.find(
          (player) =>
            player.id === normalizedPlayerId,
        );

        if (!player) {
          throw new Error(
            "Player is not a member of this room",
          );
        }

        // Leave any previously joined Socket.IO room.
        for (const joinedRoom of socket.rooms) {
          if (joinedRoom !== socket.id) {
            socket.leave(joinedRoom);
          }
        }

        // Join the database room ID.
        socket.join(room.id);

        Logger.success(
          `Player connected to room: ${room.code}`,
        );

        Logger.info(
          "Room socket joined",
          {
            roomId: room.id,
            roomCode: room.code,
            playerId: normalizedPlayerId,
          },
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_CONNECTED,
          SocketResponse.success({
            room,
            playerId: normalizedPlayerId,
          }),
        );
      } catch (error: unknown) {
        Logger.error(
          "Failed to connect player to room",
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(
            error instanceof Error
              ? error.message
              : "Failed to connect to room",
          ),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Make Move
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.MAKE_MOVE,
    async (
      data: MakeMoveData,
    ): Promise<void> => {
      try {
        const {
          roomCode,
          playerId,
          index,
        } = data;

        if (
          typeof roomCode !== "string" ||
          !roomCode.trim()
        ) {
          throw new Error("Room code is required");
        }

        if (
          typeof playerId !== "string" ||
          !playerId.trim()
        ) {
          throw new Error("Player ID is required");
        }

        Logger.info(
          "Make move request received",
          {
            roomCode,
            playerId,
            index,
          },
        );

        const result = await RoomService.makeMove({
          roomCode: roomCode.trim().toUpperCase(),
          playerId: playerId.trim(),
          index,
        });

        Logger.success(
          `Move made in room: ${result.room.code}`,
        );

        Logger.info(
          "Move details",
          {
            roomCode: result.room.code,
            playerId: playerId.trim(),
            index: result.move.index,
            symbol: result.move.symbol,
            turnPlayerId:
              result.room.turnPlayerId,
            turnIndex:
              result.room.turnIndex,
          },
        );

        io.to(result.room.id).emit(
          ROOM_SOCKET_EVENTS.MOVE_MADE,
          SocketResponse.success(result),
        );
      } catch (error: unknown) {
        Logger.error(
          "Failed to make move",
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(
            error instanceof Error
              ? error.message
              : "Failed to make move",
          ),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Submit Game Result
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.SUBMIT_GAME_RESULT,
    async (
      data: SubmitGameResultData,
    ): Promise<void> => {
      try {
        const {
          roomCode,
          playerId,
          winnerPlayerId,
          winningIndexes,
        } = data;

        if (
          typeof roomCode !== "string" ||
          !roomCode.trim()
        ) {
          throw new Error("Room code is required");
        }

        if (
          typeof playerId !== "string" ||
          !playerId.trim()
        ) {
          throw new Error("Player ID is required");
        }

        Logger.info(
          "Submit game result request received",
          {
            roomCode,
            playerId,
            winnerPlayerId,
            winningIndexes,
          },
        );

        const result =
          await RoomService.submitGameResult({
            roomCode: roomCode.trim().toUpperCase(),
            playerId: playerId.trim(),
            winnerPlayerId,
            winningIndexes,
          });

        Logger.success(
          `Round result submitted for room: ${result.room.code}`,
        );

        Logger.info(
          "Round result",
          {
            roomCode: result.room.code,
            round: result.completedRound,
            roundStatus:
              result.room.roundStatus,
            playerId: playerId.trim(),
            winnerPlayerId:
              result.winnerPlayerId,
            winningIndexes:
              result.winningIndexes,
            gameFinished:
              result.gameFinished,
          },
        );

        io.to(result.room.id).emit(
          ROOM_SOCKET_EVENTS.ROUND_RESULT,
          SocketResponse.success(result),
        );
      } catch (error: unknown) {
        Logger.error(
          "Failed to submit game result",
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(
            error instanceof Error
              ? error.message
              : "Failed to submit game result",
          ),
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Toggle Player Ready Status
  // ---------------------------------------------------------------------------

  socket.on(
    ROOM_SOCKET_EVENTS.TOGGLE_READY,
    async (
      data: ToggleReadyData,
    ): Promise<void> => {
      try {
        const {
          roomCode,
          playerId,
          isReady,
        } = data;

        if (
          typeof roomCode !== "string" ||
          !roomCode.trim()
        ) {
          throw new Error("Room code is required");
        }

        if (
          typeof playerId !== "string" ||
          !playerId.trim()
        ) {
          throw new Error("Player ID is required");
        }

        if (typeof isReady !== "boolean") {
          throw new Error(
            "Ready status must be a boolean",
          );
        }

        Logger.info(
          "Toggle ready request received",
          {
            roomCode,
            playerId,
            isReady,
          },
        );

        const room =
          await RoomService.setPlayerReady({
            roomCode: roomCode.trim().toUpperCase(),
            playerId: playerId.trim(),
            isReady,
          });

        Logger.success(
          `Player ${isReady ? "ready" : "unready"
          } in room: ${room.code}`,
        );

        Logger.info(
          "Ready status updated",
          {
            roomCode: room.code,
            playerId: playerId.trim(),
            currentRound: room.currentRound,
            roundStatus: room.roundStatus,
          },
        );

        io.to(room.id).emit(
          ROOM_SOCKET_EVENTS.READY_UPDATED,
          SocketResponse.success(room),
        );
      } catch (error: unknown) {
        Logger.error(
          "Failed to update player ready status",
          error,
        );

        socket.emit(
          ROOM_SOCKET_EVENTS.ROOM_ERROR,
          SocketResponse.error(
            error instanceof Error
              ? error.message
              : "Failed to update ready status",
          ),
        );
      }
    },
  );
}

export default registerRoomSocket;