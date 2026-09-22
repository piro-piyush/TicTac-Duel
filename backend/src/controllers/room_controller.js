const Response = require('../core/utils/response');
const RoomService = require('../services/room_service');

class RoomController {
  async getRoom(req, res) {
    try {
      const { roomCode } = req.params;

      const room = await RoomService.getRoom(
        roomCode,
      );

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
    } catch (error) {
      return Response.error(res, {
        message: error.message,
      });
    }
  }
}

module.exports = new RoomController();