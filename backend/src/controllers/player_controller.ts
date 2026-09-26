import type {
  Response as ExpressResponse,
  Request,
} from "express";

import Response from "../core/utils/response.js";
import PlayerService from "../services/player_service.js";

class PlayerController {
  async initialize(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { playerId } = req.body;

      if (
        typeof playerId !== "string" ||
        playerId.trim().length === 0
      ) {
        return Response.badRequest(
          res,
          "Invalid player ID",
        );
      }

      const player =
        await PlayerService.initializePlayer({
          playerId: playerId.trim(),
        });

      return Response.success(res, {
        message: "Player initialized",
        data: player,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "Failed to initialize player",
      });
    }
  }

  async getPlayer(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { playerId } = req.params;

      if (typeof playerId !== "string") {
        return Response.badRequest(
          res,
          "Invalid player ID",
        );
      }

      const player =
        await PlayerService.getPlayer(playerId);

      if (!player) {
        return Response.notFound(
          res,
          "Player not found",
        );
      }

      return Response.success(res, {
        message: "Player found",
        data: player,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "Failed to get player",
      });
    }
  }

  async getPlayers(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const players = await PlayerService.getPlayers();

      return Response.success(res, {
        message: "Players found",
        data: players,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "Failed to get players",
      });
    }
  }

  async deletePlayer(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { playerId } = req.params;

      if (typeof playerId !== "string") {
        return Response.badRequest(
          res,
          "Invalid player ID",
        );
      }

      const player =
        await PlayerService.deletePlayer(playerId);

      if (!player) {
        return Response.notFound(
          res,
          "Player not found",
        );
      }

      return Response.success(res, {
        message: "Player deleted",
        data: player,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : "Failed to delete player",
      });
    }
  }
}

export default new PlayerController();