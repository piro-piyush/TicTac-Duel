const { Server } = require('socket.io');

const Logger = require('../core/utils/logger');
const registerRoomSocket = require('./room_socket');

class SocketService {
  constructor(server) {
    this.io = new Server(server, {
      cors: {
        origin: '*',
      },
    });

    this._registerConnection();
  }

  _registerConnection() {
    this.io.on('connection', (socket) => {
      Logger.info(
        `Player connected: ${socket.id}`,
      );

      registerRoomSocket(
        this.io,
        socket,
      );

      socket.on('disconnect', (reason) => {
        Logger.info(
          `Player disconnected: ${socket.id}`,
          { reason },
        );
      });

      socket.on('error', (error) => {
        Logger.error(
          `Socket error: ${socket.id}`,
          error,
        );
      });
    });
  }

  getIO() {
    return this.io;
  }
}

module.exports = SocketService;