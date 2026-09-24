import {
  Response as ExpressResponse,
  Request,
} from 'express';

import Response from '../core/utils/response';
import RoomService from '../services/room_service';

class RoomController {
  async getRoom(
    req: Request,
    res: ExpressResponse,
  ): Promise<ExpressResponse> {
    try {
      const { roomCode } = req.params;

      if (typeof roomCode !== 'string') {
        return Response.badRequest(
          res,
          'Invalid room code',
        );
      }

      const room =
        await RoomService.getRoom(roomCode);

      if (!room) {
        return Response.notFound(
          res,
          'Room not found',
        );
      }

      return Response.success(res, {
        message: 'Room found',
        data: room,
      });
    } catch (error: unknown) {
      return Response.error(res, {
        message:
          error instanceof Error
            ? error.message
            : 'An unexpected error occurred',
      });
    }
  }
}

export default new RoomController();