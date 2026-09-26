import type {
  Response as ExpressResponse,
  Request,
} from "express";

import {
  playerSymbolEnum,
  roomThemeEnum,
  type PlayerSymbol,
  type RoomTheme,
} from "../db/schema.js";

import Response from "../core/utils/response.js";
import RoomService from "../services/room_service.js";

class RoomController {
  // ===========================================================================
  // GET ROOMS
  // ===========================================================================

  async getRooms(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const rooms = await RoomService.getRooms();

      return Response.success(res, {
        message: "Rooms found",
        data: rooms,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "An unexpected error occurred",
      });
    }
  }

  // ===========================================================================
  // GET ROOM
  // ===========================================================================

  async getRoom(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { id } = req.params;

      if (
        typeof id !== "string" ||
        !id.trim()
      ) {
        return Response.badRequest(
          res,
          "Invalid room ID",
        );
      }

      const room = await RoomService.getRoomById(
        id,
      );

      if (!room) {
        return Response.notFound(
          res,
          "Room not found",
        );
      }

      return Response.success(res, {
        message: "Room found",
        data: room,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "An unexpected error occurred",
      });
    }
  }

  // ===========================================================================
  // CREATE ROOM
  // ===========================================================================

  async createRoom(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const {
        playerId,
        playerName,
        symbol,
        theme,
        maxRounds,
        isPrivate,
      } = req.body;

      if (
        typeof playerId !== "string" ||
        !playerId.trim()
      ) {
        return Response.badRequest(
          res,
          "Player ID is required",
        );
      }

      if (
        typeof playerName !== "string" ||
        !playerName.trim()
      ) {
        return Response.badRequest(
          res,
          "Player name is required",
        );
      }

      if (!isPlayerSymbol(symbol)) {
        return Response.badRequest(
          res,
          "Invalid player symbol",
        );
      }

      if (!isRoomTheme(theme)) {
        return Response.badRequest(
          res,
          "Invalid room theme",
        );
      }

      if (
        typeof maxRounds !== "number" ||
        !Number.isInteger(maxRounds) ||
        maxRounds <= 0
      ) {
        return Response.badRequest(
          res,
          "Invalid maximum rounds",
        );
      }

      if (typeof isPrivate !== "boolean") {
        return Response.badRequest(
          res,
          "isPrivate must be a boolean",
        );
      }

      const room = await RoomService.createRoom({
        playerId: playerId.trim(),
        playerName: playerName.trim(),
        symbol,
        theme,
        maxRounds,
        isPrivate,
      });

      return Response.created(res, {
        message: "Room created successfully",
        data: room,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "An unexpected error occurred",
      });
    }
  }

  // ===========================================================================
  // JOIN ROOM
  // ===========================================================================

  async joinRoom(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const {
        playerId,
        playerName,
        roomCode,
      } = req.body;

      if (
        typeof playerId !== "string" ||
        !playerId.trim()
      ) {
        return Response.badRequest(
          res,
          "Player ID is required",
        );
      }

      if (
        typeof playerName !== "string" ||
        !playerName.trim()
      ) {
        return Response.badRequest(
          res,
          "Player name is required",
        );
      }

      if (
        typeof roomCode !== "string" ||
        !roomCode.trim()
      ) {
        return Response.badRequest(
          res,
          "Room Code is required",
        );
      }

      const room = await RoomService.joinRoom({
        playerId: playerId.trim(),
        playerName: playerName.trim(),
        roomCode: roomCode.trim(),
      });

      if (!room) {
        return Response.notFound(
          res,
          "Room not found",
        );
      }

      return Response.success(res, {
        message: "Room joined successfully",
        data: room,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "An unexpected error occurred",
      });
    }
  }

  // ===========================================================================
  // DELETE ROOM
  // ===========================================================================

  async deleteRoom(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { id } = req.params;

      if (
        typeof id !== "string" ||
        !id.trim()
      ) {
        return Response.badRequest(
          res,
          "Invalid room ID",
        );
      }

      const room = await RoomService.deleteRoom(
        id.trim(),
      );

      if (!room) {
        return Response.notFound(
          res,
          "Room not found",
        );
      }

      return Response.success(res, {
        message: "Room deleted",
        data: room,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "An unexpected error occurred",
      });
    }
  }
}

// =============================================================================
// TYPE GUARDS
// =============================================================================

function isPlayerSymbol(
  value: unknown,
): value is PlayerSymbol {
  return (
    typeof value === "string" &&
    playerSymbolEnum.enumValues.includes(
      value as PlayerSymbol,
    )
  );
}

function isRoomTheme(
  value: unknown,
): value is RoomTheme {
  return (
    typeof value === "string" &&
    roomThemeEnum.enumValues.includes(
      value as RoomTheme,
    )
  );
}

export default new RoomController();